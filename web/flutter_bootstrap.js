// Flutter Bootstrap Script for IDEC Mobile App
// This file initializes Flutter Web application

(function () {
  'use strict';

  // Flutter Web Configuration with enhanced error handling
  window.flutterWebConfig = {
    // Use HTML renderer for better compatibility
    renderer: 'html',
    canvasKitBaseUrl: './canvaskit/', // Local CanvasKit only

    // Font fallbacks for Arabic and English text
    fontFallbacks: [
      'Cairo',
      'NotoSansArabic',
      'Roboto',
      'Tahoma',
      'Arial',
      'Helvetica',
      'sans-serif',
      'system-ui',
      '-apple-system',
      'BlinkMacSystemFont',
      'Segoe UI',
    ],

    // Enable debugging in development
    debugShowCheckedModeBanner: false,

    // Performance optimizations
    useColorEmoji: true,

    // Service Worker configuration
    serviceWorkerSettings: {
      serviceWorkerVersion: '1201463201',
      serviceWorkerUrl: '/flutter_service_worker.js',
    },

    // CanvasKit specific settings - force local loading
    canvasKitVariant: 'auto',
    canvasKitMaximumSurfaces: 8,
    canvasKitForceCpuOnly: false,
    canvasKitForceLocal: true,

    // Enhanced error handling
    rendererFallback: 'html',
    enableErrorRecovery: true,
  };

  // Create Flutter loader object if it doesn't exist
  if (!window._flutter) {
    window._flutter = {};
  }

  // Initialize Flutter loader
  window._flutter.loader = {
    load: function (config) {
      return new Promise(function (resolve, reject) {
        try {
          // Merge configurations
          var finalConfig = Object.assign({}, window.flutterWebConfig, config || {});

          console.log('🚀 [Flutter Bootstrap] Initializing Flutter Web...');
          console.log('🔧 [Flutter Bootstrap] Config:', finalConfig);

          // Create app runner object
          var appRunner = {
            runApp: function () {
              console.log('▶️ [Flutter Bootstrap] Running Flutter app...');

              // Hide loading indicator
              var loading = document.getElementById('loading');
              if (loading) {
                loading.style.display = 'none';
              }

              // Initialize Flutter app
              if (window.flutter && window.flutter.loader) {
                // Use official Flutter loader if available
                window.flutter.loader
                  .loadEntrypoint({
                    serviceWorker: finalConfig.serviceWorkerSettings,
                  })
                  .then(function (engineInitializer) {
                    return engineInitializer.initializeEngine();
                  })
                  .then(function (appRunner) {
                    return appRunner.runApp();
                  });
              } else {
                // Fallback initialization with enhanced error handling
                console.log('⚠️ [Flutter Bootstrap] Using fallback initialization');

                // Try CanvasKit first, then fallback to HTML renderer
                var tryCanvasKit = function () {
                  return new Promise(function (resolve, reject) {
                    // Check if CanvasKit is available locally
                    fetch('./canvaskit/canvaskit.js')
                      .then(function () {
                        console.log('✅ [Flutter Bootstrap] Local CanvasKit available');
                        resolve('canvaskit');
                      })
                      .catch(function () {
                        console.log(
                          '⚠️ [Flutter Bootstrap] Local CanvasKit not available, using HTML renderer',
                        );
                        resolve('html');
                      });
                  });
                };

                tryCanvasKit().then(function (renderer) {
                  // Update config with determined renderer
                  finalConfig.renderer = renderer;

                  // Try to load main.dart.js
                  var script = document.createElement('script');
                  script.src = 'main.dart.js';
                  script.onload = function () {
                    console.log('✅ [Flutter Bootstrap] main.dart.js loaded successfully');
                  };
                  script.onerror = function () {
                    console.error('❌ [Flutter Bootstrap] Failed to load main.dart.js');
                    // Show error message
                    var loading = document.getElementById('loading');
                    if (loading) {
                      loading.innerHTML =
                        '<p style="color: red; text-align: center; padding: 20px;">خطأ في تحميل التطبيق<br/>Error loading application<br/>Please refresh the page</p>';
                      loading.style.display = 'block';
                    }
                  };
                  document.head.appendChild(script);
                });
              }
            },
          };

          // Resolve with app runner
          resolve(appRunner);
        } catch (error) {
          console.error('❌ [Flutter Bootstrap] Error:', error);
          reject(error);
        }
      });
    },
  };

  // Auto-initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeFlutter);
  } else {
    initializeFlutter();
  }

  function initializeFlutter() {
    console.log('🎯 [Flutter Bootstrap] DOM ready, initializing...');

    // Set up error handling
    window.addEventListener('error', function (event) {
      console.error('🚨 [Flutter Bootstrap] Global error:', event.error);
    });

    // Set up unhandled promise rejection handling
    window.addEventListener('unhandledrejection', function (event) {
      console.error('🚨 [Flutter Bootstrap] Unhandled promise rejection:', event.reason);
    });

    console.log('✅ [Flutter Bootstrap] Ready for Flutter initialization');
  }

  console.log('📦 [Flutter Bootstrap] Bootstrap script loaded');
})();
