from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    priority: str = "Medium"
    due_date: Optional[datetime] = None
    status: str = "Pending"

class TaskCreate(TaskBase):
    pass

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    priority: Optional[str] = None
    due_date: Optional[datetime] = None
    status: Optional[str] = None

class TaskResponse(TaskBase):
    id: int
    user_id: int

    class Config:
        from_attributes = True
