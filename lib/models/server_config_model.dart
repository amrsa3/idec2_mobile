import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config_model.freezed.dart';
part 'server_config_model.g.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    required String baseUrl,
    required int port,
    @Default(false) bool isDefault,
    @Default(true) bool isSecure,
    DateTime? lastTested,
    @Default(false) bool isReachable,
    int? responseTime,
  }) = _ServerConfig;

  factory ServerConfig.fromJson(Map<String, dynamic> json) => _$ServerConfigFromJson(json);

  const ServerConfig._();

  String get fullUrl {
    final protocol = isSecure ? 'https' : 'http';
    final portSuffix = (isSecure && port == 443) || (!isSecure && port == 80) 
        ? '' 
        : ':$port';
    return '$protocol://$baseUrl$portSuffix';
  }

  bool get isValidUrl {
    try {
      final uri = Uri.parse(fullUrl);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  bool get isValidPort {
    return port > 0 && port <= 65535;
  }

  bool get isValid {
    return isValidUrl && isValidPort && baseUrl.isNotEmpty;
  }
}

@freezed
class ServerConfigValidation with _$ServerConfigValidation {
  const factory ServerConfigValidation({
    String? urlError,
    String? portError,
    @Default(false) bool isValid,
  }) = _ServerConfigValidation;
}

// Default configurations
class DefaultServerConfigs {
  static final ServerConfig development = ServerConfig(
    baseUrl: 'api.idec-ye.com',
    port: 443,
    isDefault: true,
    isSecure: true,
  );

  static final ServerConfig production = ServerConfig(
    baseUrl: 'api.idec-ye.com',
    port: 443,
    isDefault: false,
    isSecure: true,
  );

  static final ServerConfig localhost = ServerConfig(
    baseUrl: 'api.idec-ye.com',
    port: 443,
    isDefault: false,
    isSecure: true,
  );

  static final ServerConfig localDevelopment = ServerConfig(
    baseUrl: 'api.idec-ye.com',
    port: 443,
    isDefault: false,
    isSecure: true,
  );

  static final ServerConfig emulator = ServerConfig(
    baseUrl: 'api.idec-ye.com',
    port: 443,
    isDefault: false,
    isSecure: true,
  );

  static List<ServerConfig> get presets => [
    development,
    production,
    localhost,
    localDevelopment,
    emulator,
  ];
}
