import os

from fastapi import FastAPI

app = FastAPI(
    title="CloudOps AI Assistant",
    description="GenAI and MCP-based CloudOps assistant",
    version="0.2.0",
)


@app.get("/")
def root():
    return {
        "service": "CloudOps AI Assistant",
        "status": "running",
        "version": "0.2.0",
        "pod": os.getenv("POD_NAME", "unknown"),
        "node": os.getenv("NODE_NAME", "unknown"),
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "pod": os.getenv("POD_NAME", "unknown"),
        "node": os.getenv("NODE_NAME", "unknown"),
    }