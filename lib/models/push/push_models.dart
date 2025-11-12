class FcmTopicOption {
  final String key;
  final String label;
  final String? description;

  const FcmTopicOption({
    required this.key,
    required this.label,
    this.description,
  });

  factory FcmTopicOption.fromJson(Map<String, dynamic> json) {
    return FcmTopicOption(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}

class DeviceTopicSubscription {
  final String topic;
  final DateTime subscribedAt;
  final DateTime? unsubscribedAt;

  const DeviceTopicSubscription({
    required this.topic,
    required this.subscribedAt,
    this.unsubscribedAt,
  });

  factory DeviceTopicSubscription.fromJson(Map<String, dynamic> json) {
    return DeviceTopicSubscription(
      topic: json['topic'] as String? ?? '',
      subscribedAt: DateTime.tryParse(json['subscribedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      unsubscribedAt: json['unsubscribedAt'] == null
          ? null
          : DateTime.tryParse(json['unsubscribedAt'] as String? ?? ''),
    );
  }
}

class DeviceTokenRecord {
  final String id;
  final String token;
  final String platform;
  final bool isActive;
  final DateTime? lastUsedAt;
  final List<DeviceTopicSubscription> topics;

  const DeviceTokenRecord({
    required this.id,
    required this.token,
    required this.platform,
    required this.isActive,
    required this.lastUsedAt,
    required this.topics,
  });

  factory DeviceTokenRecord.fromJson(Map<String, dynamic> json) {
    final topicsJson = json['topics'];
    final List<DeviceTopicSubscription> parsedTopics;
    if (topicsJson is List) {
      parsedTopics = topicsJson
          .map((item) => DeviceTopicSubscription.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList();
    } else {
      parsedTopics = const [];
    }

    return DeviceTokenRecord(
      id: json['id'] as String? ?? '',
      token: json['token'] as String? ?? '',
      platform: json['platform'] as String? ?? 'UNKNOWN',
      isActive: json['isActive'] as bool? ?? true,
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.tryParse(json['lastUsedAt'] as String? ?? ''),
      topics: parsedTopics,
    );
  }
}

class DeviceTokenTopicsResponse {
  final String? broadcast;
  final List<FcmTopicOption> optionalTopics;

  const DeviceTokenTopicsResponse({
    required this.broadcast,
    required this.optionalTopics,
  });

  factory DeviceTokenTopicsResponse.fromJson(Map<String, dynamic> json) {
    final optional = json['optional'];
    return DeviceTokenTopicsResponse(
      broadcast: json['broadcast'] as String?,
      optionalTopics: optional is List
          ? optional
              .map((item) => FcmTopicOption.fromJson(
                  Map<String, dynamic>.from(item as Map)))
              .toList()
          : const [],
    );
  }
}
