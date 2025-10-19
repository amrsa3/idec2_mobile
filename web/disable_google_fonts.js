// Disable Google Fonts completely for Flutter Web - Silent Mode
(function() {
  'use strict';
  
  // Silent blocking - no console logs to reduce noise
  let blockedCount = 0;
  
  // Override Flutter's font loading
  if (typeof window !== 'undefined') {
    // Block all requests to Google Fonts - SILENT MODE
    const originalFetch = window.fetch;
    window.fetch = function(input, init) {
      const url = typeof input === 'string' ? input : input.url;
      if (url && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
        blockedCount++;
        // Silent rejection - no console logs
        return Promise.reject(new Error('Google Fonts blocked'));
      }
      return originalFetch.apply(this, arguments);
    };
    
    // Override XMLHttpRequest for older browsers - SILENT MODE
    const originalXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url) {
      if (url && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
        blockedCount++;
        // Silent blocking - no console logs
        throw new Error('Google Fonts blocked');
      }
      return originalXHROpen.apply(this, arguments);
    };
    
    // Block CSS imports for Google Fonts - SILENT MODE
    const originalCreateElement = document.createElement;
    document.createElement = function(tagName) {
      const element = originalCreateElement.call(this, tagName);
      if (tagName.toLowerCase() === 'link') {
        const originalSetAttribute = element.setAttribute;
        element.setAttribute = function(name, value) {
          if (name === 'href' && typeof value === 'string' && 
              (value.includes('fonts.googleapis.com') || value.includes('fonts.gstatic.com'))) {
            blockedCount++;
            // Silent blocking - no console logs
            return;
          }
          return originalSetAttribute.call(this, name, value);
        };
      }
      return element;
    };
    
    // Force system fonts with better Arabic support
    const style = document.createElement('style');
    style.textContent = `
      /* Force system fonts for all elements */
      *, *::before, *::after {
        font-family: 'Segoe UI', 'Tahoma', 'Arial', 'Helvetica', system-ui, -apple-system, BlinkMacSystemFont, sans-serif !important;
        font-display: swap !important;
      }
      
      /* Arabic text support */
      [dir="rtl"], [lang="ar"], .arabic-text {
        font-family: 'Segoe UI', 'Tahoma', 'Arial', 'Helvetica', sans-serif !important;
        direction: rtl;
        text-align: right;
      }
      
      /* English text support */
      [dir="ltr"], [lang="en"], .english-text {
        font-family: 'Segoe UI', 'Arial', 'Helvetica', sans-serif !important;
        direction: ltr;
        text-align: left;
      }
      
      /* Prevent any Google Fonts from loading - redirect to system fonts */
      @font-face {
        font-family: 'Noto Sans Arabic';
        src: local('Segoe UI'), local('Tahoma'), local('Arial'), local('Helvetica');
        font-display: swap;
      }
      
      @font-face {
        font-family: 'Noto Color Emoji';
        src: local('Segoe UI Emoji'), local('Segoe UI'), local('Arial');
        font-display: swap;
      }
      
      @font-face {
        font-family: 'Roboto';
        src: local('Segoe UI'), local('Arial'), local('Helvetica');
        font-display: swap;
      }
      
      /* Flutter Web specific overrides */
      flt-glass-pane, flt-glass-pane *, 
      flutter-view, flutter-view *,
      flt-scene-host, flt-scene-host * {
        font-family: 'Segoe UI', 'Tahoma', 'Arial', 'Helvetica', sans-serif !important;
        font-display: swap !important;
      }
      
      /* Ensure text is always visible */
      body, html {
        font-family: 'Segoe UI', 'Tahoma', 'Arial', 'Helvetica', sans-serif !important;
        color: #000 !important;
        opacity: 1 !important;
        visibility: visible !important;
      }
    `;
    document.head.appendChild(style);
    
    // Single success message only
    console.log('✅ Google Fonts disabled - using system fonts only');
    
    // Report blocked count after 5 seconds (one time only)
    setTimeout(() => {
      if (blockedCount > 0) {
        console.log(`🚫 Blocked ${blockedCount} Google Fonts requests - using system fonts instead`);
      }
    }, 5000);
  }
})();