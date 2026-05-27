from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth, tasks
from app.db.session import engine, Base
from app.core.config import settings

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.PROJECT_NAME)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, tags=["auth"])
app.include_router(tasks.router, prefix="/tasks", tags=["tasks"])

@app.get("/")
def root():
    return {"message": "Welcome to Employee Task Management API"}
