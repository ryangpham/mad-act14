importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyBTsRX5G-n7O8vfM1KMrMprsoMXrgOgfQo',
  appId: '1:379747040610:web:5a872956fc12c33c36003b',
  messagingSenderId: '379747040610',
  projectId: 'act14-29433',
  authDomain: 'act14-29433.firebaseapp.com',
  storageBucket: 'act14-29433.firebasestorage.app',
  measurementId: 'G-11H177M6D0',
});

firebase.messaging();
