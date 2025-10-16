// Flutter Web Configuration - System fonts only, no Google Fonts
// Configuration for modern Flutter Web (3.x+)
window.flutterWebConfig = {
  renderer: 'html', // Use HTML renderer for better compatibility
  canvasKitBaseUrl: './canvaskit/', // Local CanvasKit path - MUST be local
  canvasKitVariant: 'auto',
  canvasKitMaximumSurfaces: 8,
  canvasKitForceCpuOnly: false,
  // Force local CanvasKit loading
  canvasKitForceLocal: true,
  // Fallback to HTML renderer if CanvasKit fails
  rendererFallback: 'html',
  fontFallbacks: [
    'Cairo',
    'NotoSansArabic',
    'Roboto',
    'system-ui',
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Arial',
    'Helvetica',
    'Tahoma',
    'sans-serif',
  ],
  // Disable Google Fonts loading completely
  useGoogleFonts: false,
  fontDownloadTimeout: 0,
  disableGoogleFonts: true,
  fontLoadingStrategy: 'system-only',
};

// Prevent Google Fonts and CanvasKit CDN loading completely
(function () {
  // Block Google Fonts and CanvasKit CDN requests
  const originalFetch = window.fetch;
  window.fetch = function (...args) {
    const url = args[0];
    if (typeof url === 'string') {
      if (url.includes('fonts.googleapis.com') || url.includes('fonts.gstatic.com')) {
        console.log('🚫 Blocked Google Fonts request:', url);
        return Promise.reject(new Error('Google Fonts blocked'));
      }
      if (
        url.includes('www.gstatic.com/flutter-canvaskit') ||
        url.includes('gstatic.com/flutter-canvaskit')
      ) {
        console.log('🚫 Blocked CanvasKit CDN request, using local version:', url);
        return Promise.reject(new Error('CanvasKit CDN blocked - use local version'));
      }
    }
    return originalFetch.apply(this, args);
  };

  // Block CSS @import for Google Fonts and script loading from Google CDN
  const originalCreateElement = document.createElement;
  document.createElement = function (tagName) {
    const element = originalCreateElement.call(this, tagName);
    if (tagName.toLowerCase() === 'link') {
      const originalSetAttribute = element.setAttribute;
      element.setAttribute = function (name, value) {
        if (
          name === 'href' &&
          typeof value === 'string' &&
          (value.includes('fonts.googleapis.com') || value.includes('fonts.gstatic.com'))
        ) {
          console.log('🚫 Blocked Google Fonts link:', value);
          return;
        }
        return originalSetAttribute.call(this, name, value);
      };
    }
    if (tagName.toLowerCase() === 'script') {
      const originalSetAttribute = element.setAttribute;
      element.setAttribute = function (name, value) {
        if (
          name === 'src' &&
          typeof value === 'string' &&
          (value.includes('www.gstatic.com/flutter-canvaskit') ||
            value.includes('gstatic.com/flutter-canvaskit'))
        ) {
          console.log('🚫 Blocked CanvasKit CDN script:', value);
          return;
        }
        return originalSetAttribute.call(this, name, value);
      };
    }
    return element;
  };
})();
// Force system font loading before Flutter starts
document.addEventListener('DOMContentLoaded', function () {
  // Force system font loading
  const testElement = document.createElement('div');
  testElement.style.fontFamily =
    'system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Arial, sans-serif';
  testElement.style.position = 'absolute';
  testElement.style.visibility = 'hidden';
  testElement.textContent = 'Test';
  document.body.appendChild(testElement);

  // Remove test element after a short delay
  setTimeout(() => {
    document.body.removeChild(testElement);
  }, 100);
});
