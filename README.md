# Employee Task Management System

A full-stack enterprise task management solution featuring a Flutter mobile application, a FastAPI backend, and a MySQL database. This project was developed as part of a Full Stack Developer Assessment.

## Project Overview

The Employee Task Management System provides a secure and efficient platform for employees to manage their daily responsibilities. The system emphasizes high performance, secure authentication, and a premium user experience.

### Live URLs & Submission Details
- **Backend API URL**: [https://your-app-name.onrender.com](https://your-app-name.onrender.com)
- **Test Credentials**:
  - **Email**: testuser@example.com
  - **Password**: password123

## Core Features

### Mobile Application (Flutter)
- **Authentication**: JWT-based secure registration and login with session persistence.
- **Task Management**: Full CRUD operations with optimistic UI updates for instant feedback.
- **Organization**: Advanced search and real-time status-based filtering (Pending, In Progress, Completed).
- **Premium UI/UX**: Custom Material 3 dark theme with glassmorphism effects, fluid animations, and high-contrast priority indicators.
- **State Management**: Optimized Provider pattern implementation for efficient UI rebuilds.

### Backend API (FastAPI)
- **Architecture**: Modular clean architecture with decoupled routers, schemas, and models.
- **Security**: OAuth2 password flow with JWT (HS256) and bcrypt hashing.
- **Data Integrity**: Strict validation using Pydantic models.
- **Persistence**: Relational mapping using SQLAlchemy with a MySQL database.

### Admin Dashboard (React Bonus)
- Organizational-level view of users and tasks.
- Productivity metrics and administrative management tools.

---

## Technical Stack

- **Frontend**: Flutter (Latest Stable), Provider, Dio, SharedPreferences, Google Fonts.
- **Backend**: Python, FastAPI, SQLAlchemy, MySQL, JWT (jose), Passlib.
- **Admin**: React.js, Vite.
- **Infrastructure**: Render (API), MySQL (Relational DB).

---

## Technical Expectations Met

### Flutter
- Adherence to Clean Architecture principles.
- Responsive design for multiple device profiles.
- Comprehensive error handling and network interceptors.
- Reusable component architecture.

### Backend
- Restful API design with clean endpoints.
- Robust authentication and authorization middleware.
- Optimized database queries and relationship mapping.

---

## Installation Summary

The system is configured for rapid deployment.

1. **Backend**: Dependencies installed via `pip install -r requirements.txt`. Server initiated via `uvicorn`.
2. **Flutter**: Base configuration located in `lib/core/constants.dart`. Built using standard Flutter toolchain.
3. **Deployment**: Backend deployed to Render with MySQL environment variables.

---

## Submission Artifacts
- **GitHub Repository**: [Link to Repository]
- **Documentation**: Professional setup and technical specifications included.
- **Release Binary**: APK generated with production API configurations.
