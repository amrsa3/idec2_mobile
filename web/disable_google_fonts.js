// Disable Google Fonts completely for Flutter Web
(function() {
  'use strict';
  
  // Override Flutter's font loading
  if (typeof window !== 'undefined') {
    // Block all requests to Google Fonts
    const originalFetch = window.fetch;
    window.fetch = function(input, init) {
      const url = typeof input === 'string' ? input : input.url;
      if (url && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
        console.log('🚫 Blocked Google Fonts request:', url);
        return Promise.reject(new Error('Google Fonts blocked by disable_google_fonts.js'));
      }
      return originalFetch.apply(this, arguments);
    };
    
    // Override XMLHttpRequest for older browsers
    const originalXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url) {
      if (url && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
        console.log('🚫 Blocked Google Fonts XHR request:', url);
        throw new Error('Google Fonts blocked by disable_google_fonts.js');
      }
      return originalXHROpen.apply(this, arguments);
    };
    
    // Force system fonts
    const style = document.createElement('style');
    style.textContent = `
      * {
        font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif !important;
      }
      
      /* Prevent any Google Fonts from loading */
      @font-face {
        font-family: 'Noto Sans Arabic';
        src: local('Arial'), local('Helvetica'), local('sans-serif');
      }
      
      @font-face {
        font-family: 'Noto Color Emoji';
        src: local('Arial'), local('Helvetica'), local('sans-serif');
      }
      
      @font-face {
        font-family: 'Roboto';
        src: local('Arial'), local('Helvetica'), local('sans-serif');
      }
    `;
    document.head.appendChild(style);
    
    console.log('✅ Google Fonts disabled successfully');
  }
})();