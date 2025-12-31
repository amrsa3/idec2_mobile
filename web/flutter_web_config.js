// Fast Flutter Web Configuration
// Detect mobile device
const isMobile =
  /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
  (window.innerWidth <= 768 && window.innerHeight <= 1024);

window.flutterWebConfig = {
<<<<<<< HEAD
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
=======
  renderer: 'html',
  fontFallbacks: ['Segoe UI', 'Tahoma', 'Arial', 'Helvetica', 'system-ui', 'sans-serif'],
  // Performance optimizations
  canvasKitBaseUrl: null, // Disable CanvasKit for faster loading
  useColorEmoji: false, // Disable emoji rendering for speed
  debugShowCheckedModeBanner: false, // Disable debug banner
  // Fast initialization
  autoStart: true,
  // Enable service worker on desktop, disable on mobile for better compatibility
  enableServiceWorker: !isMobile,
  serviceWorkerSettings: {
    serviceWorkerVersion: '2.0.11-20251129180234', // سيتم استبداله بقيمة فريدة أثناء البناء
    updateStrategy: 'on-download', // Immediate update when new version is downloaded
  },
};

console.log('✅ Flutter Web configured - Mobile:', isMobile, 'Service Worker:', !isMobile);
>>>>>>> working-version-fixed
