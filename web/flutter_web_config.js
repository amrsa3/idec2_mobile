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
  enableServiceWorker: false, // Disable service worker for faster loading
};

console.log('✅ Flutter Web configured for fast loading');
