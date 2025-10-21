# Cloud Functions for EstacionaUNSA

This folder contains a Cloud Function that:

- Listens to Firebase Auth `onCreate` events.
- If the new user's email does not end with `@unsa.edu.pe`, the function deletes the user from Auth.
- Otherwise, creates a Firestore document at `users/{uid}` with basic profile fields.

Setup and deploy:

1. Install dependencies:

```powershell
cd functions
npm install
```

2. Login and select your Firebase project:

```powershell
firebase login
firebase use --add
```

3. Deploy the function:

```powershell
firebase deploy --only functions:processNewUser
```

Notes:
- Ensure your Firebase project is the same one used by the Flutter app (the `firebase_options.dart` config).
- You may want to review logs after the first tests:

```powershell
firebase functions:log --only processNewUser
```
