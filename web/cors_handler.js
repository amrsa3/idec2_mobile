// Fast CORS Handler for Flutter Web - SILENT MODE
// تم إيقاف رسائل السجلات لتحسين تجربة المطور
(function () {
  'use strict';

  // Minimal CORS configuration for performance - SILENT MODE
  // console.log('🌐 [CORS] Fast CORS handler initialized'); // تم إيقاف هذه الرسالة

  // Add event listener for network errors (silent mode - no logging)
  window.addEventListener('error', function (e) {
    if (e.message && e.message.includes('CORS')) {
      // console.error('🌐 [CORS] CORS error:', e.message); // تم إيقاف هذه الرسالة
      // Handle CORS error silently without logging
    }
  });

  // Minimal fetch monitoring (silent mode - no error logging)
  const originalFetch = window.fetch;
  window.fetch = function (...args) {
    return originalFetch.apply(this, args).catch(error => {
      // console.error('🌐 [CORS] Fetch error:', error); // تم إيقاف هذه الرسالة
      // Handle fetch errors silently without logging
      throw error;
    });
  };
})();
