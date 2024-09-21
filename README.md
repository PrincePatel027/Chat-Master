
# Bubbly Chatting App

Bubbly Chatting App is a Flutter-based messaging application that enables real-time messaging between users. The app leverages Firebase for backend services and Firebase Cloud Messaging (FCM) for push notifications.

## Features

- Real-time messaging
- Push notifications using Firebase Cloud Messaging (FCM)
- Customizable light theme
- Multiple pages: Splash, Login, Home, and Chat

### Run the App

1. Install all dependencies by running:
    ```bash
    flutter pub get
    ```
2. Start the app on an emulator or physical device:
    ```bash
    flutter run
    ```

## Code Structure

- `main.dart`: The main entry point of the app, responsible for initializing Firebase and setting up routes.
- `views/pages/`: Contains the app's different screens (Splash, Login, Home, Chat).
- `helper/`: Utility classes like `LNotificationHelper` for handling local notifications.
- `components/`: Reusable UI components like `MyLightTheme` for customizing the app's theme.

## Firebase Cloud Messaging (FCM)

- Push notifications are powered by Firebase Cloud Messaging (FCM).
- The `backgroundMessageHandler` function handles background notifications.
- The app listens for messages and notifications using:
  - `FirebaseMessaging.onMessage` (for foreground messages)
  - `FirebaseMessaging.onBackgroundMessage` (for background notifications)
