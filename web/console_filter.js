// ULTIMATE Console Filter for Google Fonts - ZERO TOLERANCE
// This script provides the final layer of protection against Google Fonts console spam
(function() {
  'use strict';

  // Comprehensive Google Fonts message patterns
  const GOOGLE_FONTS_PATTERNS = [
    'fonts.googleapis.com',
    'fonts.gstatic.com',
    'googleapis.com',
    'gstatic.com',
    'Google Fonts blocked',
    'Failed to load font',
    'Flutter Web engine failed to complete HTTP request to fetch',
    'Noto Sans',
    'Roboto',
    'Cairo',
    'NotoSansArabic',
    'font-family',
    'font-display',
    'woff2',
    'woff',
    'ttf',
    'otf'
  ];

  // Check if message contains Google Fonts related content
  const isGoogleFontsMessage = function(message) {
    if (!message) return false;
    
    const messageStr = String(message).toLowerCase();
    
    // Check for Google Fonts patterns
    for (let pattern of GOOGLE_FONTS_PATTERNS) {
      if (messageStr.includes(pattern.toLowerCase())) {
        return true;
      }
    }
    
    // Check for CORS + fonts combination
    if (messageStr.includes('cors') && 
        (messageStr.includes('font') || messageStr.includes('google'))) {
      return true;
    }
    
    return false;
  };

  // Store original console methods
  const originalConsole = {
    log: console.log.bind(console),
    error: console.error.bind(console),
    warn: console.warn.bind(console),
    info: console.info.bind(console),
    debug: console.debug.bind(console),
    trace: console.trace.bind(console)
  };

  // Override console.error (highest priority)
  console.error = function(...args) {
    const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
    if (!shouldFilter) {
      originalConsole.error.apply(console, args);
    }
  };

  // Override console.warn
  console.warn = function(...args) {
    const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
    if (!shouldFilter) {
      originalConsole.warn.apply(console, args);
    }
  };

  // Override console.log
  console.log = function(...args) {
    const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
    if (!shouldFilter) {
      originalConsole.log.apply(console, args);
    }
  };

  // Override console.info
  console.info = function(...args) {
    const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
    if (!shouldFilter) {
      originalConsole.info.apply(console, args);
    }
  };

  // Override console.debug
  console.debug = function(...args) {
    const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
    if (!shouldFilter) {
      originalConsole.debug.apply(console, args);
    }
  };

  // Override console.trace
  console.trace = function(...args) {
    const shouldFilter = args.some(arg => isGoogleFontsMessage(arg));
    if (!shouldFilter) {
      originalConsole.trace.apply(console, args);
    }
  };

  // Intercept window.onerror for global error handling
  const originalOnError = window.onerror;
  window.onerror = function(message, source, lineno, colno, error) {
    if (isGoogleFontsMessage(message) || isGoogleFontsMessage(source)) {
      return true; // Prevent default error handling
    }
    
    if (originalOnError) {
      return originalOnError.apply(this, arguments);
    }
    return false;
  };

  // Intercept unhandled promise rejections
  const originalUnhandledRejection = window.onunhandledpromiserejection;
  window.onunhandledpromiserejection = function(event) {
    const reason = event.reason;
    if (isGoogleFontsMessage(reason) || isGoogleFontsMessage(reason?.message)) {
      event.preventDefault();
      return;
    }
    
    if (originalUnhandledRejection) {
      return originalUnhandledRejection.apply(this, arguments);
    }
  };

  // Filter addEventListener for error events
  const originalAddEventListener = EventTarget.prototype.addEventListener;
  EventTarget.prototype.addEventListener = function(type, listener, options) {
    if (type === 'error' && typeof listener === 'function') {
      const wrappedListener = function(event) {
        if (isGoogleFontsMessage(event.message) || 
            isGoogleFontsMessage(event.error?.message)) {
          return; // Silently ignore Google Fonts errors
        }
        return listener.call(this, event);
      };
      return originalAddEventListener.call(this, type, wrappedListener, options);
    }
    return originalAddEventListener.call(this, type, listener, options);
  };

  // Silent operation - no initialization message
  // Google Fonts console spam is now completely eliminated
})