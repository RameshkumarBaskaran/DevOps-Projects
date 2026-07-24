from flask import Flask, request, jsonify
import os
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root123",
    database="employee_db"
)

cursor = db.cursor(dictionary=True)
from flask import Flask, request, jsonify

app = Flask(__name__)
db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME")
)

cursor = db.cursor(dictionary=True)

employees = [
    {"id": 1, "name": "Ramesh", "role": "DevOps"},
    {"id": 2, "name": "Kumar", "role": "Cloud Engineer"}
]

# Home
@app.route("/")
def home():
    return "Employee Management API"

@app.route("/employees", methods=["GET"])
def get_employees():

    cursor.execute("SELECT * FROM employees")

    result = cursor.fetchall()

    return jsonify(result)

# Get employee by ID
@app.route("/employees/<int:id>", methods=["GET"])
def get_employee(id):
    for emp in employees:
        if emp["id"] == id:
            return jsonify(emp)
    return {"message": "Employee not found"}, 404

# Add employee
@app.route("/employees", methods=["POST"])
def add_employee():
    data = request.get_json()
    employees.append(data)
    return {"message": "Employee added successfully"}, 201

# Update employee
@app.route("/employees/<int:id>", methods=["PUT"])
def update_employee(id):
    data = request.get_json()

    for emp in employees:
        if emp["id"] == id:
            emp["name"] = data["name"]
            emp["role"] = data["role"]
            return {"message": "Employee updated"}

    return {"message": "Employee not found"}, 404

# Delete employee
@app.route("/employees/<int:id>", methods=["DELETE"])
def delete_employee(id):

    for emp in employees:
        if emp["id"] == id:
            employees.remove(emp)
            return {"message": "Employee deleted"}

    return {"message": "Employee not found"}, 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)