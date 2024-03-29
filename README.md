# 🏥 Medical Webinar Application 🚑

## Description

The Medical Webinar Application is a platform designed for healthcare professionals and patients to schedule and participate in medical webinars. Doctors can schedule and start webinars, patients can join by entering their username for authentication, and both parties can send messages during the webinar. The application features a simple user interface for easy navigation.

## Features

- 📅 Doctors can schedule and start webinars.
- 👩‍⚕️ Patients can join webinars by entering their username.
- 💬 Both doctors and patients can send messages during webinars.
- 📲 Users receive notifications for scheduled webinars.

## Technologies Used

### Backend

- 🖥️ Node.js
- 🚀 NestJS
- 📦 MongoDB for database storage
- 🖼️ GridFS for storing images
- 📚 Various small libraries for additional functionality

### Frontend

- 📱 Flutter
- 🎥 Agora for live streaming and comments
- 🍪 Shared Preferences for storing user authentication cookies
- 📣 flutter_local_notifications for local notifications

## Getting Started

### Prerequisites

- ✅ Node.js installed on your machine
- 🎨 Flutter SDK installed

### Installation

1. Clone the repository: `git clone <repository-url>`
2. Install backend dependencies: `cd backend && npm install`
3. Start the backend server: `npm start`
4. Install frontend dependencies: `cd ../frontend && flutter pub get`
5. Run the frontend app: `flutter run`

## Usage

1. Launch the application.
2. On the join page, enter your username and role (doctor or patient).
3. Explore the home page to view scheduled webinars.
4. Doctors can create webinars by providing a title, image, and scheduling information.
5. Join webinars as a viewer to participate and chat with the doctor.

## Contributors

- [Saeed Saydaliev] - Software developer 👨🏻‍💻
