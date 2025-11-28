// SILENT CORS Handler for Flutter Web - NO GOOGLE FONTS LOGS
(function () {
  'use strict';

  // Helper function to check if error is related to Google Fonts
  const isGoogleFontsError = function(message) {
    if (typeof message !== 'string') {
      message = String(message);
    }
    return message.includes('fonts.googleapis.com') ||
           message.includes('fonts.gstatic.com') ||
           message.includes('Google Fonts blocked') ||
           message.includes('Failed to load font') ||
           message.includes('googleapis.com') ||
           message.includes('gstatic.com') ||
           message.includes('Noto Sans') ||
           message.includes('Roboto') ||
           message.includes('Flutter Web engine failed to complete HTTP request to fetch');
  };

  // SILENT CORS configuration - no Google Fonts logs
  // Only log non-Google Fonts CORS errors

  // Add event listener for network errors (filter Google Fonts)
  window.addEventListener('error', function (e) {
    if (e.message && e.message.includes('CORS') && !isGoogleFontsError(e.message)) {
      console.error('🌐 [CORS] CORS error:', e.message);
    }
  });

  // SILENT fetch monitoring - filter Google Fonts errors
  const originalFetch = window.fetch;
  window.fetch = function (...args) {
    return originalFetch.apply(this, args).catch(error => {
      // Only log non-Google Fonts errors
      if (!isGoogleFontsError(String(error))) {
        console.error('🌐 [CORS] Fetch error:', error);
      }
      throw error;
    });
  };

  // Silent initialization - no startup message
})();
