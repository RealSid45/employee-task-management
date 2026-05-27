from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.db.session import Base
import datetime

class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(String(1000), nullable=True)
    priority = Column(String(50), default="Medium") # Low, Medium, High
    due_date = Column(DateTime, nullable=True)
    status = Column(String(50), default="Pending") # Pending, In Progress, Completed
    user_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="tasks")
