// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  String? get actionType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get actionData => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  List<String> get channels => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get templateData => throw _privateConstructorUsedError;
  String? get recipientId => throw _privateConstructorUsedError;
  String? get recipientType => throw _privateConstructorUsedError;
  String? get senderId => throw _privateConstructorUsedError;
  String? get senderType => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  DateTime? get sentAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String message,
      String? type,
      String? category,
      String status,
      String priority,
      String? actionUrl,
      String? actionType,
      Map<String, dynamic>? actionData,
      String? imageUrl,
      String? iconUrl,
      List<String> channels,
      String? templateId,
      Map<String, dynamic>? templateData,
      String? recipientId,
      String? recipientType,
      String? senderId,
      String? senderType,
      DateTime? scheduledAt,
      DateTime? sentAt,
      DateTime? readAt,
      DateTime? expiresAt,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? type = freezed,
    Object? category = freezed,
    Object? status = null,
    Object? priority = null,
    Object? actionUrl = freezed,
    Object? actionType = freezed,
    Object? actionData = freezed,
    Object? imageUrl = freezed,
    Object? iconUrl = freezed,
    Object? channels = null,
    Object? templateId = freezed,
    Object? templateData = freezed,
    Object? recipientId = freezed,
    Object? recipientType = freezed,
    Object? senderId = freezed,
    Object? senderType = freezed,
    Object? scheduledAt = freezed,
    Object? sentAt = freezed,
    Object? readAt = freezed,
    Object? expiresAt = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      actionData: freezed == actionData
          ? _value.actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateData: freezed == templateData
          ? _value.templateData
          : templateData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientType: freezed == recipientType
          ? _value.recipientType
          : recipientType // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderType: freezed == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String message,
      String? type,
      String? category,
      String status,
      String priority,
      String? actionUrl,
      String? actionType,
      Map<String, dynamic>? actionData,
      String? imageUrl,
      String? iconUrl,
      List<String> channels,
      String? templateId,
      Map<String, dynamic>? templateData,
      String? recipientId,
      String? recipientType,
      String? senderId,
      String? senderType,
      DateTime? scheduledAt,
      DateTime? sentAt,
      DateTime? readAt,
      DateTime? expiresAt,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? type = freezed,
    Object? category = freezed,
    Object? status = null,
    Object? priority = null,
    Object? actionUrl = freezed,
    Object? actionType = freezed,
    Object? actionData = freezed,
    Object? imageUrl = freezed,
    Object? iconUrl = freezed,
    Object? channels = null,
    Object? templateId = freezed,
    Object? templateData = freezed,
    Object? recipientId = freezed,
    Object? recipientType = freezed,
    Object? senderId = freezed,
    Object? senderType = freezed,
    Object? scheduledAt = freezed,
    Object? sentAt = freezed,
    Object? readAt = freezed,
    Object? expiresAt = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      actionData: freezed == actionData
          ? _value._actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      channels: null == channels
          ? _value._channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateData: freezed == templateData
          ? _value._templateData
          : templateData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientType: freezed == recipientType
          ? _value.recipientType
          : recipientType // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderType: freezed == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.title,
      required this.message,
      this.type,
      this.category,
      this.status = 'unread',
      this.priority = 'normal',
      this.actionUrl,
      this.actionType,
      final Map<String, dynamic>? actionData,
      this.imageUrl,
      this.iconUrl,
      final List<String> channels = const [],
      this.templateId,
      final Map<String, dynamic>? templateData,
      this.recipientId,
      this.recipientType,
      this.senderId,
      this.senderType,
      this.scheduledAt,
      this.sentAt,
      this.readAt,
      this.expiresAt,
      final Map<String, dynamic>? metadata,
      required this.createdAt,
      this.updatedAt})
      : _actionData = actionData,
        _channels = channels,
        _templateData = templateData,
        _metadata = metadata;

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String message;
  @override
  final String? type;
  @override
  final String? category;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String priority;
  @override
  final String? actionUrl;
  @override
  final String? actionType;
  final Map<String, dynamic>? _actionData;
  @override
  Map<String, dynamic>? get actionData {
    final value = _actionData;
    if (value == null) return null;
    if (_actionData is EqualUnmodifiableMapView) return _actionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? imageUrl;
  @override
  final String? iconUrl;
  final List<String> _channels;
  @override
  @JsonKey()
  List<String> get channels {
    if (_channels is EqualUnmodifiableListView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_channels);
  }

  @override
  final String? templateId;
  final Map<String, dynamic>? _templateData;
  @override
  Map<String, dynamic>? get templateData {
    final value = _templateData;
    if (value == null) return null;
    if (_templateData is EqualUnmodifiableMapView) return _templateData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? recipientId;
  @override
  final String? recipientType;
  @override
  final String? senderId;
  @override
  final String? senderType;
  @override
  final DateTime? scheduledAt;
  @override
  final DateTime? sentAt;
  @override
  final DateTime? readAt;
  @override
  final DateTime? expiresAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, type: $type, category: $category, status: $status, priority: $priority, actionUrl: $actionUrl, actionType: $actionType, actionData: $actionData, imageUrl: $imageUrl, iconUrl: $iconUrl, channels: $channels, templateId: $templateId, templateData: $templateData, recipientId: $recipientId, recipientType: $recipientType, senderId: $senderId, senderType: $senderType, scheduledAt: $scheduledAt, sentAt: $sentAt, readAt: $readAt, expiresAt: $expiresAt, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality()
                .equals(other._actionData, _actionData) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            const DeepCollectionEquality().equals(other._channels, _channels) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            const DeepCollectionEquality()
                .equals(other._templateData, _templateData) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.recipientType, recipientType) ||
                other.recipientType == recipientType) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderType, senderType) ||
                other.senderType == senderType) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        message,
        type,
        category,
        status,
        priority,
        actionUrl,
        actionType,
        const DeepCollectionEquality().hash(_actionData),
        imageUrl,
        iconUrl,
        const DeepCollectionEquality().hash(_channels),
        templateId,
        const DeepCollectionEquality().hash(_templateData),
        recipientId,
        recipientType,
        senderId,
        senderType,
        scheduledAt,
        sentAt,
        readAt,
        expiresAt,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel(
      {required final String id,
      required final String title,
      required final String message,
      final String? type,
      final String? category,
      final String status,
      final String priority,
      final String? actionUrl,
      final String? actionType,
      final Map<String, dynamic>? actionData,
      final String? imageUrl,
      final String? iconUrl,
      final List<String> channels,
      final String? templateId,
      final Map<String, dynamic>? templateData,
      final String? recipientId,
      final String? recipientType,
      final String? senderId,
      final String? senderType,
      final DateTime? scheduledAt,
      final DateTime? sentAt,
      final DateTime? readAt,
      final DateTime? expiresAt,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get message;
  @override
  String? get type;
  @override
  String? get category;
  @override
  String get status;
  @override
  String get priority;
  @override
  String? get actionUrl;
  @override
  String? get actionType;
  @override
  Map<String, dynamic>? get actionData;
  @override
  String? get imageUrl;
  @override
  String? get iconUrl;
  @override
  List<String> get channels;
  @override
  String? get templateId;
  @override
  Map<String, dynamic>? get templateData;
  @override
  String? get recipientId;
  @override
  String? get recipientType;
  @override
  String? get senderId;
  @override
  String? get senderType;
  @override
  DateTime? get scheduledAt;
  @override
  DateTime? get sentAt;
  @override
  DateTime? get readAt;
  @override
  DateTime? get expiresAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  String get userId => throw _privateConstructorUsedError;
  bool get emailNotifications => throw _privateConstructorUsedError;
  bool get pushNotifications => throw _privateConstructorUsedError;
  bool get smsNotifications => throw _privateConstructorUsedError;
  bool get inAppNotifications => throw _privateConstructorUsedError;
  bool get eventReminders => throw _privateConstructorUsedError;
  bool get systemUpdates => throw _privateConstructorUsedError;
  bool get marketingEmails => throw _privateConstructorUsedError;
  bool get securityAlerts => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  List<String> get mutedCategories => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {String userId,
      bool emailNotifications,
      bool pushNotifications,
      bool smsNotifications,
      bool inAppNotifications,
      bool eventReminders,
      bool systemUpdates,
      bool marketingEmails,
      bool securityAlerts,
      String frequency,
      List<String> mutedCategories,
      Map<String, dynamic>? preferences,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? inAppNotifications = null,
    Object? eventReminders = null,
    Object? systemUpdates = null,
    Object? marketingEmails = null,
    Object? securityAlerts = null,
    Object? frequency = null,
    Object? mutedCategories = null,
    Object? preferences = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      inAppNotifications: null == inAppNotifications
          ? _value.inAppNotifications
          : inAppNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminders: null == eventReminders
          ? _value.eventReminders
          : eventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      systemUpdates: null == systemUpdates
          ? _value.systemUpdates
          : systemUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingEmails: null == marketingEmails
          ? _value.marketingEmails
          : marketingEmails // ignore: cast_nullable_to_non_nullable
              as bool,
      securityAlerts: null == securityAlerts
          ? _value.securityAlerts
          : securityAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      mutedCategories: null == mutedCategories
          ? _value.mutedCategories
          : mutedCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool emailNotifications,
      bool pushNotifications,
      bool smsNotifications,
      bool inAppNotifications,
      bool eventReminders,
      bool systemUpdates,
      bool marketingEmails,
      bool securityAlerts,
      String frequency,
      List<String> mutedCategories,
      Map<String, dynamic>? preferences,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? inAppNotifications = null,
    Object? eventReminders = null,
    Object? systemUpdates = null,
    Object? marketingEmails = null,
    Object? securityAlerts = null,
    Object? frequency = null,
    Object? mutedCategories = null,
    Object? preferences = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NotificationSettingsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      inAppNotifications: null == inAppNotifications
          ? _value.inAppNotifications
          : inAppNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminders: null == eventReminders
          ? _value.eventReminders
          : eventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      systemUpdates: null == systemUpdates
          ? _value.systemUpdates
          : systemUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingEmails: null == marketingEmails
          ? _value.marketingEmails
          : marketingEmails // ignore: cast_nullable_to_non_nullable
              as bool,
      securityAlerts: null == securityAlerts
          ? _value.securityAlerts
          : securityAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      mutedCategories: null == mutedCategories
          ? _value._mutedCategories
          : mutedCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl(
      {required this.userId,
      this.emailNotifications = true,
      this.pushNotifications = true,
      this.smsNotifications = true,
      this.inAppNotifications = true,
      this.eventReminders = true,
      this.systemUpdates = true,
      this.marketingEmails = true,
      this.securityAlerts = true,
      this.frequency = 'all',
      final List<String> mutedCategories = const [],
      final Map<String, dynamic>? preferences,
      required this.createdAt,
      this.updatedAt})
      : _mutedCategories = mutedCategories,
        _preferences = preferences;

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  final bool pushNotifications;
  @override
  @JsonKey()
  final bool smsNotifications;
  @override
  @JsonKey()
  final bool inAppNotifications;
  @override
  @JsonKey()
  final bool eventReminders;
  @override
  @JsonKey()
  final bool systemUpdates;
  @override
  @JsonKey()
  final bool marketingEmails;
  @override
  @JsonKey()
  final bool securityAlerts;
  @override
  @JsonKey()
  final String frequency;
  final List<String> _mutedCategories;
  @override
  @JsonKey()
  List<String> get mutedCategories {
    if (_mutedCategories is EqualUnmodifiableListView) return _mutedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mutedCategories);
  }

  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NotificationSettings(userId: $userId, emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, smsNotifications: $smsNotifications, inAppNotifications: $inAppNotifications, eventReminders: $eventReminders, systemUpdates: $systemUpdates, marketingEmails: $marketingEmails, securityAlerts: $securityAlerts, frequency: $frequency, mutedCategories: $mutedCategories, preferences: $preferences, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.smsNotifications, smsNotifications) ||
                other.smsNotifications == smsNotifications) &&
            (identical(other.inAppNotifications, inAppNotifications) ||
                other.inAppNotifications == inAppNotifications) &&
            (identical(other.eventReminders, eventReminders) ||
                other.eventReminders == eventReminders) &&
            (identical(other.systemUpdates, systemUpdates) ||
                other.systemUpdates == systemUpdates) &&
            (identical(other.marketingEmails, marketingEmails) ||
                other.marketingEmails == marketingEmails) &&
            (identical(other.securityAlerts, securityAlerts) ||
                other.securityAlerts == securityAlerts) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality()
                .equals(other._mutedCategories, _mutedCategories) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      emailNotifications,
      pushNotifications,
      smsNotifications,
      inAppNotifications,
      eventReminders,
      systemUpdates,
      marketingEmails,
      securityAlerts,
      frequency,
      const DeepCollectionEquality().hash(_mutedCategories),
      const DeepCollectionEquality().hash(_preferences),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings(
      {required final String userId,
      final bool emailNotifications,
      final bool pushNotifications,
      final bool smsNotifications,
      final bool inAppNotifications,
      final bool eventReminders,
      final bool systemUpdates,
      final bool marketingEmails,
      final bool securityAlerts,
      final String frequency,
      final List<String> mutedCategories,
      final Map<String, dynamic>? preferences,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

  @override
  String get userId;
  @override
  bool get emailNotifications;
  @override
  bool get pushNotifications;
  @override
  bool get smsNotifications;
  @override
  bool get inAppNotifications;
  @override
  bool get eventReminders;
  @override
  bool get systemUpdates;
  @override
  bool get marketingEmails;
  @override
  bool get securityAlerts;
  @override
  String get frequency;
  @override
  List<String> get mutedCategories;
  @override
  Map<String, dynamic>? get preferences;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationTemplate _$NotificationTemplateFromJson(Map<String, dynamic> json) {
  return _NotificationTemplate.fromJson(json);
}

/// @nodoc
mixin _$NotificationTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String> get channels => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Map<String, dynamic>? get defaultData => throw _privateConstructorUsedError;
  List<String>? get requiredVariables => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationTemplateCopyWith<NotificationTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationTemplateCopyWith<$Res> {
  factory $NotificationTemplateCopyWith(NotificationTemplate value,
          $Res Function(NotificationTemplate) then) =
      _$NotificationTemplateCopyWithImpl<$Res, NotificationTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String title,
      String message,
      String? description,
      String? type,
      String? category,
      List<String> channels,
      String priority,
      bool isActive,
      Map<String, dynamic>? defaultData,
      List<String>? requiredVariables,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NotificationTemplateCopyWithImpl<$Res,
        $Val extends NotificationTemplate>
    implements $NotificationTemplateCopyWith<$Res> {
  _$NotificationTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? title = null,
    Object? message = null,
    Object? description = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? channels = null,
    Object? priority = null,
    Object? isActive = null,
    Object? defaultData = freezed,
    Object? requiredVariables = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultData: freezed == defaultData
          ? _value.defaultData
          : defaultData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      requiredVariables: freezed == requiredVariables
          ? _value.requiredVariables
          : requiredVariables // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationTemplateImplCopyWith<$Res>
    implements $NotificationTemplateCopyWith<$Res> {
  factory _$$NotificationTemplateImplCopyWith(_$NotificationTemplateImpl value,
          $Res Function(_$NotificationTemplateImpl) then) =
      __$$NotificationTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String title,
      String message,
      String? description,
      String? type,
      String? category,
      List<String> channels,
      String priority,
      bool isActive,
      Map<String, dynamic>? defaultData,
      List<String>? requiredVariables,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NotificationTemplateImplCopyWithImpl<$Res>
    extends _$NotificationTemplateCopyWithImpl<$Res, _$NotificationTemplateImpl>
    implements _$$NotificationTemplateImplCopyWith<$Res> {
  __$$NotificationTemplateImplCopyWithImpl(_$NotificationTemplateImpl _value,
      $Res Function(_$NotificationTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? title = null,
    Object? message = null,
    Object? description = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? channels = null,
    Object? priority = null,
    Object? isActive = null,
    Object? defaultData = freezed,
    Object? requiredVariables = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NotificationTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      channels: null == channels
          ? _value._channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultData: freezed == defaultData
          ? _value._defaultData
          : defaultData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      requiredVariables: freezed == requiredVariables
          ? _value._requiredVariables
          : requiredVariables // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationTemplateImpl implements _NotificationTemplate {
  const _$NotificationTemplateImpl(
      {required this.id,
      required this.name,
      required this.title,
      required this.message,
      this.description,
      this.type,
      this.category,
      final List<String> channels = const [],
      this.priority = 'normal',
      this.isActive = true,
      final Map<String, dynamic>? defaultData,
      final List<String>? requiredVariables,
      final Map<String, dynamic>? metadata,
      required this.createdAt,
      this.updatedAt})
      : _channels = channels,
        _defaultData = defaultData,
        _requiredVariables = requiredVariables,
        _metadata = metadata;

  factory _$NotificationTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String title;
  @override
  final String message;
  @override
  final String? description;
  @override
  final String? type;
  @override
  final String? category;
  final List<String> _channels;
  @override
  @JsonKey()
  List<String> get channels {
    if (_channels is EqualUnmodifiableListView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_channels);
  }

  @override
  @JsonKey()
  final String priority;
  @override
  @JsonKey()
  final bool isActive;
  final Map<String, dynamic>? _defaultData;
  @override
  Map<String, dynamic>? get defaultData {
    final value = _defaultData;
    if (value == null) return null;
    if (_defaultData is EqualUnmodifiableMapView) return _defaultData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _requiredVariables;
  @override
  List<String>? get requiredVariables {
    final value = _requiredVariables;
    if (value == null) return null;
    if (_requiredVariables is EqualUnmodifiableListView)
      return _requiredVariables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NotificationTemplate(id: $id, name: $name, title: $title, message: $message, description: $description, type: $type, category: $category, channels: $channels, priority: $priority, isActive: $isActive, defaultData: $defaultData, requiredVariables: $requiredVariables, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._channels, _channels) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other._defaultData, _defaultData) &&
            const DeepCollectionEquality()
                .equals(other._requiredVariables, _requiredVariables) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      title,
      message,
      description,
      type,
      category,
      const DeepCollectionEquality().hash(_channels),
      priority,
      isActive,
      const DeepCollectionEquality().hash(_defaultData),
      const DeepCollectionEquality().hash(_requiredVariables),
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationTemplateImplCopyWith<_$NotificationTemplateImpl>
      get copyWith =>
          __$$NotificationTemplateImplCopyWithImpl<_$NotificationTemplateImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationTemplateImplToJson(
      this,
    );
  }
}

abstract class _NotificationTemplate implements NotificationTemplate {
  const factory _NotificationTemplate(
      {required final String id,
      required final String name,
      required final String title,
      required final String message,
      final String? description,
      final String? type,
      final String? category,
      final List<String> channels,
      final String priority,
      final bool isActive,
      final Map<String, dynamic>? defaultData,
      final List<String>? requiredVariables,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NotificationTemplateImpl;

  factory _NotificationTemplate.fromJson(Map<String, dynamic> json) =
      _$NotificationTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get title;
  @override
  String get message;
  @override
  String? get description;
  @override
  String? get type;
  @override
  String? get category;
  @override
  List<String> get channels;
  @override
  String get priority;
  @override
  bool get isActive;
  @override
  Map<String, dynamic>? get defaultData;
  @override
  List<String>? get requiredVariables;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationTemplateImplCopyWith<_$NotificationTemplateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SendNotificationRequest _$SendNotificationRequestFromJson(
    Map<String, dynamic> json) {
  return _SendNotificationRequest.fromJson(json);
}

/// @nodoc
mixin _$SendNotificationRequest {
  String get templateId => throw _privateConstructorUsedError;
  List<String> get recipients => throw _privateConstructorUsedError;
  Map<String, dynamic>? get templateData => throw _privateConstructorUsedError;
  List<String> get channels => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SendNotificationRequestCopyWith<SendNotificationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendNotificationRequestCopyWith<$Res> {
  factory $SendNotificationRequestCopyWith(SendNotificationRequest value,
          $Res Function(SendNotificationRequest) then) =
      _$SendNotificationRequestCopyWithImpl<$Res, SendNotificationRequest>;
  @useResult
  $Res call(
      {String templateId,
      List<String> recipients,
      Map<String, dynamic>? templateData,
      List<String> channels,
      String priority,
      DateTime? scheduledAt});
}

/// @nodoc
class _$SendNotificationRequestCopyWithImpl<$Res,
        $Val extends SendNotificationRequest>
    implements $SendNotificationRequestCopyWith<$Res> {
  _$SendNotificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? recipients = null,
    Object? templateData = freezed,
    Object? channels = null,
    Object? priority = null,
    Object? scheduledAt = freezed,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      recipients: null == recipients
          ? _value.recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      templateData: freezed == templateData
          ? _value.templateData
          : templateData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendNotificationRequestImplCopyWith<$Res>
    implements $SendNotificationRequestCopyWith<$Res> {
  factory _$$SendNotificationRequestImplCopyWith(
          _$SendNotificationRequestImpl value,
          $Res Function(_$SendNotificationRequestImpl) then) =
      __$$SendNotificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String templateId,
      List<String> recipients,
      Map<String, dynamic>? templateData,
      List<String> channels,
      String priority,
      DateTime? scheduledAt});
}

/// @nodoc
class __$$SendNotificationRequestImplCopyWithImpl<$Res>
    extends _$SendNotificationRequestCopyWithImpl<$Res,
        _$SendNotificationRequestImpl>
    implements _$$SendNotificationRequestImplCopyWith<$Res> {
  __$$SendNotificationRequestImplCopyWithImpl(
      _$SendNotificationRequestImpl _value,
      $Res Function(_$SendNotificationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? recipients = null,
    Object? templateData = freezed,
    Object? channels = null,
    Object? priority = null,
    Object? scheduledAt = freezed,
  }) {
    return _then(_$SendNotificationRequestImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      recipients: null == recipients
          ? _value._recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      templateData: freezed == templateData
          ? _value._templateData
          : templateData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      channels: null == channels
          ? _value._channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendNotificationRequestImpl implements _SendNotificationRequest {
  const _$SendNotificationRequestImpl(
      {required this.templateId,
      required final List<String> recipients,
      final Map<String, dynamic>? templateData,
      final List<String> channels = const ['in_app'],
      this.priority = 'normal',
      this.scheduledAt})
      : _recipients = recipients,
        _templateData = templateData,
        _channels = channels;

  factory _$SendNotificationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendNotificationRequestImplFromJson(json);

  @override
  final String templateId;
  final List<String> _recipients;
  @override
  List<String> get recipients {
    if (_recipients is EqualUnmodifiableListView) return _recipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipients);
  }

  final Map<String, dynamic>? _templateData;
  @override
  Map<String, dynamic>? get templateData {
    final value = _templateData;
    if (value == null) return null;
    if (_templateData is EqualUnmodifiableMapView) return _templateData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _channels;
  @override
  @JsonKey()
  List<String> get channels {
    if (_channels is EqualUnmodifiableListView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_channels);
  }

  @override
  @JsonKey()
  final String priority;
  @override
  final DateTime? scheduledAt;

  @override
  String toString() {
    return 'SendNotificationRequest(templateId: $templateId, recipients: $recipients, templateData: $templateData, channels: $channels, priority: $priority, scheduledAt: $scheduledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendNotificationRequestImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            const DeepCollectionEquality()
                .equals(other._recipients, _recipients) &&
            const DeepCollectionEquality()
                .equals(other._templateData, _templateData) &&
            const DeepCollectionEquality().equals(other._channels, _channels) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      templateId,
      const DeepCollectionEquality().hash(_recipients),
      const DeepCollectionEquality().hash(_templateData),
      const DeepCollectionEquality().hash(_channels),
      priority,
      scheduledAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SendNotificationRequestImplCopyWith<_$SendNotificationRequestImpl>
      get copyWith => __$$SendNotificationRequestImplCopyWithImpl<
          _$SendNotificationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendNotificationRequestImplToJson(
      this,
    );
  }
}

abstract class _SendNotificationRequest implements SendNotificationRequest {
  const factory _SendNotificationRequest(
      {required final String templateId,
      required final List<String> recipients,
      final Map<String, dynamic>? templateData,
      final List<String> channels,
      final String priority,
      final DateTime? scheduledAt}) = _$SendNotificationRequestImpl;

  factory _SendNotificationRequest.fromJson(Map<String, dynamic> json) =
      _$SendNotificationRequestImpl.fromJson;

  @override
  String get templateId;
  @override
  List<String> get recipients;
  @override
  Map<String, dynamic>? get templateData;
  @override
  List<String> get channels;
  @override
  String get priority;
  @override
  DateTime? get scheduledAt;
  @override
  @JsonKey(ignore: true)
  _$$SendNotificationRequestImplCopyWith<_$SendNotificationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationResponse _$NotificationResponseFromJson(Map<String, dynamic> json) {
  return _NotificationResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get notificationId => throw _privateConstructorUsedError;
  List<String> get sentTo => throw _privateConstructorUsedError;
  List<String> get failedRecipients => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationResponseCopyWith<NotificationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationResponseCopyWith<$Res> {
  factory $NotificationResponseCopyWith(NotificationResponse value,
          $Res Function(NotificationResponse) then) =
      _$NotificationResponseCopyWithImpl<$Res, NotificationResponse>;
  @useResult
  $Res call(
      {bool success,
      String? message,
      String? notificationId,
      List<String> sentTo,
      List<String> failedRecipients,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$NotificationResponseCopyWithImpl<$Res,
        $Val extends NotificationResponse>
    implements $NotificationResponseCopyWith<$Res> {
  _$NotificationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? notificationId = freezed,
    Object? sentTo = null,
    Object? failedRecipients = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      sentTo: null == sentTo
          ? _value.sentTo
          : sentTo // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failedRecipients: null == failedRecipients
          ? _value.failedRecipients
          : failedRecipients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationResponseImplCopyWith<$Res>
    implements $NotificationResponseCopyWith<$Res> {
  factory _$$NotificationResponseImplCopyWith(_$NotificationResponseImpl value,
          $Res Function(_$NotificationResponseImpl) then) =
      __$$NotificationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? message,
      String? notificationId,
      List<String> sentTo,
      List<String> failedRecipients,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$NotificationResponseImplCopyWithImpl<$Res>
    extends _$NotificationResponseCopyWithImpl<$Res, _$NotificationResponseImpl>
    implements _$$NotificationResponseImplCopyWith<$Res> {
  __$$NotificationResponseImplCopyWithImpl(_$NotificationResponseImpl _value,
      $Res Function(_$NotificationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? notificationId = freezed,
    Object? sentTo = null,
    Object? failedRecipients = null,
    Object? metadata = freezed,
  }) {
    return _then(_$NotificationResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      sentTo: null == sentTo
          ? _value._sentTo
          : sentTo // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failedRecipients: null == failedRecipients
          ? _value._failedRecipients
          : failedRecipients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationResponseImpl implements _NotificationResponse {
  const _$NotificationResponseImpl(
      {required this.success,
      this.message,
      this.notificationId,
      final List<String> sentTo = const [],
      final List<String> failedRecipients = const [],
      final Map<String, dynamic>? metadata})
      : _sentTo = sentTo,
        _failedRecipients = failedRecipients,
        _metadata = metadata;

  factory _$NotificationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;
  @override
  final String? notificationId;
  final List<String> _sentTo;
  @override
  @JsonKey()
  List<String> get sentTo {
    if (_sentTo is EqualUnmodifiableListView) return _sentTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sentTo);
  }

  final List<String> _failedRecipients;
  @override
  @JsonKey()
  List<String> get failedRecipients {
    if (_failedRecipients is EqualUnmodifiableListView)
      return _failedRecipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedRecipients);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NotificationResponse(success: $success, message: $message, notificationId: $notificationId, sentTo: $sentTo, failedRecipients: $failedRecipients, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            const DeepCollectionEquality().equals(other._sentTo, _sentTo) &&
            const DeepCollectionEquality()
                .equals(other._failedRecipients, _failedRecipients) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      notificationId,
      const DeepCollectionEquality().hash(_sentTo),
      const DeepCollectionEquality().hash(_failedRecipients),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationResponseImplCopyWith<_$NotificationResponseImpl>
      get copyWith =>
          __$$NotificationResponseImplCopyWithImpl<_$NotificationResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationResponseImplToJson(
      this,
    );
  }
}

abstract class _NotificationResponse implements NotificationResponse {
  const factory _NotificationResponse(
      {required final bool success,
      final String? message,
      final String? notificationId,
      final List<String> sentTo,
      final List<String> failedRecipients,
      final Map<String, dynamic>? metadata}) = _$NotificationResponseImpl;

  factory _NotificationResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  String? get notificationId;
  @override
  List<String> get sentTo;
  @override
  List<String> get failedRecipients;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$NotificationResponseImplCopyWith<_$NotificationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationStats _$NotificationStatsFromJson(Map<String, dynamic> json) {
  return _NotificationStats.fromJson(json);
}

/// @nodoc
mixin _$NotificationStats {
  int get totalNotifications => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  int get readCount => throw _privateConstructorUsedError;
  Map<String, int>? get categoryStats => throw _privateConstructorUsedError;
  Map<String, int>? get typeStats => throw _privateConstructorUsedError;
  Map<String, int>? get priorityStats => throw _privateConstructorUsedError;
  DateTime? get lastNotificationAt => throw _privateConstructorUsedError;
  DateTime? get lastReadAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationStatsCopyWith<NotificationStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStatsCopyWith<$Res> {
  factory $NotificationStatsCopyWith(
          NotificationStats value, $Res Function(NotificationStats) then) =
      _$NotificationStatsCopyWithImpl<$Res, NotificationStats>;
  @useResult
  $Res call(
      {int totalNotifications,
      int unreadCount,
      int readCount,
      Map<String, int>? categoryStats,
      Map<String, int>? typeStats,
      Map<String, int>? priorityStats,
      DateTime? lastNotificationAt,
      DateTime? lastReadAt});
}

/// @nodoc
class _$NotificationStatsCopyWithImpl<$Res, $Val extends NotificationStats>
    implements $NotificationStatsCopyWith<$Res> {
  _$NotificationStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNotifications = null,
    Object? unreadCount = null,
    Object? readCount = null,
    Object? categoryStats = freezed,
    Object? typeStats = freezed,
    Object? priorityStats = freezed,
    Object? lastNotificationAt = freezed,
    Object? lastReadAt = freezed,
  }) {
    return _then(_value.copyWith(
      totalNotifications: null == totalNotifications
          ? _value.totalNotifications
          : totalNotifications // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      readCount: null == readCount
          ? _value.readCount
          : readCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryStats: freezed == categoryStats
          ? _value.categoryStats
          : categoryStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      typeStats: freezed == typeStats
          ? _value.typeStats
          : typeStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      priorityStats: freezed == priorityStats
          ? _value.priorityStats
          : priorityStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      lastNotificationAt: freezed == lastNotificationAt
          ? _value.lastNotificationAt
          : lastNotificationAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReadAt: freezed == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationStatsImplCopyWith<$Res>
    implements $NotificationStatsCopyWith<$Res> {
  factory _$$NotificationStatsImplCopyWith(_$NotificationStatsImpl value,
          $Res Function(_$NotificationStatsImpl) then) =
      __$$NotificationStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalNotifications,
      int unreadCount,
      int readCount,
      Map<String, int>? categoryStats,
      Map<String, int>? typeStats,
      Map<String, int>? priorityStats,
      DateTime? lastNotificationAt,
      DateTime? lastReadAt});
}

/// @nodoc
class __$$NotificationStatsImplCopyWithImpl<$Res>
    extends _$NotificationStatsCopyWithImpl<$Res, _$NotificationStatsImpl>
    implements _$$NotificationStatsImplCopyWith<$Res> {
  __$$NotificationStatsImplCopyWithImpl(_$NotificationStatsImpl _value,
      $Res Function(_$NotificationStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNotifications = null,
    Object? unreadCount = null,
    Object? readCount = null,
    Object? categoryStats = freezed,
    Object? typeStats = freezed,
    Object? priorityStats = freezed,
    Object? lastNotificationAt = freezed,
    Object? lastReadAt = freezed,
  }) {
    return _then(_$NotificationStatsImpl(
      totalNotifications: null == totalNotifications
          ? _value.totalNotifications
          : totalNotifications // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      readCount: null == readCount
          ? _value.readCount
          : readCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryStats: freezed == categoryStats
          ? _value._categoryStats
          : categoryStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      typeStats: freezed == typeStats
          ? _value._typeStats
          : typeStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      priorityStats: freezed == priorityStats
          ? _value._priorityStats
          : priorityStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      lastNotificationAt: freezed == lastNotificationAt
          ? _value.lastNotificationAt
          : lastNotificationAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReadAt: freezed == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationStatsImpl implements _NotificationStats {
  const _$NotificationStatsImpl(
      {required this.totalNotifications,
      required this.unreadCount,
      required this.readCount,
      final Map<String, int>? categoryStats,
      final Map<String, int>? typeStats,
      final Map<String, int>? priorityStats,
      this.lastNotificationAt,
      this.lastReadAt})
      : _categoryStats = categoryStats,
        _typeStats = typeStats,
        _priorityStats = priorityStats;

  factory _$NotificationStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationStatsImplFromJson(json);

  @override
  final int totalNotifications;
  @override
  final int unreadCount;
  @override
  final int readCount;
  final Map<String, int>? _categoryStats;
  @override
  Map<String, int>? get categoryStats {
    final value = _categoryStats;
    if (value == null) return null;
    if (_categoryStats is EqualUnmodifiableMapView) return _categoryStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, int>? _typeStats;
  @override
  Map<String, int>? get typeStats {
    final value = _typeStats;
    if (value == null) return null;
    if (_typeStats is EqualUnmodifiableMapView) return _typeStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, int>? _priorityStats;
  @override
  Map<String, int>? get priorityStats {
    final value = _priorityStats;
    if (value == null) return null;
    if (_priorityStats is EqualUnmodifiableMapView) return _priorityStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? lastNotificationAt;
  @override
  final DateTime? lastReadAt;

  @override
  String toString() {
    return 'NotificationStats(totalNotifications: $totalNotifications, unreadCount: $unreadCount, readCount: $readCount, categoryStats: $categoryStats, typeStats: $typeStats, priorityStats: $priorityStats, lastNotificationAt: $lastNotificationAt, lastReadAt: $lastReadAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationStatsImpl &&
            (identical(other.totalNotifications, totalNotifications) ||
                other.totalNotifications == totalNotifications) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.readCount, readCount) ||
                other.readCount == readCount) &&
            const DeepCollectionEquality()
                .equals(other._categoryStats, _categoryStats) &&
            const DeepCollectionEquality()
                .equals(other._typeStats, _typeStats) &&
            const DeepCollectionEquality()
                .equals(other._priorityStats, _priorityStats) &&
            (identical(other.lastNotificationAt, lastNotificationAt) ||
                other.lastNotificationAt == lastNotificationAt) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalNotifications,
      unreadCount,
      readCount,
      const DeepCollectionEquality().hash(_categoryStats),
      const DeepCollectionEquality().hash(_typeStats),
      const DeepCollectionEquality().hash(_priorityStats),
      lastNotificationAt,
      lastReadAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationStatsImplCopyWith<_$NotificationStatsImpl> get copyWith =>
      __$$NotificationStatsImplCopyWithImpl<_$NotificationStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationStatsImplToJson(
      this,
    );
  }
}

abstract class _NotificationStats implements NotificationStats {
  const factory _NotificationStats(
      {required final int totalNotifications,
      required final int unreadCount,
      required final int readCount,
      final Map<String, int>? categoryStats,
      final Map<String, int>? typeStats,
      final Map<String, int>? priorityStats,
      final DateTime? lastNotificationAt,
      final DateTime? lastReadAt}) = _$NotificationStatsImpl;

  factory _NotificationStats.fromJson(Map<String, dynamic> json) =
      _$NotificationStatsImpl.fromJson;

  @override
  int get totalNotifications;
  @override
  int get unreadCount;
  @override
  int get readCount;
  @override
  Map<String, int>? get categoryStats;
  @override
  Map<String, int>? get typeStats;
  @override
  Map<String, int>? get priorityStats;
  @override
  DateTime? get lastNotificationAt;
  @override
  DateTime? get lastReadAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationStatsImplCopyWith<_$NotificationStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
