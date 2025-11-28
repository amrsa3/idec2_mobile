// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return _SessionModel.fromJson(json);
}

/// @nodoc
mixin _$SessionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conferenceId')
  String get conferenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'eventId')
  String? get eventId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'startTime')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'endTime')
  DateTime get endTime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  Map<String, dynamic>? get conference => throw _privateConstructorUsedError;
  Map<String, dynamic>? get event => throw _privateConstructorUsedError;
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'speakersCount')
  int? get speakersCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionModelCopyWith<SessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionModelCopyWith<$Res> {
  factory $SessionModelCopyWith(
          SessionModel value, $Res Function(SessionModel) then) =
      _$SessionModelCopyWithImpl<$Res, SessionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conferenceId') String conferenceId,
      @JsonKey(name: 'eventId') String? eventId,
      String title,
      String? description,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      String? location,
      int? capacity,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      Map<String, dynamic>? conference,
      Map<String, dynamic>? event,
      @JsonKey(name: '_count') Map<String, dynamic>? count,
      @JsonKey(name: 'speakersCount') int? speakersCount});
}

/// @nodoc
class _$SessionModelCopyWithImpl<$Res, $Val extends SessionModel>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conferenceId = null,
    Object? eventId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = freezed,
    Object? capacity = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? conference = freezed,
    Object? event = freezed,
    Object? count = freezed,
    Object? speakersCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conferenceId: null == conferenceId
          ? _value.conferenceId
          : conferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      conference: freezed == conference
          ? _value.conference
          : conference // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      speakersCount: freezed == speakersCount
          ? _value.speakersCount
          : speakersCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionModelImplCopyWith<$Res>
    implements $SessionModelCopyWith<$Res> {
  factory _$$SessionModelImplCopyWith(
          _$SessionModelImpl value, $Res Function(_$SessionModelImpl) then) =
      __$$SessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conferenceId') String conferenceId,
      @JsonKey(name: 'eventId') String? eventId,
      String title,
      String? description,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      String? location,
      int? capacity,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      Map<String, dynamic>? conference,
      Map<String, dynamic>? event,
      @JsonKey(name: '_count') Map<String, dynamic>? count,
      @JsonKey(name: 'speakersCount') int? speakersCount});
}

/// @nodoc
class __$$SessionModelImplCopyWithImpl<$Res>
    extends _$SessionModelCopyWithImpl<$Res, _$SessionModelImpl>
    implements _$$SessionModelImplCopyWith<$Res> {
  __$$SessionModelImplCopyWithImpl(
      _$SessionModelImpl _value, $Res Function(_$SessionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conferenceId = null,
    Object? eventId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = freezed,
    Object? capacity = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? conference = freezed,
    Object? event = freezed,
    Object? count = freezed,
    Object? speakersCount = freezed,
  }) {
    return _then(_$SessionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conferenceId: null == conferenceId
          ? _value.conferenceId
          : conferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      conference: freezed == conference
          ? _value._conference
          : conference // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      event: freezed == event
          ? _value._event
          : event // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      count: freezed == count
          ? _value._count
          : count // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      speakersCount: freezed == speakersCount
          ? _value.speakersCount
          : speakersCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionModelImpl implements _SessionModel {
  const _$SessionModelImpl(
      {required this.id,
      @JsonKey(name: 'conferenceId') required this.conferenceId,
      @JsonKey(name: 'eventId') this.eventId,
      required this.title,
      this.description,
      @JsonKey(name: 'startTime') required this.startTime,
      @JsonKey(name: 'endTime') required this.endTime,
      this.location,
      this.capacity,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      final Map<String, dynamic>? conference,
      final Map<String, dynamic>? event,
      @JsonKey(name: '_count') final Map<String, dynamic>? count,
      @JsonKey(name: 'speakersCount') this.speakersCount})
      : _conference = conference,
        _event = event,
        _count = count;

  factory _$SessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'conferenceId')
  final String conferenceId;
  @override
  @JsonKey(name: 'eventId')
  final String? eventId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'startTime')
  final DateTime startTime;
  @override
  @JsonKey(name: 'endTime')
  final DateTime endTime;
  @override
  final String? location;
  @override
  final int? capacity;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
// Relations
  final Map<String, dynamic>? _conference;
// Relations
  @override
  Map<String, dynamic>? get conference {
    final value = _conference;
    if (value == null) return null;
    if (_conference is EqualUnmodifiableMapView) return _conference;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _event;
  @override
  Map<String, dynamic>? get event {
    final value = _event;
    if (value == null) return null;
    if (_event is EqualUnmodifiableMapView) return _event;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _count;
  @override
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count {
    final value = _count;
    if (value == null) return null;
    if (_count is EqualUnmodifiableMapView) return _count;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'speakersCount')
  final int? speakersCount;

  @override
  String toString() {
    return 'SessionModel(id: $id, conferenceId: $conferenceId, eventId: $eventId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, location: $location, capacity: $capacity, createdAt: $createdAt, updatedAt: $updatedAt, conference: $conference, event: $event, count: $count, speakersCount: $speakersCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conferenceId, conferenceId) ||
                other.conferenceId == conferenceId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._conference, _conference) &&
            const DeepCollectionEquality().equals(other._event, _event) &&
            const DeepCollectionEquality().equals(other._count, _count) &&
            (identical(other.speakersCount, speakersCount) ||
                other.speakersCount == speakersCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conferenceId,
      eventId,
      title,
      description,
      startTime,
      endTime,
      location,
      capacity,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_conference),
      const DeepCollectionEquality().hash(_event),
      const DeepCollectionEquality().hash(_count),
      speakersCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      __$$SessionModelImplCopyWithImpl<_$SessionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionModelImplToJson(
      this,
    );
  }
}

abstract class _SessionModel implements SessionModel {
  const factory _SessionModel(
          {required final String id,
          @JsonKey(name: 'conferenceId') required final String conferenceId,
          @JsonKey(name: 'eventId') final String? eventId,
          required final String title,
          final String? description,
          @JsonKey(name: 'startTime') required final DateTime startTime,
          @JsonKey(name: 'endTime') required final DateTime endTime,
          final String? location,
          final int? capacity,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
          final Map<String, dynamic>? conference,
          final Map<String, dynamic>? event,
          @JsonKey(name: '_count') final Map<String, dynamic>? count,
          @JsonKey(name: 'speakersCount') final int? speakersCount}) =
      _$SessionModelImpl;

  factory _SessionModel.fromJson(Map<String, dynamic> json) =
      _$SessionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'conferenceId')
  String get conferenceId;
  @override
  @JsonKey(name: 'eventId')
  String? get eventId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'startTime')
  DateTime get startTime;
  @override
  @JsonKey(name: 'endTime')
  DateTime get endTime;
  @override
  String? get location;
  @override
  int? get capacity;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override // Relations
  Map<String, dynamic>? get conference;
  @override
  Map<String, dynamic>? get event;
  @override
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count;
  @override
  @JsonKey(name: 'speakersCount')
  int? get speakersCount;
  @override
  @JsonKey(ignore: true)
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
