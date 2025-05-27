// Give the service worker access to Firebase Messaging.
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your firebase config object.
// Replace with your own config if needed (or import the generated firebase_options.js).
firebase.initializeApp({
    apiKey: "AIzaSyCUMqYSPUXXZ6uuwfLv9R5ySGyuEGH-S2Y",
    authDomain: "gnb-task-flutter.firebaseapp.com",
    projectId: "gnb-task-flutter",
    storageBucket: "gnb-task-flutter.firebasestorage.app",
    messagingSenderId: "103839979737",
    appId: "1:103839979737:web:4fb6fa96fb96ae35e646c8",
    measurementId: "G-RPBTC2C0QQ"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
