from fastapi import FastAPI

app = FastAPI(
    title="CloudOps AI Assistant",
    description="GenAI and MCP-based CloudOps assistant",
    version="0.1.0",
)


@app.get("/")
def root():
    return {
        "service": "CloudOps AI Assistant",
        "status": "running",
        "version": "0.1.0",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }