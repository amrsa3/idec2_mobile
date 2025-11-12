importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAQwxzzbcexip9-VrPZnfbE30tME2zHNtg',
  appId: '1:615397637255:web:586fcfd7d906576ab14c22',
  messagingSenderId: '615397637255',
  projectId: 'idec-e9a1f',
  storageBucket: 'idec-e9a1f.firebasestorage.app',
});

const messaging = firebase.messaging();

self.addEventListener('install', event => {
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(self.clients.claim());
});

messaging.onBackgroundMessage((payload) => {
  // إذا كانت الرسالة تحتوي على قسم notification فالمتصفح سيعرضه تلقائياً،
  // لذلك نتجنب إظهار تنبيه مكرر هنا.
  if (payload.notification) {
    return;
  }

  const notificationTitle = payload.data?.title ?? 'IDEC';
  const notificationOptions = {
    body: payload.data?.body ?? '',
    icon: '/icons/Icon-192.png',
    data: payload.data ?? {},
  };

  if (notificationOptions.body) {
    self.registration.showNotification(notificationTitle, notificationOptions);
  }
});


