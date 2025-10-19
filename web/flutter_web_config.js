// Flutter Web Configuration - System fonts only, no Google Fonts - Silent Mode
// Configuration for modern Flutter Web (3.x+)
window.flutterWebConfig = {
  renderer: "html", // Force HTML renderer for better text support
  fontFallbacks: [
    'Segoe UI',
    'Tahoma',
    'Arial', 
    'Helvetica',
    'system-ui',
    '-apple-system',
    'BlinkMacSystemFont',
    'sans-serif'
  ],
  // Disable Google Fonts loading completely
  useGoogleFonts: false,
  fontDownloadTimeout: 0,
  disableGoogleFonts: true,
  fontLoadingStrategy: 'system-only'
};

// Prevent Google Fonts loading completely - SILENT MODE
(function() {
  let blockedCount = 0;
  
  // Block Google Fonts requests - SILENT
  const originalFetch = window.fetch;
  window.fetch = function(...args) {
    const url = args[0];
    if (typeof url === 'string' && (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com'))) {
      blockedCount++;
      // Silent rejection - no console spam
      return Promise.reject(new Error('Google Fonts blocked'));
    }
    return originalFetch.apply(this, args);
  };
  
  // Block CSS @import for Google Fonts - SILENT
  const originalCreateElement = document.createElement;
  document.createElement = function(tagName) {
    const element = originalCreateElement.call(this, tagName);
    if (tagName.toLowerCase() === 'link') {
      const originalSetAttribute = element.setAttribute;
      element.setAttribute = function(name, value) {
        if (name === 'href' && typeof value === 'string' && 
            (value.includes('fonts.googleapis.com') || value.includes('fonts.gstatic.com'))) {
          blockedCount++;
          // Silent blocking - no console spam
          return;
        }
        return originalSetAttribute.call(this, name, value);
      };
    }
    return element;
  };
  
  // Single log message only
  console.log('✅ Flutter Web configured with system fonts only');
})();

// Force system font loading before Flutter starts
document.addEventListener('DOMContentLoaded', function() {
  // Force system font loading with better Arabic support
  const testElement = document.createElement('div');
  testElement.style.fontFamily = 'Segoe UI, Tahoma, Arial, Helvetica, system-ui, -apple-system, BlinkMacSystemFont, sans-serif';
  testElement.style.position = 'absolute';
  testElement.style.visibility = 'hidden';
  testElement.textContent = 'Test نص عربي';
  document.body.appendChild(testElement);
  
  // Remove test element after a short delay
  setTimeout(() => {
    if (document.body.contains(testElement)) {
      document.body.removeChild(testElement);
    }
  }, 100);
});