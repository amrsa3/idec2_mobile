// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegistrationState {
  RegistrationSettingsModel? get settings => throw _privateConstructorUsedError;
  RegistrationStatusResponse? get status => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  AppError? get error => throw _privateConstructorUsedError;
  DateTime? get lastUpdated =>
      throw _privateConstructorUsedError; // إضافة الخصائص المفقودة
  List<OtpChannelModel>? get availableChannels =>
      throw _privateConstructorUsedError;
  OtpChannelModel? get selectedChannel => throw _privateConstructorUsedError;
  OtpChannelModel? get defaultChannel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationStateCopyWith<RegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStateCopyWith<$Res> {
  factory $RegistrationStateCopyWith(
          RegistrationState value, $Res Function(RegistrationState) then) =
      _$RegistrationStateCopyWithImpl<$Res, RegistrationState>;
  @useResult
  $Res call(
      {RegistrationSettingsModel? settings,
      RegistrationStatusResponse? status,
      bool isLoading,
      AppError? error,
      DateTime? lastUpdated,
      List<OtpChannelModel>? availableChannels,
      OtpChannelModel? selectedChannel,
      OtpChannelModel? defaultChannel});

  $RegistrationSettingsModelCopyWith<$Res>? get settings;
  $RegistrationStatusResponseCopyWith<$Res>? get status;
  $OtpChannelModelCopyWith<$Res>? get selectedChannel;
  $OtpChannelModelCopyWith<$Res>? get defaultChannel;
}

/// @nodoc
class _$RegistrationStateCopyWithImpl<$Res, $Val extends RegistrationState>
    implements $RegistrationStateCopyWith<$Res> {
  _$RegistrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = freezed,
    Object? status = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? lastUpdated = freezed,
    Object? availableChannels = freezed,
    Object? selectedChannel = freezed,
    Object? defaultChannel = freezed,
  }) {
    return _then(_value.copyWith(
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as RegistrationSettingsModel?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatusResponse?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppError?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableChannels: freezed == availableChannels
          ? _value.availableChannels
          : availableChannels // ignore: cast_nullable_to_non_nullable
              as List<OtpChannelModel>?,
      selectedChannel: freezed == selectedChannel
          ? _value.selectedChannel
          : selectedChannel // ignore: cast_nullable_to_non_nullable
              as OtpChannelModel?,
      defaultChannel: freezed == defaultChannel
          ? _value.defaultChannel
          : defaultChannel // ignore: cast_nullable_to_non_nullable
              as OtpChannelModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RegistrationSettingsModelCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $RegistrationSettingsModelCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RegistrationStatusResponseCopyWith<$Res>? get status {
    if (_value.status == null) {
      return null;
    }

    return $RegistrationStatusResponseCopyWith<$Res>(_value.status!, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OtpChannelModelCopyWith<$Res>? get selectedChannel {
    if (_value.selectedChannel == null) {
      return null;
    }

    return $OtpChannelModelCopyWith<$Res>(_value.selectedChannel!, (value) {
      return _then(_value.copyWith(selectedChannel: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OtpChannelModelCopyWith<$Res>? get defaultChannel {
    if (_value.defaultChannel == null) {
      return null;
    }

    return $OtpChannelModelCopyWith<$Res>(_value.defaultChannel!, (value) {
      return _then(_value.copyWith(defaultChannel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationStateImplCopyWith<$Res>
    implements $RegistrationStateCopyWith<$Res> {
  factory _$$RegistrationStateImplCopyWith(_$RegistrationStateImpl value,
          $Res Function(_$RegistrationStateImpl) then) =
      __$$RegistrationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RegistrationSettingsModel? settings,
      RegistrationStatusResponse? status,
      bool isLoading,
      AppError? error,
      DateTime? lastUpdated,
      List<OtpChannelModel>? availableChannels,
      OtpChannelModel? selectedChannel,
      OtpChannelModel? defaultChannel});

  @override
  $RegistrationSettingsModelCopyWith<$Res>? get settings;
  @override
  $RegistrationStatusResponseCopyWith<$Res>? get status;
  @override
  $OtpChannelModelCopyWith<$Res>? get selectedChannel;
  @override
  $OtpChannelModelCopyWith<$Res>? get defaultChannel;
}

/// @nodoc
class __$$RegistrationStateImplCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$RegistrationStateImpl>
    implements _$$RegistrationStateImplCopyWith<$Res> {
  __$$RegistrationStateImplCopyWithImpl(_$RegistrationStateImpl _value,
      $Res Function(_$RegistrationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = freezed,
    Object? status = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? lastUpdated = freezed,
    Object? availableChannels = freezed,
    Object? selectedChannel = freezed,
    Object? defaultChannel = freezed,
  }) {
    return _then(_$RegistrationStateImpl(
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as RegistrationSettingsModel?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatusResponse?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppError?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableChannels: freezed == availableChannels
          ? _value._availableChannels
          : availableChannels // ignore: cast_nullable_to_non_nullable
              as List<OtpChannelModel>?,
      selectedChannel: freezed == selectedChannel
          ? _value.selectedChannel
          : selectedChannel // ignore: cast_nullable_to_non_nullable
              as OtpChannelModel?,
      defaultChannel: freezed == defaultChannel
          ? _value.defaultChannel
          : defaultChannel // ignore: cast_nullable_to_non_nullable
              as OtpChannelModel?,
    ));
  }
}

/// @nodoc

class _$RegistrationStateImpl extends _RegistrationState
    with DiagnosticableTreeMixin {
  const _$RegistrationStateImpl(
      {this.settings,
      this.status,
      this.isLoading = false,
      this.error,
      this.lastUpdated,
      final List<OtpChannelModel>? availableChannels,
      this.selectedChannel,
      this.defaultChannel})
      : _availableChannels = availableChannels,
        super._();

  @override
  final RegistrationSettingsModel? settings;
  @override
  final RegistrationStatusResponse? status;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final AppError? error;
  @override
  final DateTime? lastUpdated;
// إضافة الخصائص المفقودة
  final List<OtpChannelModel>? _availableChannels;
// إضافة الخصائص المفقودة
  @override
  List<OtpChannelModel>? get availableChannels {
    final value = _availableChannels;
    if (value == null) return null;
    if (_availableChannels is EqualUnmodifiableListView)
      return _availableChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final OtpChannelModel? selectedChannel;
  @override
  final OtpChannelModel? defaultChannel;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegistrationState(settings: $settings, status: $status, isLoading: $isLoading, error: $error, lastUpdated: $lastUpdated, availableChannels: $availableChannels, selectedChannel: $selectedChannel, defaultChannel: $defaultChannel)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegistrationState'))
      ..add(DiagnosticsProperty('settings', settings))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('lastUpdated', lastUpdated))
      ..add(DiagnosticsProperty('availableChannels', availableChannels))
      ..add(DiagnosticsProperty('selectedChannel', selectedChannel))
      ..add(DiagnosticsProperty('defaultChannel', defaultChannel));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationStateImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality()
                .equals(other._availableChannels, _availableChannels) &&
            (identical(other.selectedChannel, selectedChannel) ||
                other.selectedChannel == selectedChannel) &&
            (identical(other.defaultChannel, defaultChannel) ||
                other.defaultChannel == defaultChannel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      settings,
      status,
      isLoading,
      error,
      lastUpdated,
      const DeepCollectionEquality().hash(_availableChannels),
      selectedChannel,
      defaultChannel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationStateImplCopyWith<_$RegistrationStateImpl> get copyWith =>
      __$$RegistrationStateImplCopyWithImpl<_$RegistrationStateImpl>(
          this, _$identity);
}

abstract class _RegistrationState extends RegistrationState {
  const factory _RegistrationState(
      {final RegistrationSettingsModel? settings,
      final RegistrationStatusResponse? status,
      final bool isLoading,
      final AppError? error,
      final DateTime? lastUpdated,
      final List<OtpChannelModel>? availableChannels,
      final OtpChannelModel? selectedChannel,
      final OtpChannelModel? defaultChannel}) = _$RegistrationStateImpl;
  const _RegistrationState._() : super._();

  @override
  RegistrationSettingsModel? get settings;
  @override
  RegistrationStatusResponse? get status;
  @override
  bool get isLoading;
  @override
  AppError? get error;
  @override
  DateTime? get lastUpdated;
  @override // إضافة الخصائص المفقودة
  List<OtpChannelModel>? get availableChannels;
  @override
  OtpChannelModel? get selectedChannel;
  @override
  OtpChannelModel? get defaultChannel;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationStateImplCopyWith<_$RegistrationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
