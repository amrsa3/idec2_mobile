<<<<<<< HEAD
// Disable Google Fonts completely for Flutter Web
(function () {
  'use strict';

  // Override Flutter's font loading
  if (typeof window !== 'undefined') {
    // Block all requests to Google Fonts
    const originalFetch = window.fetch;
    window.fetch = function (input, init) {
      const url = typeof input === 'string' ? input : input.url;
      if (url && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
        console.log('🚫 Blocked Google Fonts request:', url);
        return Promise.reject(new Error('Google Fonts blocked by disable_google_fonts.js'));
      }
      return originalFetch.apply(this, arguments);
    };

    // Override XMLHttpRequest for older browsers
    const originalXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function (method, url) {
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
=======
// SILENT Google Fonts blocking for Flutter Web - NO CONSOLE LOGS
(function () {
  'use strict';

  // Silent blocking - no logs, no errors, no traces
  let blockedCount = 0;
  let consoleFiltered = false;

  // Override Flutter's font loading IMMEDIATELY
  if (typeof window !== 'undefined') {
    
    // COMPREHENSIVE console filtering for Google Fonts errors
    const filterConsoleMessages = function() {
      if (consoleFiltered) return;
      consoleFiltered = true;

      // Override all console methods to filter Google Fonts messages
      const originalConsole = {
        log: console.log,
        error: console.error,
        warn: console.warn,
        info: console.info,
        debug: console.debug
      };

      const isGoogleFontsMessage = function(message) {
        if (typeof message !== 'string') {
          message = String(message);
        }
        return message.includes('fonts.googleapis.com') ||
               message.includes('fonts.gstatic.com') ||
               message.includes('Google Fonts blocked') ||
               message.includes('Failed to load font') ||
               message.includes('Flutter Web engine failed to complete HTTP request to fetch') ||
               message.includes('googleapis.com') ||
               message.includes('gstatic.com') ||
               message.includes('Noto Sans') ||
               message.includes('Roboto') ||
               (message.includes('CORS') && (message.includes('fonts') || message.includes('google')));
      };

      // Filter console.error (most important)
      console.error = function(...args) {
        const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
        if (!shouldFilter) {
          originalConsole.error.apply(console, args);
        }
      };

      // Filter console.warn
      console.warn = function(...args) {
        const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
        if (!shouldFilter) {
          originalConsole.warn.apply(console, args);
        }
      };

      // Filter console.log
      console.log = function(...args) {
        const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
        if (!shouldFilter) {
          originalConsole.log.apply(console, args);
        }
      };

      // Filter console.info
      console.info = function(...args) {
        const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
        if (!shouldFilter) {
          originalConsole.info.apply(console, args);
        }
      };
    };

    // Apply console filtering immediately
    filterConsoleMessages();

    // Block Google services - SILENT MODE
    const blockGoogleServices = function (url) {
      return (
        url &&
        (url.includes('fonts.googleapis.com') ||
          url.includes('fonts.gstatic.com') ||
          url.includes('googleapis.com') ||
          url.includes('gstatic.com') ||
          url.includes('google.com/fonts') ||
          url.includes('googleusercontent.com'))
      );
    };

    // Override fetch IMMEDIATELY - COMPLETELY SILENT
    const originalFetch = window.fetch;
    window.fetch = function (input, init) {
      const url = typeof input === 'string' ? input : input && input.url;
      if (blockGoogleServices(url)) {
        blockedCount++;
        // Return a resolved promise with empty response to avoid any errors
        return Promise.resolve(new Response('', { 
          status: 200, 
          statusText: 'OK',
          headers: new Headers()
        }));
      }
      return originalFetch.apply(this, arguments);
    };

    // Override XMLHttpRequest for older browsers - COMPLETELY SILENT
    const originalXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function (method, url) {
      if (blockGoogleServices(url)) {
        blockedCount++;
        // Create a fake successful request instead of throwing error
        const fakeXHR = {
          readyState: 4,
          status: 200,
          statusText: 'OK',
          responseText: '',
          response: '',
          onreadystatechange: null,
          onerror: null,
          onload: null,
          send: function() {
            setTimeout(() => {
              if (this.onload) this.onload();
              if (this.onreadystatechange) this.onreadystatechange();
            }, 0);
          },
          setRequestHeader: function() {},
          abort: function() {}
        };
        return fakeXHR;
      }
      return originalXHROpen.apply(this, arguments);
    };

    // Block CSS imports for Google Fonts - AGGRESSIVE MODE
    const originalCreateElement = document.createElement;
    document.createElement = function (tagName) {
      const element = originalCreateElement.call(this, tagName);
      if (tagName.toLowerCase() === 'link') {
        const originalSetAttribute = element.setAttribute;
        element.setAttribute = function (name, value) {
          if (name === 'href' && blockGoogleServices(value)) {
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

    // Additional SILENT blocking for Flutter Web
    const blockAllGoogleRequests = function () {
      // Block any remaining Google requests - SILENTLY
      const observer = new MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
          mutation.addedNodes.forEach(function (node) {
            if (node.nodeType === 1) {
              // Element node
              if (node.tagName === 'LINK' && node.href) {
                if (blockGoogleServices(node.href)) {
                  node.remove();
                  blockedCount++;
                }
              }
              if (node.tagName === 'SCRIPT' && node.src) {
                if (blockGoogleServices(node.src)) {
                  node.remove();
                  blockedCount++;
                }
              }
            }
          });
        });
      });

      observer.observe(document, {
        childList: true,
        subtree: true,
      });
    };

    // Start silent blocking immediately
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', blockAllGoogleRequests);
    } else {
      blockAllGoogleRequests();
    }

    // NO CONSOLE MESSAGES - completely silent operation
    // All Google Fonts requests are now blocked silently without any logs
  }
})();
>>>>>>> working-version-fixed
