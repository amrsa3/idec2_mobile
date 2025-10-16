// Flutter Web Configuration - Simplified for Production
// Configuration for modern Flutter Web (3.x+)
window.flutterWebConfig = {
  renderer: 'html', // Use HTML renderer for better compatibility
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
  // Performance optimizations
  useColorEmoji: true,
  debugShowCheckedModeBanner: false,
};

// Simplified error handling
window.addEventListener('error', function (event) {
  console.error('Flutter Web Error:', event.error);
});

window.addEventListener('unhandledrejection', function (event) {
  console.error('Flutter Web Promise Rejection:', event.reason);
});

// Force system font loading
document.addEventListener('DOMContentLoaded', function () {
  const style = document.createElement('style');
  style.textContent = `
    * {
      font-family: 'Cairo', 'NotoSansArabic', 'Roboto', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif !important;
    }
  `;
  document.head.appendChild(style);
});


