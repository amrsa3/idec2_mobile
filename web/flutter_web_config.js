// Flutter Web Configuration - System fonts only, no Google Fonts
// Configuration for modern Flutter Web (3.x+)
window.flutterWebConfig = {
  renderer: "html", // Force HTML renderer for better text support
  fontFallbacks: [
    'system-ui',
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Arial', 
    'Helvetica',
    'Tahoma',
    'sans-serif'
  ],
  // Disable Google Fonts loading
  useGoogleFonts: false,
  fontDownloadTimeout: 0,
  disableGoogleFonts: true,
  fontLoadingStrategy: 'system-only'
};

// Prevent Google Fonts loading completely
(function() {
  // Block Google Fonts requests
  const originalFetch = window.fetch;
  window.fetch = function(...args) {
    const url = args[0];
    if (typeof url === 'string' && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
      console.log('🚫 Blocked Google Fonts request:', url);
      return Promise.reject(new Error('Google Fonts blocked'));
    }
    return originalFetch.apply(this, args);
  };
  
  // Block CSS @import for Google Fonts
  const originalCreateElement = document.createElement;
  document.createElement = function(tagName) {
    const element = originalCreateElement.call(this, tagName);
    if (tagName.toLowerCase() === 'link') {
      const originalSetAttribute = element.setAttribute;
      element.setAttribute = function(name, value) {
        if (name === 'href' && typeof value === 'string' && 
            (value.includes('fonts.googleapis.com') || value.includes('fonts.gstatic.com'))) {
          console.log('🚫 Blocked Google Fonts link:', value);
          return;
        }
        return originalSetAttribute.call(this, name, value);
      };
    }
    return element;
  };
})();

// Force system font loading before Flutter starts
document.addEventListener('DOMContentLoaded', function() {
  // Force system font loading
  const testElement = document.createElement('div');
  testElement.style.fontFamily = 'system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Arial, sans-serif';
  testElement.style.position = 'absolute';
  testElement.style.visibility = 'hidden';
  testElement.textContent = 'Test';
  document.body.appendChild(testElement);
  
  // Remove test element after a short delay
  setTimeout(() => {
    document.body.removeChild(testElement);
  }, 100);
});