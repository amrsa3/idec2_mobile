// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conferenceId')
  String get conferenceId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'COURSE' | 'WORKSHOP' | 'SEMINAR'
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoryId')
  String? get categoryId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'startTime')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'endTime')
  DateTime get endTime => throw _privateConstructorUsedError;
  double? get duration => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool? get isActive => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'instructorId')
  String? get instructorId => throw _privateConstructorUsedError;
  String? get requirements => throw _privateConstructorUsedError;
  @JsonKey(name: 'courseDetails')
  String? get courseDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'courseLevel')
  String? get courseLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'promotionalImages')
  List<String>? get promotionalImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'promotionalVideo')
  String? get promotionalVideo => throw _privateConstructorUsedError;
  bool? get certificate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscriptionPolicy')
  String? get subscriptionPolicy => throw _privateConstructorUsedError;
  @JsonKey(name: 'processingMechanism')
  String? get processingMechanism => throw _privateConstructorUsedError;
  @JsonKey(name: 'submissionPolicy')
  String? get submissionPolicy => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentDeadlineEnabled')
  bool? get paymentDeadlineEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentDeadlineDays')
  int? get paymentDeadlineDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentMethods')
  List<String>? get paymentMethods => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscriptionRules')
  String? get subscriptionRules => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  Map<String, dynamic>? get conference => throw _privateConstructorUsedError;
  Map<String, dynamic>? get instructor => throw _privateConstructorUsedError;
  @JsonKey(name: 'speakers')
  List<Map<String, dynamic>>? get speakers =>
      throw _privateConstructorUsedError;
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conferenceId') String conferenceId,
      String type,
      String? category,
      @JsonKey(name: 'categoryId') String? categoryId,
      String title,
      String? description,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      double? duration,
      double? price,
      String? currency,
      int? capacity,
      @JsonKey(name: 'isActive') bool? isActive,
      String? status,
      @JsonKey(name: 'instructorId') String? instructorId,
      String? requirements,
      @JsonKey(name: 'courseDetails') String? courseDetails,
      @JsonKey(name: 'courseLevel') String? courseLevel,
      @JsonKey(name: 'promotionalImages') List<String>? promotionalImages,
      @JsonKey(name: 'promotionalVideo') String? promotionalVideo,
      bool? certificate,
      String? notes,
      @JsonKey(name: 'subscriptionPolicy') String? subscriptionPolicy,
      @JsonKey(name: 'processingMechanism') String? processingMechanism,
      @JsonKey(name: 'submissionPolicy') String? submissionPolicy,
      @JsonKey(name: 'paymentDeadlineEnabled') bool? paymentDeadlineEnabled,
      @JsonKey(name: 'paymentDeadlineDays') int? paymentDeadlineDays,
      @JsonKey(name: 'paymentMethods') List<String>? paymentMethods,
      @JsonKey(name: 'subscriptionRules') String? subscriptionRules,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      Map<String, dynamic>? conference,
      Map<String, dynamic>? instructor,
      @JsonKey(name: 'speakers') List<Map<String, dynamic>>? speakers,
      @JsonKey(name: '_count') Map<String, dynamic>? count});
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conferenceId = null,
    Object? type = null,
    Object? category = freezed,
    Object? categoryId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? capacity = freezed,
    Object? isActive = freezed,
    Object? status = freezed,
    Object? instructorId = freezed,
    Object? requirements = freezed,
    Object? courseDetails = freezed,
    Object? courseLevel = freezed,
    Object? promotionalImages = freezed,
    Object? promotionalVideo = freezed,
    Object? certificate = freezed,
    Object? notes = freezed,
    Object? subscriptionPolicy = freezed,
    Object? processingMechanism = freezed,
    Object? submissionPolicy = freezed,
    Object? paymentDeadlineEnabled = freezed,
    Object? paymentDeadlineDays = freezed,
    Object? paymentMethods = freezed,
    Object? subscriptionRules = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? conference = freezed,
    Object? instructor = freezed,
    Object? speakers = freezed,
    Object? count = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorId: freezed == instructorId
          ? _value.instructorId
          : instructorId // ignore: cast_nullable_to_non_nullable
              as String?,
      requirements: freezed == requirements
          ? _value.requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as String?,
      courseDetails: freezed == courseDetails
          ? _value.courseDetails
          : courseDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      courseLevel: freezed == courseLevel
          ? _value.courseLevel
          : courseLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionalImages: freezed == promotionalImages
          ? _value.promotionalImages
          : promotionalImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      promotionalVideo: freezed == promotionalVideo
          ? _value.promotionalVideo
          : promotionalVideo // ignore: cast_nullable_to_non_nullable
              as String?,
      certificate: freezed == certificate
          ? _value.certificate
          : certificate // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionPolicy: freezed == subscriptionPolicy
          ? _value.subscriptionPolicy
          : subscriptionPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
      processingMechanism: freezed == processingMechanism
          ? _value.processingMechanism
          : processingMechanism // ignore: cast_nullable_to_non_nullable
              as String?,
      submissionPolicy: freezed == submissionPolicy
          ? _value.submissionPolicy
          : submissionPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDeadlineEnabled: freezed == paymentDeadlineEnabled
          ? _value.paymentDeadlineEnabled
          : paymentDeadlineEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      paymentDeadlineDays: freezed == paymentDeadlineDays
          ? _value.paymentDeadlineDays
          : paymentDeadlineDays // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentMethods: freezed == paymentMethods
          ? _value.paymentMethods
          : paymentMethods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      subscriptionRules: freezed == subscriptionRules
          ? _value.subscriptionRules
          : subscriptionRules // ignore: cast_nullable_to_non_nullable
              as String?,
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
      instructor: freezed == instructor
          ? _value.instructor
          : instructor // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      speakers: freezed == speakers
          ? _value.speakers
          : speakers // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conferenceId') String conferenceId,
      String type,
      String? category,
      @JsonKey(name: 'categoryId') String? categoryId,
      String title,
      String? description,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      double? duration,
      double? price,
      String? currency,
      int? capacity,
      @JsonKey(name: 'isActive') bool? isActive,
      String? status,
      @JsonKey(name: 'instructorId') String? instructorId,
      String? requirements,
      @JsonKey(name: 'courseDetails') String? courseDetails,
      @JsonKey(name: 'courseLevel') String? courseLevel,
      @JsonKey(name: 'promotionalImages') List<String>? promotionalImages,
      @JsonKey(name: 'promotionalVideo') String? promotionalVideo,
      bool? certificate,
      String? notes,
      @JsonKey(name: 'subscriptionPolicy') String? subscriptionPolicy,
      @JsonKey(name: 'processingMechanism') String? processingMechanism,
      @JsonKey(name: 'submissionPolicy') String? submissionPolicy,
      @JsonKey(name: 'paymentDeadlineEnabled') bool? paymentDeadlineEnabled,
      @JsonKey(name: 'paymentDeadlineDays') int? paymentDeadlineDays,
      @JsonKey(name: 'paymentMethods') List<String>? paymentMethods,
      @JsonKey(name: 'subscriptionRules') String? subscriptionRules,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      Map<String, dynamic>? conference,
      Map<String, dynamic>? instructor,
      @JsonKey(name: 'speakers') List<Map<String, dynamic>>? speakers,
      @JsonKey(name: '_count') Map<String, dynamic>? count});
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conferenceId = null,
    Object? type = null,
    Object? category = freezed,
    Object? categoryId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? capacity = freezed,
    Object? isActive = freezed,
    Object? status = freezed,
    Object? instructorId = freezed,
    Object? requirements = freezed,
    Object? courseDetails = freezed,
    Object? courseLevel = freezed,
    Object? promotionalImages = freezed,
    Object? promotionalVideo = freezed,
    Object? certificate = freezed,
    Object? notes = freezed,
    Object? subscriptionPolicy = freezed,
    Object? processingMechanism = freezed,
    Object? submissionPolicy = freezed,
    Object? paymentDeadlineEnabled = freezed,
    Object? paymentDeadlineDays = freezed,
    Object? paymentMethods = freezed,
    Object? subscriptionRules = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? conference = freezed,
    Object? instructor = freezed,
    Object? speakers = freezed,
    Object? count = freezed,
  }) {
    return _then(_$EventModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conferenceId: null == conferenceId
          ? _value.conferenceId
          : conferenceId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorId: freezed == instructorId
          ? _value.instructorId
          : instructorId // ignore: cast_nullable_to_non_nullable
              as String?,
      requirements: freezed == requirements
          ? _value.requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as String?,
      courseDetails: freezed == courseDetails
          ? _value.courseDetails
          : courseDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      courseLevel: freezed == courseLevel
          ? _value.courseLevel
          : courseLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      promotionalImages: freezed == promotionalImages
          ? _value._promotionalImages
          : promotionalImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      promotionalVideo: freezed == promotionalVideo
          ? _value.promotionalVideo
          : promotionalVideo // ignore: cast_nullable_to_non_nullable
              as String?,
      certificate: freezed == certificate
          ? _value.certificate
          : certificate // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionPolicy: freezed == subscriptionPolicy
          ? _value.subscriptionPolicy
          : subscriptionPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
      processingMechanism: freezed == processingMechanism
          ? _value.processingMechanism
          : processingMechanism // ignore: cast_nullable_to_non_nullable
              as String?,
      submissionPolicy: freezed == submissionPolicy
          ? _value.submissionPolicy
          : submissionPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDeadlineEnabled: freezed == paymentDeadlineEnabled
          ? _value.paymentDeadlineEnabled
          : paymentDeadlineEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      paymentDeadlineDays: freezed == paymentDeadlineDays
          ? _value.paymentDeadlineDays
          : paymentDeadlineDays // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentMethods: freezed == paymentMethods
          ? _value._paymentMethods
          : paymentMethods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      subscriptionRules: freezed == subscriptionRules
          ? _value.subscriptionRules
          : subscriptionRules // ignore: cast_nullable_to_non_nullable
              as String?,
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
      instructor: freezed == instructor
          ? _value._instructor
          : instructor // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      speakers: freezed == speakers
          ? _value._speakers
          : speakers // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      count: freezed == count
          ? _value._count
          : count // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  const _$EventModelImpl(
      {required this.id,
      @JsonKey(name: 'conferenceId') required this.conferenceId,
      required this.type,
      this.category,
      @JsonKey(name: 'categoryId') this.categoryId,
      required this.title,
      this.description,
      @JsonKey(name: 'startTime') required this.startTime,
      @JsonKey(name: 'endTime') required this.endTime,
      this.duration,
      this.price,
      this.currency,
      this.capacity,
      @JsonKey(name: 'isActive') this.isActive = true,
      this.status,
      @JsonKey(name: 'instructorId') this.instructorId,
      this.requirements,
      @JsonKey(name: 'courseDetails') this.courseDetails,
      @JsonKey(name: 'courseLevel') this.courseLevel,
      @JsonKey(name: 'promotionalImages') final List<String>? promotionalImages,
      @JsonKey(name: 'promotionalVideo') this.promotionalVideo,
      this.certificate = false,
      this.notes,
      @JsonKey(name: 'subscriptionPolicy') this.subscriptionPolicy,
      @JsonKey(name: 'processingMechanism') this.processingMechanism,
      @JsonKey(name: 'submissionPolicy') this.submissionPolicy,
      @JsonKey(name: 'paymentDeadlineEnabled')
      this.paymentDeadlineEnabled = false,
      @JsonKey(name: 'paymentDeadlineDays') this.paymentDeadlineDays,
      @JsonKey(name: 'paymentMethods') final List<String>? paymentMethods,
      @JsonKey(name: 'subscriptionRules') this.subscriptionRules,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      final Map<String, dynamic>? conference,
      final Map<String, dynamic>? instructor,
      @JsonKey(name: 'speakers') final List<Map<String, dynamic>>? speakers,
      @JsonKey(name: '_count') final Map<String, dynamic>? count})
      : _promotionalImages = promotionalImages,
        _paymentMethods = paymentMethods,
        _conference = conference,
        _instructor = instructor,
        _speakers = speakers,
        _count = count;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'conferenceId')
  final String conferenceId;
  @override
  final String type;
// 'COURSE' | 'WORKSHOP' | 'SEMINAR'
  @override
  final String? category;
  @override
  @JsonKey(name: 'categoryId')
  final String? categoryId;
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
  final double? duration;
  @override
  final double? price;
  @override
  final String? currency;
  @override
  final int? capacity;
  @override
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @override
  final String? status;
  @override
  @JsonKey(name: 'instructorId')
  final String? instructorId;
  @override
  final String? requirements;
  @override
  @JsonKey(name: 'courseDetails')
  final String? courseDetails;
  @override
  @JsonKey(name: 'courseLevel')
  final String? courseLevel;
  final List<String>? _promotionalImages;
  @override
  @JsonKey(name: 'promotionalImages')
  List<String>? get promotionalImages {
    final value = _promotionalImages;
    if (value == null) return null;
    if (_promotionalImages is EqualUnmodifiableListView)
      return _promotionalImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'promotionalVideo')
  final String? promotionalVideo;
  @override
  @JsonKey()
  final bool? certificate;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'subscriptionPolicy')
  final String? subscriptionPolicy;
  @override
  @JsonKey(name: 'processingMechanism')
  final String? processingMechanism;
  @override
  @JsonKey(name: 'submissionPolicy')
  final String? submissionPolicy;
  @override
  @JsonKey(name: 'paymentDeadlineEnabled')
  final bool? paymentDeadlineEnabled;
  @override
  @JsonKey(name: 'paymentDeadlineDays')
  final int? paymentDeadlineDays;
  final List<String>? _paymentMethods;
  @override
  @JsonKey(name: 'paymentMethods')
  List<String>? get paymentMethods {
    final value = _paymentMethods;
    if (value == null) return null;
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'subscriptionRules')
  final String? subscriptionRules;
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

  final Map<String, dynamic>? _instructor;
  @override
  Map<String, dynamic>? get instructor {
    final value = _instructor;
    if (value == null) return null;
    if (_instructor is EqualUnmodifiableMapView) return _instructor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Map<String, dynamic>>? _speakers;
  @override
  @JsonKey(name: 'speakers')
  List<Map<String, dynamic>>? get speakers {
    final value = _speakers;
    if (value == null) return null;
    if (_speakers is EqualUnmodifiableListView) return _speakers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
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
  String toString() {
    return 'EventModel(id: $id, conferenceId: $conferenceId, type: $type, category: $category, categoryId: $categoryId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, duration: $duration, price: $price, currency: $currency, capacity: $capacity, isActive: $isActive, status: $status, instructorId: $instructorId, requirements: $requirements, courseDetails: $courseDetails, courseLevel: $courseLevel, promotionalImages: $promotionalImages, promotionalVideo: $promotionalVideo, certificate: $certificate, notes: $notes, subscriptionPolicy: $subscriptionPolicy, processingMechanism: $processingMechanism, submissionPolicy: $submissionPolicy, paymentDeadlineEnabled: $paymentDeadlineEnabled, paymentDeadlineDays: $paymentDeadlineDays, paymentMethods: $paymentMethods, subscriptionRules: $subscriptionRules, createdAt: $createdAt, updatedAt: $updatedAt, conference: $conference, instructor: $instructor, speakers: $speakers, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conferenceId, conferenceId) ||
                other.conferenceId == conferenceId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.instructorId, instructorId) ||
                other.instructorId == instructorId) &&
            (identical(other.requirements, requirements) ||
                other.requirements == requirements) &&
            (identical(other.courseDetails, courseDetails) ||
                other.courseDetails == courseDetails) &&
            (identical(other.courseLevel, courseLevel) ||
                other.courseLevel == courseLevel) &&
            const DeepCollectionEquality()
                .equals(other._promotionalImages, _promotionalImages) &&
            (identical(other.promotionalVideo, promotionalVideo) ||
                other.promotionalVideo == promotionalVideo) &&
            (identical(other.certificate, certificate) ||
                other.certificate == certificate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.subscriptionPolicy, subscriptionPolicy) ||
                other.subscriptionPolicy == subscriptionPolicy) &&
            (identical(other.processingMechanism, processingMechanism) ||
                other.processingMechanism == processingMechanism) &&
            (identical(other.submissionPolicy, submissionPolicy) ||
                other.submissionPolicy == submissionPolicy) &&
            (identical(other.paymentDeadlineEnabled, paymentDeadlineEnabled) ||
                other.paymentDeadlineEnabled == paymentDeadlineEnabled) &&
            (identical(other.paymentDeadlineDays, paymentDeadlineDays) ||
                other.paymentDeadlineDays == paymentDeadlineDays) &&
            const DeepCollectionEquality()
                .equals(other._paymentMethods, _paymentMethods) &&
            (identical(other.subscriptionRules, subscriptionRules) ||
                other.subscriptionRules == subscriptionRules) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._conference, _conference) &&
            const DeepCollectionEquality()
                .equals(other._instructor, _instructor) &&
            const DeepCollectionEquality().equals(other._speakers, _speakers) &&
            const DeepCollectionEquality().equals(other._count, _count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        conferenceId,
        type,
        category,
        categoryId,
        title,
        description,
        startTime,
        endTime,
        duration,
        price,
        currency,
        capacity,
        isActive,
        status,
        instructorId,
        requirements,
        courseDetails,
        courseLevel,
        const DeepCollectionEquality().hash(_promotionalImages),
        promotionalVideo,
        certificate,
        notes,
        subscriptionPolicy,
        processingMechanism,
        submissionPolicy,
        paymentDeadlineEnabled,
        paymentDeadlineDays,
        const DeepCollectionEquality().hash(_paymentMethods),
        subscriptionRules,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_conference),
        const DeepCollectionEquality().hash(_instructor),
        const DeepCollectionEquality().hash(_speakers),
        const DeepCollectionEquality().hash(_count)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel implements EventModel {
  const factory _EventModel(
      {required final String id,
      @JsonKey(name: 'conferenceId') required final String conferenceId,
      required final String type,
      final String? category,
      @JsonKey(name: 'categoryId') final String? categoryId,
      required final String title,
      final String? description,
      @JsonKey(name: 'startTime') required final DateTime startTime,
      @JsonKey(name: 'endTime') required final DateTime endTime,
      final double? duration,
      final double? price,
      final String? currency,
      final int? capacity,
      @JsonKey(name: 'isActive') final bool? isActive,
      final String? status,
      @JsonKey(name: 'instructorId') final String? instructorId,
      final String? requirements,
      @JsonKey(name: 'courseDetails') final String? courseDetails,
      @JsonKey(name: 'courseLevel') final String? courseLevel,
      @JsonKey(name: 'promotionalImages') final List<String>? promotionalImages,
      @JsonKey(name: 'promotionalVideo') final String? promotionalVideo,
      final bool? certificate,
      final String? notes,
      @JsonKey(name: 'subscriptionPolicy') final String? subscriptionPolicy,
      @JsonKey(name: 'processingMechanism') final String? processingMechanism,
      @JsonKey(name: 'submissionPolicy') final String? submissionPolicy,
      @JsonKey(name: 'paymentDeadlineEnabled')
      final bool? paymentDeadlineEnabled,
      @JsonKey(name: 'paymentDeadlineDays') final int? paymentDeadlineDays,
      @JsonKey(name: 'paymentMethods') final List<String>? paymentMethods,
      @JsonKey(name: 'subscriptionRules') final String? subscriptionRules,
      @JsonKey(name: 'createdAt') required final DateTime createdAt,
      @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
      final Map<String, dynamic>? conference,
      final Map<String, dynamic>? instructor,
      @JsonKey(name: 'speakers') final List<Map<String, dynamic>>? speakers,
      @JsonKey(name: '_count')
      final Map<String, dynamic>? count}) = _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'conferenceId')
  String get conferenceId;
  @override
  String get type;
  @override // 'COURSE' | 'WORKSHOP' | 'SEMINAR'
  String? get category;
  @override
  @JsonKey(name: 'categoryId')
  String? get categoryId;
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
  double? get duration;
  @override
  double? get price;
  @override
  String? get currency;
  @override
  int? get capacity;
  @override
  @JsonKey(name: 'isActive')
  bool? get isActive;
  @override
  String? get status;
  @override
  @JsonKey(name: 'instructorId')
  String? get instructorId;
  @override
  String? get requirements;
  @override
  @JsonKey(name: 'courseDetails')
  String? get courseDetails;
  @override
  @JsonKey(name: 'courseLevel')
  String? get courseLevel;
  @override
  @JsonKey(name: 'promotionalImages')
  List<String>? get promotionalImages;
  @override
  @JsonKey(name: 'promotionalVideo')
  String? get promotionalVideo;
  @override
  bool? get certificate;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'subscriptionPolicy')
  String? get subscriptionPolicy;
  @override
  @JsonKey(name: 'processingMechanism')
  String? get processingMechanism;
  @override
  @JsonKey(name: 'submissionPolicy')
  String? get submissionPolicy;
  @override
  @JsonKey(name: 'paymentDeadlineEnabled')
  bool? get paymentDeadlineEnabled;
  @override
  @JsonKey(name: 'paymentDeadlineDays')
  int? get paymentDeadlineDays;
  @override
  @JsonKey(name: 'paymentMethods')
  List<String>? get paymentMethods;
  @override
  @JsonKey(name: 'subscriptionRules')
  String? get subscriptionRules;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override // Relations
  Map<String, dynamic>? get conference;
  @override
  Map<String, dynamic>? get instructor;
  @override
  @JsonKey(name: 'speakers')
  List<Map<String, dynamic>>? get speakers;
  @override
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count;
  @override
  @JsonKey(ignore: true)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
