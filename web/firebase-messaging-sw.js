// Firebase Cloud Messaging Service Worker
// Version: 1.0.0
// Last Updated: 2025-12-02

importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// تهيئة Firebase
firebase.initializeApp({
  apiKey: 'AIzaSyAQwxzzbcexip9-VrPZnfbE30tME2zHNtg',
  appId: '1:615397637255:web:586fcfd7d906576ab14c22',
  messagingSenderId: '615397637255',
  projectId: 'idec-e9a1f',
  authDomain: 'idec-e9a1f.firebaseapp.com',
  storageBucket: 'idec-e9a1f.firebasestorage.app',
  measurementId: 'G-YNXX5R0FNG',
});

const messaging = firebase.messaging();

// تثبيت Service Worker فوراً
self.addEventListener('install', (event) => {
  console.log('🔧 [FCM-SW] Service Worker installing...');
  self.skipWaiting();
});

// تفعيل Service Worker فوراً
self.addEventListener('activate', (event) => {
  console.log('✅ [FCM-SW] Service Worker activated');
  event.waitUntil(self.clients.claim());
});

// معالجة الرسائل في الخلفية
messaging.onBackgroundMessage((payload) => {
  console.log('📬 [FCM-SW] Background message received:', payload);

  // إذا كانت الرسالة تحتوي على قسم notification، المتصفح سيعرضه تلقائياً
  if (payload.notification) {
    console.log('ℹ️ [FCM-SW] Message has notification, browser will handle it');
    return;
  }

  // معالجة رسائل data-only
  const notificationTitle = payload.data?.title || 'IDEC';
  const notificationOptions = {
    body: payload.data?.body || 'لديك إشعار جديد',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: payload.data?.tag || 'default',
    data: payload.data || {},
    requireInteraction: false,
    vibrate: [200, 100, 200],
  };

  // دعم Rich Notifications - إضافة صورة
  if (payload.data?.imageUrl) {
    notificationOptions.image = payload.data.imageUrl;
    console.log('🖼️ [FCM-SW] Added image to notification');
  }

  // دعم action buttons المخصصة
  if (payload.data?.actionButtons) {
    try {
      const buttons = JSON.parse(payload.data.actionButtons);
      if (Array.isArray(buttons) && buttons.length > 0) {
        notificationOptions.actions = buttons.slice(0, 2).map(btn => ({
          action: btn.action || 'default',
          title: btn.label || 'فتح',
          icon: '/icons/Icon-192.png',
        }));
        console.log('🔘 [FCM-SW] Added custom action buttons:', notificationOptions.actions);
      }
    } catch (error) {
      console.warn('⚠️ [FCM-SW] Error parsing action buttons:', error);
    }
  } else if (payload.data?.actionType) {
    // fallback لزر واحد
    notificationOptions.actions = [
      {
        action: 'open',
        title: 'فتح',
        icon: '/icons/Icon-192.png',
      },
    ];
  }

  // إضافة silent للإشعارات غير الهامة
  if (payload.data?.priority === 'LOW') {
    notificationOptions.silent = true;
  }

  // إضافة renotify للإشعارات العاجلة
  if (payload.data?.priority === 'URGENT') {
    notificationOptions.requireInteraction = true;
    notificationOptions.vibrate = [300, 100, 300, 100, 300];
    notificationOptions.renotify = true;
  }

  console.log('🔔 [FCM-SW] Showing notification:', notificationTitle);
  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// معالجة الضغط على الإشعار
self.addEventListener('notificationclick', (event) => {
  console.log('👆 [FCM-SW] Notification clicked:', event.notification.tag);
  console.log('👆 [FCM-SW] Action clicked:', event.action || 'default');
  
  event.notification.close();

  const notificationData = event.notification.data;
  
  // تحديد الـ URL بناءً على الزر المضغوط
  let targetUrl = '/';
  let actionType = notificationData.actionType;
  
  // إذا كان هناك action محدد من الأزرار
  if (event.action && event.action !== 'default' && event.action !== 'open') {
    actionType = event.action;
    console.log('🔘 [FCM-SW] Custom action button pressed:', actionType);
  }
  
  // Parse action data if available
  let actionData = {};
  try {
    if (notificationData.actionData) {
      actionData = typeof notificationData.actionData === 'string'
        ? JSON.parse(notificationData.actionData)
        : notificationData.actionData;
    }
  } catch (error) {
    console.warn('⚠️ [FCM-SW] Error parsing action data:', error);
  }

  // تحديد URL بناءً على actionType
  if (actionType) {
    switch (actionType) {
      case 'VIEW_REGISTRATION':
        if (actionData.registrationId || notificationData.registrationId) {
          targetUrl = `/registration/${actionData.registrationId || notificationData.registrationId}`;
        }
        break;
      case 'VIEW_EVENT':
        if (actionData.eventId || notificationData.eventId) {
          targetUrl = `/event/${actionData.eventId || notificationData.eventId}`;
        }
        break;
      case 'VIEW_CONFERENCE':
        if (actionData.conferenceId || notificationData.conferenceId) {
          targetUrl = `/conference/${actionData.conferenceId || notificationData.conferenceId}`;
        }
        break;
      case 'VIEW_PAYMENT':
        if (actionData.paymentId || notificationData.paymentId) {
          targetUrl = `/payment/${actionData.paymentId || notificationData.paymentId}`;
        }
        break;
      case 'VIEW_PROFILE':
        targetUrl = '/profile';
        break;
      case 'REGISTER':
        if (actionData.eventId || notificationData.eventId) {
          targetUrl = `/event/${actionData.eventId || notificationData.eventId}/register`;
        }
        break;
      default:
        targetUrl = '/notifications';
    }
  }

  console.log('🔗 [FCM-SW] Opening URL:', targetUrl);

  // تسجيل click event على الخادم (analytics)
  if (notificationData.deliveryId) {
    fetch(`${self.location.origin}/api/v1/system-message-deliveries/${notificationData.deliveryId}/click`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    }).catch(err => console.warn('⚠️ [FCM-SW] Failed to track click:', err));
  }

  // فتح أو التركيز على النافذة
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // البحث عن نافذة مفتوحة بالفعل
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          client.focus();
          client.navigate(targetUrl);
          return;
        }
      }
      
      // فتح نافذة جديدة إذا لم توجد نافذة مفتوحة
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});

// معالجة إغلاق الإشعار
self.addEventListener('notificationclose', (event) => {
  console.log('❌ [FCM-SW] Notification closed:', event.notification.tag);
});

console.log('🚀 [FCM-SW] Firebase Messaging Service Worker loaded successfully');


