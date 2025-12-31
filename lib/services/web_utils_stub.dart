/// Stub implementation for web utilities
/// Used for non-web platforms (Android, iOS)

/// Clear browser storage (no-op on mobile)
void clearBrowserStorage() {
  // No-op on mobile platforms
}

/// Reload browser page (no-op on mobile)
void reloadBrowserPage() {
  // No-op on mobile platforms
}

/// Check if running on web platform
bool get isWebPlatform => false;

/// Get browser user agent (empty on mobile)
String getBrowserUserAgent() => '';

/// Clear specific storage key
void clearStorageKey(String key) {
  // No-op on mobile platforms
}

/// Get storage value from localStorage
String? getLocalStorageValue(String key) => null;

/// Set storage value to localStorage
void setLocalStorageValue(String key, String value) {
  // No-op on mobile platforms
}

/// Remove storage value from localStorage
void removeLocalStorageValue(String key) {
  // No-op on mobile platforms
}

/// Get storage value from sessionStorage
String? getSessionStorageValue(String key) => null;

/// Set storage value to sessionStorage
void setSessionStorageValue(String key, String value) {
  // No-op on mobile platforms
}

/// Remove storage value from sessionStorage
void removeSessionStorageValue(String key) {
  // No-op on mobile platforms
}

/// Clear all localStorage
void clearLocalStorage() {
  // No-op on mobile platforms
}

/// Clear all sessionStorage
void clearSessionStorage() {
  // No-op on mobile platforms
}

/// Get all localStorage keys
List<String> getLocalStorageKeys() => [];

/// Iterate over localStorage entries
void forEachLocalStorage(void Function(String key, String value) callback) {
  // No-op on mobile platforms
}

/// Iterate over sessionStorage entries
void forEachSessionStorage(void Function(String key, String value) callback) {
  // No-op on mobile platforms
}
