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
  console.log('📬 [FCM-SW] ========== Background message received ==========');
  console.log('📬 [FCM-SW] Message ID:', payload.messageId || payload.fcmMessageId);
  console.log('📬 [FCM-SW] Payload data:', payload.data);
  console.log('📬 [FCM-SW] Payload data keys:', payload.data ? Object.keys(payload.data) : 'none');
  console.log('📬 [FCM-SW] Payload notification:', payload.notification);
  console.log('📬 [FCM-SW] Has notification:', !!payload.notification);
  console.log('📬 [FCM-SW] Has data:', !!(payload.data && Object.keys(payload.data).length > 0));
  
  // ✅ إضافة logging إضافي للتحقق من نوع الرسالة
  // ✅ إصلاح: تعريف messageCode مرة واحدة في بداية الدالة لاستخدامه في كلا الفرعين
  const messageCode = payload.data?.messageCode || payload.data?.systemMessageCode || 'UNKNOWN';
  console.log('📬 [FCM-SW] Message Code:', messageCode);
  console.log('📬 [FCM-SW] Action Type:', payload.data?.actionType);
  console.log('📬 [FCM-SW] Category:', payload.data?.category);

  // إذا كانت الرسالة تحتوي على قسم notification، المتصفح سيعرضه تلقائياً
  // لكن يجب أن نمرر البيانات أيضاً في notification.data
  if (payload.notification) {
    console.log('ℹ️ [FCM-SW] Message has notification, browser will handle it');
    
    // في web، عندما يكون هناك notification، البيانات قد لا تصل في message.data
    // لذا يجب أن نمرر البيانات في notification.data عند عرض الإشعار
    if (payload.data && Object.keys(payload.data).length > 0) {
      console.log('📬 [FCM-SW] Data found in payload.data, will include in notification.data');
      // البيانات ستكون متاحة في notificationclick event
    } else {
      console.warn('⚠️ [FCM-SW] No data found in payload.data');
    }
    
    // عرض الإشعار مع البيانات
    const notificationTitle = payload.notification.title || 'IDEC';
    const notificationBody = payload.notification.body || 'لديك إشعار جديد';
    const notificationOptions = {
      body: notificationBody,
      icon: '/icons/Icon-192.png',
      badge: '/icons/Icon-192.png',
      tag: payload.data?.tag || 'default',
      data: payload.data || {}, // تمرير البيانات في notification.data
      requireInteraction: false,
      vibrate: [200, 100, 200],
    };
    
    // إضافة البيانات المهمة مثل profileStatus
    if (payload.data?.profileStatus) {
      console.log('✅ [FCM-SW] Profile status found in data:', payload.data.profileStatus);
      notificationOptions.data.profileStatus = payload.data.profileStatus;
    }
    if (payload.data?.profileId) {
      console.log('✅ [FCM-SW] Profile ID found in data:', payload.data.profileId);
      notificationOptions.data.profileId = payload.data.profileId;
    }
    
    console.log('🔔 [FCM-SW] Showing notification with data:', notificationOptions.data);
    console.log('🔔 [FCM-SW] Notification title:', notificationTitle);
    console.log('🔔 [FCM-SW] Notification body:', notificationBody);
    console.log('🔔 [FCM-SW] Notification data keys:', Object.keys(notificationOptions.data));
    console.log('🔔 [FCM-SW] Message Code:', messageCode);
    
    // ✅ إصلاح: إرسال البيانات إلى Flutter عبر BroadcastChannel + postMessage
    // هذا يضمن تحديث حالة الملف الشخصي حتى لو لم يتم النقر على الإشعار
    if (payload.data && Object.keys(payload.data).length > 0) {
      try {
        const dataToStore = {
          ...payload.data,
          timestamp: new Date().toISOString(),
          messageId: payload.messageId || payload.fcmMessageId,
          messageCode: messageCode, // ✅ إضافة messageCode للبيانات
        };
        
        console.log('📤 [FCM-SW] Preparing to send data to Flutter:', {
          messageCode: messageCode,
          actionType: dataToStore.actionType,
          dataKeys: Object.keys(dataToStore),
        });
        
        // استخدام BroadcastChannel لإرسال البيانات (أفضل من postMessage)
        try {
          const channel = new BroadcastChannel('fcm_notifications');
          channel.postMessage({
            type: 'NOTIFICATION_RECEIVED',
            data: dataToStore,
          });
          console.log('✅ [FCM-SW] Sent notification data via BroadcastChannel for message:', messageCode);
          channel.close();
        } catch (e) {
          console.warn('⚠️ [FCM-SW] BroadcastChannel not supported, using postMessage:', e);
        }
        
        // أيضاً استخدام postMessage كبديل
        self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
          console.log('📤 [FCM-SW] Found', clientList.length, 'client(s) to send message to');
          for (const client of clientList) {
            if (client.url.includes(self.location.origin)) {
              try {
                client.postMessage({
                  type: 'NOTIFICATION_RECEIVED',
                  data: dataToStore,
                });
                console.log('✅ [FCM-SW] Sent notification data to Flutter via postMessage for message:', messageCode);
              } catch (e) {
                console.warn('⚠️ [FCM-SW] Failed to send postMessage to client:', e);
              }
            }
          }
        });
      } catch (e) {
        console.error('❌ [FCM-SW] Error sending notification data to Flutter:', e);
      }
    }
    
    console.log('🔔 [FCM-SW] About to show notification for message:', messageCode);
    return self.registration.showNotification(notificationTitle, notificationOptions).then(() => {
      console.log('✅ [FCM-SW] Notification shown successfully for message:', messageCode);
    }).catch((error) => {
      console.error('❌ [FCM-SW] Failed to show notification for message:', messageCode, error);
    });
  } else {
    // معالجة رسائل data-only (عندما لا يكون هناك notification)
    // ✅ إصلاح: messageCode تم تعريفه بالفعل في بداية الدالة، لا حاجة لإعادة تعريفه
    console.log('📬 [FCM-SW] Data-only message, Message Code:', messageCode);
  
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
  
  console.log('🔔 [FCM-SW] Data-only notification options:', {
    title: notificationTitle,
    body: notificationOptions.body,
    dataKeys: Object.keys(notificationOptions.data),
    messageCode: messageCode,
  });

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

  console.log('🔔 [FCM-SW] Showing data-only notification for message:', messageCode);
  console.log('🔔 [FCM-SW] Notification title:', notificationTitle);
  console.log('🔔 [FCM-SW] Notification body:', notificationOptions.body);
  
  // ✅ إصلاح: إرسال البيانات إلى Flutter حتى لرسائل data-only
  if (payload.data && Object.keys(payload.data).length > 0) {
    try {
      const dataToStore = {
        ...payload.data,
        timestamp: new Date().toISOString(),
        messageId: payload.messageId || payload.fcmMessageId,
        messageCode: messageCode,
      };
      
      console.log('📤 [FCM-SW] Sending data-only notification data to Flutter for message:', messageCode);
      
      // استخدام BroadcastChannel
      try {
        const channel = new BroadcastChannel('fcm_notifications');
        channel.postMessage({
          type: 'NOTIFICATION_RECEIVED',
          data: dataToStore,
        });
        console.log('✅ [FCM-SW] Sent data-only notification data via BroadcastChannel for message:', messageCode);
        channel.close();
      } catch (e) {
        console.warn('⚠️ [FCM-SW] BroadcastChannel not supported:', e);
      }
      
      // أيضاً استخدام postMessage
      self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
        for (const client of clientList) {
          if (client.url.includes(self.location.origin)) {
            try {
              client.postMessage({
                type: 'NOTIFICATION_RECEIVED',
                data: dataToStore,
              });
              console.log('✅ [FCM-SW] Sent data-only notification data to Flutter via postMessage for message:', messageCode);
            } catch (e) {
              console.warn('⚠️ [FCM-SW] Failed to send postMessage:', e);
            }
          }
        }
      });
    } catch (e) {
      console.error('❌ [FCM-SW] Error sending data-only notification data:', e);
    }
    
    return self.registration.showNotification(notificationTitle, notificationOptions).then(() => {
      console.log('✅ [FCM-SW] Data-only notification shown successfully for message:', messageCode);
    }).catch((error) => {
      console.error('❌ [FCM-SW] Failed to show data-only notification for message:', messageCode, error);
    });
  }
  } // ✅ إغلاق else block الذي بدأ في السطر 151
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

  // ✅ إصلاح: تمرير البيانات من Service Worker إلى Flutter عند النقر على الإشعار
  // في web، البيانات لا تصل في message.data عند النقر على الإشعار
  // الحل: استخدام sessionStorage + postMessage لتمرير البيانات إلى Flutter
  const notificationDataToPass = {
    ...notificationData,
    ...actionData,
    // التأكد من تمرير profileStatus و profileId
    profileStatus: notificationData.profileStatus || actionData.profileStatus,
    profileId: notificationData.profileId || actionData.profileId,
    registrationStatus: notificationData.registrationStatus || actionData.registrationStatus,
    paymentStatus: notificationData.paymentStatus || actionData.paymentStatus,
    actionType: actionType || notificationData.actionType,
    timestamp: new Date().toISOString(),
  };
  
  console.log('📤 [FCM-SW] Sending notification data to Flutter:', notificationDataToPass);
  
  // ✅ إصلاح: حفظ البيانات في sessionStorage أولاً (لضمان الوصول إليها)
  try {
    // محاولة الوصول إلى sessionStorage من Service Worker
    // في Service Worker، لا يمكن الوصول إلى sessionStorage مباشرة
    // لذا سنستخدم postMessage + localStorage كبديل
    const dataString = JSON.stringify(notificationDataToPass);
    console.log('💾 [FCM-SW] Attempting to save notification data to storage');
  } catch (e) {
    console.warn('⚠️ [FCM-SW] Cannot access storage from Service Worker:', e);
  }
  
  // فتح أو التركيز على النافذة وتمرير البيانات
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // البحث عن نافذة مفتوحة بالفعل
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          // ✅ تمرير البيانات إلى Flutter عبر postMessage
          try {
            client.postMessage({
              type: 'NOTIFICATION_CLICKED',
              data: notificationDataToPass,
              url: targetUrl,
            });
            console.log('✅ [FCM-SW] Data sent to existing window via postMessage');
          } catch (e) {
            console.warn('⚠️ [FCM-SW] Failed to send postMessage:', e);
          }
          client.focus();
          client.navigate(targetUrl);
          
          // ✅ إصلاح: أيضاً إرسال رسالة إلى جميع النوافذ المفتوحة
          // لأن postMessage قد لا يعمل مع النافذة المحددة
          clientList.forEach((c) => {
            if (c.url.includes(self.location.origin)) {
              try {
                c.postMessage({
                  type: 'NOTIFICATION_CLICKED',
                  data: notificationDataToPass,
                  url: targetUrl,
                });
              } catch (e) {
                // ignore
              }
            }
          });
          
          return;
        }
      }
      
      // فتح نافذة جديدة إذا لم توجد نافذة مفتوحة
      if (clients.openWindow) {
        const newWindow = clients.openWindow(targetUrl);
        // ✅ تمرير البيانات عبر localStorage كبديل (لأن postMessage قد لا يعمل مع نافذة جديدة)
        if (newWindow) {
          newWindow.then((window) => {
            if (window) {
              // استخدام localStorage لتمرير البيانات (متاح من النافذة الجديدة)
              try {
                window.localStorage.setItem('notificationData', JSON.stringify(notificationDataToPass));
                console.log('✅ [FCM-SW] Data saved to localStorage for new window');
              } catch (e) {
                console.warn('⚠️ [FCM-SW] Failed to save data to localStorage:', e);
              }
            }
          });
        }
        return newWindow;
      }
    })
  );
});

// معالجة إغلاق الإشعار
self.addEventListener('notificationclose', (event) => {
  console.log('❌ [FCM-SW] Notification closed:', event.notification.tag);
});

console.log('🚀 [FCM-SW] Firebase Messaging Service Worker loaded successfully');


