# Employee Task Management System

This is a simple app to manage employee tasks. It has a Flutter mobile app and a Python backend.

## Features
- Login and Register (JWT)
- Create, Edit, and Delete tasks
- Search and Filter tasks
- Cool dark theme

## Stuff I used
- **Frontend**: Flutter
- **Backend**: FastAPI (Python)
- **Database**: MySQL

## How to run the backend
1. Go to the `backend` folder.
2. Install the requirements: `pip install -r requirements.txt`.
3. Set your database details in `app/core/config.py`.
4. Run it: `uvicorn app.main:app --reload`.

## How to run the mobile app
1. Run `flutter pub get`.
2. Change the IP address in `lib/core/constants.dart`.
3. Run `flutter run`.

## Build the APK
Run `flutter build apk --release` to get the APK file.

## Test Account
- **Email**: sid@gmail.com
- **Password**: 123456

## Author
Sidharth Biju
