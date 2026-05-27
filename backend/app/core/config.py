import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "Employee Task Management"
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-change-this")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7 # 1 week

    MYSQL_USER: str = os.getenv("MYSQL_USER", "root")
    MYSQL_PASSWORD: str = os.getenv("MYSQL_PASSWORD", "")
    MYSQL_SERVER: str = os.getenv("MYSQL_SERVER", "localhost")
    MYSQL_PORT: str = os.getenv("MYSQL_PORT", "3306")
    MYSQL_DB: str = os.getenv("MYSQL_DB", "task_management")
    DATABASE_URL: str = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_SERVER}:{MYSQL_PORT}/{MYSQL_DB}"

settings = Settings()
