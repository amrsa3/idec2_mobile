// Flutter Web Configuration for better text rendering
window.flutterConfiguration = {
  renderer: "html", // Force HTML renderer for better text support
  fontFallbacks: [
    'Arial', 
    'Helvetica',
    'Tahoma',
    'sans-serif',
    'Segoe UI',
    'system-ui',
    '-apple-system',
    'BlinkMacSystemFont'
  ]
};

// Ensure fonts are loaded before Flutter starts
document.addEventListener('DOMContentLoaded', function() {
  // Force font loading
  const testElement = document.createElement('div');
  testElement.style.fontFamily = 'Cairo, Arial, Helvetica, sans-serif';
  testElement.style.position = 'absolute';
  testElement.style.left = '-9999px';
  testElement.innerHTML = 'Test text نص تجريبي';
  document.body.appendChild(testElement);
  
  // Remove test element after a short delay
  setTimeout(() => {
    document.body.removeChild(testElement);
  }, 100);
});