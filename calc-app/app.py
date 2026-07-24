from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Calculator API is running!"

@app.route("/add/<int:a>/<int:b>")
def add(a, b):
    return {"operation": "add", "result": a + b}

@app.route("/sub/<int:a>/<int:b>")
def sub(a, b):
    return {"operation": "subtract", "result": a - b}

@app.route("/mul/<int:a>/<int:b>")
def mul(a, b):
    return {"operation": "multiply", "result": a * b}

@app.route("/div/<int:a>/<int:b>")
def div(a, b):
    if b == 0:
        return {"error": "Division by zero is not allowed"}, 400
    return {"operation": "divide", "result": a / b}
@app.route("/square/<int:a>")
def square(a):
    return {"operation": "square", "result": a * a}
@app.route("/cube/<int:a>")
def cube(a):
    return {"operation":"cube","result":a*a*a}
@app.route("/mod/<int:a>/<int:b>")
def mod(a,b):
    return {"operation":"modulus","result":a%b}
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)