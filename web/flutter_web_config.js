// Fast Flutter Web Configuration
// Detect mobile device
const isMobile =
  /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
  (window.innerWidth <= 768 && window.innerHeight <= 1024);

window.flutterWebConfig = {
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
    serviceWorkerVersion: '2.0.9-20251113020723', // سيتم استبداله بقيمة فريدة أثناء البناء
    updateStrategy: 'on-download', // Immediate update when new version is downloaded
  },
};

console.log('✅ Flutter Web configured - Mobile:', isMobile, 'Service Worker:', !isMobile);
