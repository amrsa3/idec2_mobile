// Fast CORS Handler for Flutter Web
(function () {
  'use strict';

  // Minimal CORS configuration for performance
  console.log('🌐 [CORS] Fast CORS handler initialized');

  // Add event listener for network errors (minimal logging)
  window.addEventListener('error', function (e) {
    if (e.message && e.message.includes('CORS')) {
      console.error('🌐 [CORS] CORS error:', e.message);
    }
  });

  // Minimal fetch monitoring (only log errors)
  const originalFetch = window.fetch;
  window.fetch = function (...args) {
    return originalFetch.apply(this, args).catch(error => {
      console.error('🌐 [CORS] Fetch error:', error);
      throw error;
    });
  };
})();
