from flask import Flask, jsonify
import psutil
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return "Kubernetes Monitoring API"

@app.route("/health")
def health():
    return jsonify({"status": "UP"})

@app.route("/cpu")
def cpu():
    return jsonify({
        "cpu_percent": psutil.cpu_percent(interval=1)
    })

@app.route("/memory")
def memory():
    mem = psutil.virtual_memory()

    return jsonify({
        "total": mem.total,
        "used": mem.used,
        "percent": mem.percent
    })

@app.route("/disk")
def disk():
    disk = psutil.disk_usage('/')

    return jsonify({
        "total": disk.total,
        "used": disk.used,
        "percent": disk.percent
    })

@app.route("/hostname")
def hostname():
    return jsonify({
        "hostname": socket.gethostname()
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)