// CORS Handler for Flutter Web
(function() {
    'use strict';
    
    // Log CORS configuration
    console.log('🌐 [CORS] Initializing CORS handler for Flutter Web');
    
    // Add event listener for network errors
    window.addEventListener('error', function(e) {
        if (e.message && e.message.includes('CORS')) {
            console.error('🌐 [CORS] CORS error detected:', e);
        }
    });
    
    // Monitor fetch requests
    const originalFetch = window.fetch;
    window.fetch = function(...args) {
        console.log('🌐 [CORS] Fetch request:', args[0]);
        return originalFetch.apply(this, args)
            .then(response => {
                console.log('🌐 [CORS] Fetch response:', response.status, response.url);
                return response;
            })
            .catch(error => {
                console.error('🌐 [CORS] Fetch error:', error);
                throw error;
            });
    };
    
    console.log('🌐 [CORS] CORS handler initialized');
})();