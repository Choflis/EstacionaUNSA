const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const ALLOWED_DOMAIN = '@unsa.edu.pe';

exports.processNewUser = functions.auth.user().onCreate(async (user) => {
  const email = user.email || '';
  const uid = user.uid;
  const displayName = user.displayName || null;

  if (!email.endsWith(ALLOWED_DOMAIN)) {
    // Delete non-institutional user to prevent signup
    try {
      await admin.auth().deleteUser(uid);
      console.log(`Deleted non-institutional user ${email} (${uid})`);
    } catch (err) {
      console.error('Failed to delete user:', err);
    }
    return null;
  }

  const userRef = admin.firestore().doc(`users/${uid}`);
  const snap = await userRef.get();
  if (!snap.exists) {
    await userRef.set({
      uid,
      email,
      displayName,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      allowed: true
    });
    console.log(`Created user document for ${uid}`);
  } else {
    console.log(`User document already exists for ${uid}`);
  }

  return null;
});
