from flask import Flask, render_template, request, redirect, session, jsonify
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
from dotenv import load_dotenv
import razorpay
import os
import time

app = Flask(__name__, static_folder="templates/static")
app.secret_key = "supersecretkey"
load_dotenv()

RAZORPAY_KEY_ID = os.getenv("RAZORPAY_KEY_ID")
RAZORPAY_KEY_SECRET = os.getenv("RAZORPAY_KEY_SECRET")

razorpay_client = razorpay.Client(auth=(RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET))

UPLOAD_FOLDER = "templates/static/payment_proofs"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


# ---------------- DB CONNECTION FUNCTION ----------------
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQLHOST"),
        user=os.getenv("MYSQLUSER"),
        password=os.getenv("MYSQLPASSWORD"),
        database=os.getenv("MYSQLDATABASE")
    )


# ---------------- IMPACT VISUALIZER ----------------
def get_impact(amount):
    amount = int(amount)

    if amount <= 100:
        return "1 meal provide ho sakta hai"

    elif amount <= 500:
        return "5 meals + basic support"

    elif amount <= 2000:
        return "1 child ki education support"

    elif amount <= 5000:
        return "1 family ka monthly ration support"

    else:
        return "Multiple families ka long-term support"


# ---------------- HOME ----------------
@app.route("/")
def home():
    return render_template("index.html")


# ---------------- REGISTER ----------------
@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")
        password_raw = request.form.get("password")
        role = request.form.get("role", "user")

        if not name or not email or not password_raw:
            return "Missing fields"

        password = generate_password_hash(password_raw)

        db = get_db_connection()
        cursor = db.cursor()

        cursor.execute(
            """
            INSERT INTO users (name, email, password_hash, role)
            VALUES (%s, %s, %s, %s)
            """,
            (name, email, password, role)
        )

        db.commit()
        cursor.close()
        db.close()

        return redirect("/login")

    return render_template("register.html")


# ---------------- LOGIN ----------------
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form.get("email")
        username = request.form.get("username")
        password = request.form.get("password")

        db = get_db_connection()
        cursor = db.cursor(dictionary=True)

        user = None

        if email:
            cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()

        elif username:
            cursor.execute("SELECT * FROM users WHERE name=%s", (username,))
            user = cursor.fetchone()

        cursor.close()
        db.close()

        if user and check_password_hash(user["password_hash"], password):
            session["user_id"] = user["id"]
            session["user_name"] = user["name"]
            session["role"] = user["role"]
            return redirect("/dashboard")

        return "Invalid credentials"

    return render_template("login.html")

# ---------------- FORGOT PASSWORD ----------------
@app.route("/forgot-password", methods=["GET", "POST"])
def forgot_password():
    message = None
    error = None
    email = request.form.get("email")

    if request.method == "POST":
        step = request.form.get("step")

        if step == "check_email":
            if not email:
                error = "Please enter your email"
                return render_template("forgot_password.html", message=message, error=error)

            db = get_db_connection()
            cursor = db.cursor(dictionary=True)

            cursor.execute("SELECT id, email FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()

            cursor.close()
            db.close()

            if not user:
                error = "No account found with this email"
                return render_template("forgot_password.html", message=message, error=error)

            return render_template(
                "forgot_password.html",
                email=email,
                show_reset=True,
                message=message,
                error=error
            )

        if step == "reset_password":
            new_password = request.form.get("new_password")
            confirm_password = request.form.get("confirm_password")

            if not email or not new_password or not confirm_password:
                error = "All fields are required"
                return render_template("forgot_password.html", email=email, show_reset=True, error=error)

            if new_password != confirm_password:
                error = "Passwords do not match"
                return render_template("forgot_password.html", email=email, show_reset=True, error=error)

            password_hash = generate_password_hash(new_password)

            db = get_db_connection()
            cursor = db.cursor()

            cursor.execute(
                "UPDATE users SET password_hash=%s WHERE email=%s",
                (password_hash, email)
            )

            db.commit()
            cursor.close()
            db.close()

            return redirect("/login")

    return render_template("forgot_password.html", message=message, error=error)

# ---------------- DASHBOARD ----------------
@app.route("/dashboard")
def dashboard():
    if "user_id" not in session:
        return redirect("/login")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT id, name, email, role FROM users WHERE id=%s",
        (session["user_id"],)
    )
    current_user = cursor.fetchone()

    if session.get("role") == "admin":
        cursor.execute(
            """
            SELECT *
            FROM donations
            WHERE status = %s
            ORDER BY id DESC
            """,
            ("paid",)
        )
        donations = cursor.fetchall()

        cursor.execute(
            """
            SELECT COALESCE(SUM(amount), 0) AS total_amount
            FROM donations
            WHERE status = %s
            """,
            ("paid",)
        )
        total_amount = cursor.fetchone()["total_amount"]

        try:
            cursor.execute("SELECT COUNT(*) AS project_count FROM projects")
            project_count = cursor.fetchone()["project_count"]
        except Exception:
            project_count = 0

        report_count = len(donations)

        cursor.close()
        db.close()

        for d in donations:
            d["impact"] = get_impact(d["amount"])

        return render_template(
            "admin_dashboard.html",
            donations=donations,
            admin=current_user,
            total_amount=total_amount,
            project_count=project_count,
            report_count=report_count,
            razorpay_key_id=RAZORPAY_KEY_ID
        )

    cursor.execute(
        """
        SELECT *
        FROM donations
        WHERE user_id = %s AND status = %s
        ORDER BY id DESC
        """,
        (session["user_id"], "paid")
    )
    donations = cursor.fetchall()

    cursor.close()
    db.close()

    for d in donations:
        d["impact"] = get_impact(d["amount"])

    return render_template(
        "user_dashboard.html",
        donations=donations,
        user=current_user,
        razorpay_key_id=RAZORPAY_KEY_ID
    )


# ---------------- DONATE ----------------
@app.route("/create_razorpay_order", methods=["POST"])
def create_razorpay_order():
    if "user_id" not in session:
        return jsonify({"error": "Login required"}), 401

    data = request.get_json()
    amount = int(data.get("amount", 0))

    if amount <= 0:
        return jsonify({"error": "Invalid amount"}), 400

    order = razorpay_client.order.create({
        "amount": amount * 100,
        "currency": "INR",
        "receipt": f"donation_{session['user_id']}_{int(time.time())}",
        "payment_capture": 1
    })

    return jsonify({
        "order_id": order["id"],
        "amount": order["amount"],
        "currency": order["currency"],
        "key_id": RAZORPAY_KEY_ID
    })


@app.route("/verify_razorpay_payment", methods=["POST"])
def verify_razorpay_payment():
    if "user_id" not in session:
        return jsonify({"error": "Login required"}), 401

    data = request.get_json()

    razorpay_order_id = data.get("razorpay_order_id")
    razorpay_payment_id = data.get("razorpay_payment_id")
    razorpay_signature = data.get("razorpay_signature")

    if not razorpay_order_id or not razorpay_payment_id or not razorpay_signature:
        return jsonify({
            "success": False,
            "error": "Missing payment details"
        }), 400

    params_dict = {
        "razorpay_order_id": razorpay_order_id,
        "razorpay_payment_id": razorpay_payment_id,
        "razorpay_signature": razorpay_signature
    }

    try:
        razorpay_client.utility.verify_payment_signature(params_dict)

        payment = razorpay_client.payment.fetch(razorpay_payment_id)
        amount = int(payment["amount"]) // 100

        db = get_db_connection()
        cursor = db.cursor()

        cursor.execute(
            """
            INSERT INTO donations (
                user_id,
                amount,
                razorpay_order_id,
                razorpay_payment_id,
                status
            )
            VALUES (%s, %s, %s, %s, %s)
            """,
            (
                session["user_id"],
                amount,
                razorpay_order_id,
                razorpay_payment_id,
                "paid"
            )
        )

        db.commit()
        cursor.close()
        db.close()

        return jsonify({"success": True})

    except Exception:
        return jsonify({
            "success": False,
            "error": "Payment verification failed"
        }), 400


# ---------------- PROJECTS ----------------
@app.route("/projects")
def projects():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT * FROM projects")
    projects = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("projects.html", projects=projects)

PROJECT_DETAILS = {
    "education": {
        "title": "Child Education Kit",
        "category": "Education",
        "image": "https://images.unsplash.com/photo-1497486751825-1233686d5d80?auto=format&fit=crop&w=1400&q=82",
        "summary": "Provide school supplies, notebooks, bags, and learning support for children from low-income families.",
        "impact": "₹2,000 can support one child’s complete education kit.",
        "goal": "₹2,50,000",
        "raised": "₹1,82,000",
        "progress": 72,
        "volunteers": "18",
        "urgency": "High impact"
    },
    "food": {
        "title": "Daily Meal Support",
        "category": "Food Relief",
        "image": "https://images.unsplash.com/photo-1593113598332-cd288d649433?auto=format&fit=crop&w=1400&q=82",
        "summary": "Fund freshly prepared meals for people who need immediate daily food assistance.",
        "impact": "₹500 can help provide meals and basic support.",
        "goal": "₹1,80,000",
        "raised": "₹1,30,000",
        "progress": 72,
        "volunteers": "24",
        "urgency": "Urgent"
    }
}


@app.route("/project/<slug>")
def project_detail(slug):
    project = PROJECT_DETAILS.get(slug)

    if not project:
        return redirect("/projects")

    return render_template("project_detail.html", project=project)

# ---------------- VOLUNTEER ----------------
@app.route("/volunteer", methods=["GET", "POST"])
def volunteer():
    if "user_id" not in session:
        return redirect("/login")

    if request.method == "POST":
        name = request.form.get("name")
        phone = request.form.get("phone")
        interest = request.form.get("interest")
        availability = request.form.get("availability")
        event_name = request.form.get("event_name")
        message = request.form.get("message")

        db = get_db_connection()
        cursor = db.cursor()

        cursor.execute(
            """
            INSERT INTO volunteers (
                user_id,
                event_name,
                name,
                phone,
                interest,
                availability,
                message
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                session["user_id"],
                event_name,
                name,
                phone,
                interest,
                availability,
                message
            )
        )

        db.commit()
        cursor.close()
        db.close()

        return redirect(f"/volunteer-success?event={event_name}")

    return render_template("volunteer.html")

# --------------success routes ----------
@app.route("/volunteer-success")
def volunteer_success():
    if "user_id" not in session:
        return redirect("/login")

    event_name = request.args.get("event", "selected mission")

    return render_template(
        "volunteer_success.html",
        event_name=event_name
    )
# ---------------- EVENTS ----------------
@app.route("/events")
def events():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT * FROM events")
    events = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("events.html", events=events)

# ---------------- REPORTS ----------------
@app.route("/report")
def report():
    if "user_id" not in session:
        return redirect("/login")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT id, name, email, role FROM users WHERE id=%s",
        (session["user_id"],)
    )
    current_user = cursor.fetchone()

    if session.get("role") == "admin":
        cursor.execute(
            """
            SELECT donations.*, users.name AS user_name, users.email AS user_email
            FROM donations
            JOIN users ON donations.user_id = users.id
            WHERE donations.status = %s
            ORDER BY donations.id DESC
            """,
            ("paid",)
        )
        reports = cursor.fetchall()

        cursor.execute(
            """
            SELECT volunteers.*, users.name AS user_name, users.email AS user_email
            FROM volunteers
            JOIN users ON volunteers.user_id = users.id
            ORDER BY volunteers.id DESC
            """
        )
        volunteer_reports = cursor.fetchall()

    else:
        cursor.execute(
            """
            SELECT *
            FROM donations
            WHERE user_id = %s AND status = %s
            ORDER BY id DESC
            """,
            (session["user_id"], "paid")
        )
        reports = cursor.fetchall()

        cursor.execute(
            """
            SELECT *
            FROM volunteers
            WHERE user_id = %s
            ORDER BY id DESC
            """,
            (session["user_id"],)
        )
        volunteer_reports = cursor.fetchall()

    cursor.close()
    db.close()

    for r in reports:
        r["impact"] = get_impact(r["amount"])

    return render_template(
        "report.html",
        reports=reports,
        volunteer_reports=volunteer_reports,
        user=current_user
    )
# ---------------- LOGOUT ----------------
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


# ---------------- RUN ----------------
if __name__ == "__main__":
    app.run(debug=True)
