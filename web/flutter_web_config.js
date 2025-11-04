// Fast Flutter Web Configuration
window.flutterWebConfig = {
  renderer: 'html',
  fontFallbacks: ['Segoe UI', 'Tahoma', 'Arial', 'Helvetica', 'system-ui', 'sans-serif'],
  // Performance optimizations
  canvasKitBaseUrl: null, // Disable CanvasKit for faster loading
  useColorEmoji: false, // Disable emoji rendering for speed
  debugShowCheckedModeBanner: false, // Disable debug banner
  // Fast initialization
  autoStart: true,
  enableServiceWorker: true, // Enable service worker with update strategy
  serviceWorkerSettings: {
    serviceWorkerVersion: null, // Will be set automatically by Flutter
    updateStrategy: 'on-download', // Immediate update when new version is downloaded
  },
};

console.log('✅ Flutter Web configured with cache busting enabled');
