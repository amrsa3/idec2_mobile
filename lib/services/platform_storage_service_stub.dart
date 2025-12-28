/// Stub file for non-web platforms
/// This file is used when dart:html is not available (mobile, desktop, tests)

class WebStorageStub {
  static final WebStorageStub instance = WebStorageStub._();
  WebStorageStub._();

  final Map<String, String> _localStorage = {};
  final Map<String, String> _sessionStorage = {};

  Map<String, String> get localStorage => _localStorage;
  Map<String, String> get sessionStorage => _sessionStorage;
}

final window = WebStorageStub.instance;


















