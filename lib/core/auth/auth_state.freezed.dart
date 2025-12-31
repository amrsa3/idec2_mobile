// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthInitialImplCopyWith<$Res> {
  factory _$$AuthInitialImplCopyWith(
          _$AuthInitialImpl value, $Res Function(_$AuthInitialImpl) then) =
      __$$AuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthInitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthInitialImpl>
    implements _$$AuthInitialImplCopyWith<$Res> {
  __$$AuthInitialImplCopyWithImpl(
      _$AuthInitialImpl _value, $Res Function(_$AuthInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthInitialImpl implements AuthInitial {
  const _$AuthInitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AuthInitial implements AuthState {
  const factory AuthInitial() = _$AuthInitialImpl;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
          _$AuthLoadingImpl value, $Res Function(_$AuthLoadingImpl) then) =
      __$$AuthLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
      _$AuthLoadingImpl _value, $Res Function(_$AuthLoadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$AuthLoadingImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl({this.message});

  /// رسالة اختيارية لعرضها أثناء التحميل
  @override
  final String? message;

  @override
  String toString() {
    return 'AuthState.loading(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLoadingImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      __$$AuthLoadingImplCopyWithImpl<_$AuthLoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return loading(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return loading?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AuthLoading implements AuthState {
  const factory AuthLoading({final String? message}) = _$AuthLoadingImpl;

  /// رسالة اختيارية لعرضها أثناء التحميل
  String? get message;
  @JsonKey(ignore: true)
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAuthenticatedImplCopyWith<$Res> {
  factory _$$AuthAuthenticatedImplCopyWith(_$AuthAuthenticatedImpl value,
          $Res Function(_$AuthAuthenticatedImpl) then) =
      __$$AuthAuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, bool isRefreshed});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthAuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAuthenticatedImpl>
    implements _$$AuthAuthenticatedImplCopyWith<$Res> {
  __$$AuthAuthenticatedImplCopyWithImpl(_$AuthAuthenticatedImpl _value,
      $Res Function(_$AuthAuthenticatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? isRefreshed = null,
  }) {
    return _then(_$AuthAuthenticatedImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      isRefreshed: null == isRefreshed
          ? _value.isRefreshed
          : isRefreshed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthAuthenticatedImpl implements AuthAuthenticated {
  const _$AuthAuthenticatedImpl({required this.user, this.isRefreshed = false});

  /// بيانات المستخدم
  @override
  final UserModel user;

  /// هل تم تحديث البيانات حديثاً
  @override
  @JsonKey()
  final bool isRefreshed;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user, isRefreshed: $isRefreshed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAuthenticatedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isRefreshed, isRefreshed) ||
                other.isRefreshed == isRefreshed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, isRefreshed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      __$$AuthAuthenticatedImplCopyWithImpl<_$AuthAuthenticatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return authenticated(user, isRefreshed);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return authenticated?.call(user, isRefreshed);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user, isRefreshed);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthAuthenticated implements AuthState {
  const factory AuthAuthenticated(
      {required final UserModel user,
      final bool isRefreshed}) = _$AuthAuthenticatedImpl;

  /// بيانات المستخدم
  UserModel get user;

  /// هل تم تحديث البيانات حديثاً
  bool get isRefreshed;
  @JsonKey(ignore: true)
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUnauthenticatedImplCopyWith<$Res> {
  factory _$$AuthUnauthenticatedImplCopyWith(_$AuthUnauthenticatedImpl value,
          $Res Function(_$AuthUnauthenticatedImpl) then) =
      __$$AuthUnauthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$AuthUnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnauthenticatedImpl>
    implements _$$AuthUnauthenticatedImplCopyWith<$Res> {
  __$$AuthUnauthenticatedImplCopyWithImpl(_$AuthUnauthenticatedImpl _value,
      $Res Function(_$AuthUnauthenticatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$AuthUnauthenticatedImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthUnauthenticatedImpl implements AuthUnauthenticated {
  const _$AuthUnauthenticatedImpl({this.message});

  /// رسالة اختيارية (مثلاً: "تم تسجيل الخروج بنجاح")
  @override
  final String? message;

  @override
  String toString() {
    return 'AuthState.unauthenticated(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnauthenticatedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUnauthenticatedImplCopyWith<_$AuthUnauthenticatedImpl> get copyWith =>
      __$$AuthUnauthenticatedImplCopyWithImpl<_$AuthUnauthenticatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return unauthenticated(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return unauthenticated?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthUnauthenticated implements AuthState {
  const factory AuthUnauthenticated({final String? message}) =
      _$AuthUnauthenticatedImpl;

  /// رسالة اختيارية (مثلاً: "تم تسجيل الخروج بنجاح")
  String? get message;
  @JsonKey(ignore: true)
  _$$AuthUnauthenticatedImplCopyWith<_$AuthUnauthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthPhoneNotVerifiedImplCopyWith<$Res> {
  factory _$$AuthPhoneNotVerifiedImplCopyWith(_$AuthPhoneNotVerifiedImpl value,
          $Res Function(_$AuthPhoneNotVerifiedImpl) then) =
      __$$AuthPhoneNotVerifiedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phone, String? message, bool otpSent});
}

/// @nodoc
class __$$AuthPhoneNotVerifiedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthPhoneNotVerifiedImpl>
    implements _$$AuthPhoneNotVerifiedImplCopyWith<$Res> {
  __$$AuthPhoneNotVerifiedImplCopyWithImpl(_$AuthPhoneNotVerifiedImpl _value,
      $Res Function(_$AuthPhoneNotVerifiedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? message = freezed,
    Object? otpSent = null,
  }) {
    return _then(_$AuthPhoneNotVerifiedImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      otpSent: null == otpSent
          ? _value.otpSent
          : otpSent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthPhoneNotVerifiedImpl implements AuthPhoneNotVerified {
  const _$AuthPhoneNotVerifiedImpl(
      {required this.phone, this.message, this.otpSent = false});

  /// رقم الهاتف الذي يحتاج التفعيل
  @override
  final String phone;

  /// رسالة للمستخدم
  @override
  final String? message;

  /// هل تم إرسال OTP بالفعل
  @override
  @JsonKey()
  final bool otpSent;

  @override
  String toString() {
    return 'AuthState.phoneNotVerified(phone: $phone, message: $message, otpSent: $otpSent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPhoneNotVerifiedImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.otpSent, otpSent) || other.otpSent == otpSent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phone, message, otpSent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthPhoneNotVerifiedImplCopyWith<_$AuthPhoneNotVerifiedImpl>
      get copyWith =>
          __$$AuthPhoneNotVerifiedImplCopyWithImpl<_$AuthPhoneNotVerifiedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return phoneNotVerified(phone, message, otpSent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return phoneNotVerified?.call(phone, message, otpSent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (phoneNotVerified != null) {
      return phoneNotVerified(phone, message, otpSent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return phoneNotVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return phoneNotVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (phoneNotVerified != null) {
      return phoneNotVerified(this);
    }
    return orElse();
  }
}

abstract class AuthPhoneNotVerified implements AuthState {
  const factory AuthPhoneNotVerified(
      {required final String phone,
      final String? message,
      final bool otpSent}) = _$AuthPhoneNotVerifiedImpl;

  /// رقم الهاتف الذي يحتاج التفعيل
  String get phone;

  /// رسالة للمستخدم
  String? get message;

  /// هل تم إرسال OTP بالفعل
  bool get otpSent;
  @JsonKey(ignore: true)
  _$$AuthPhoneNotVerifiedImplCopyWith<_$AuthPhoneNotVerifiedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
          _$AuthErrorImpl value, $Res Function(_$AuthErrorImpl) then) =
      __$$AuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code, bool canRetry});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
      _$AuthErrorImpl _value, $Res Function(_$AuthErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
    Object? canRetry = null,
  }) {
    return _then(_$AuthErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      canRetry: null == canRetry
          ? _value.canRetry
          : canRetry // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl(
      {required this.message, this.code, this.canRetry = true});

  /// رسالة الخطأ
  @override
  final String message;

  /// كود الخطأ (اختياري)
  @override
  final String? code;

  /// هل يمكن إعادة المحاولة
  @override
  @JsonKey()
  final bool canRetry;

  @override
  String toString() {
    return 'AuthState.error(message: $message, code: $code, canRetry: $canRetry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code, canRetry);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return error(message, code, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return error?.call(message, code, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, code, canRetry);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AuthState {
  const factory AuthError(
      {required final String message,
      final String? code,
      final bool canRetry}) = _$AuthErrorImpl;

  /// رسالة الخطأ
  String get message;

  /// كود الخطأ (اختياري)
  String? get code;

  /// هل يمكن إعادة المحاولة
  bool get canRetry;
  @JsonKey(ignore: true)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthSessionExpiredImplCopyWith<$Res> {
  factory _$$AuthSessionExpiredImplCopyWith(_$AuthSessionExpiredImpl value,
          $Res Function(_$AuthSessionExpiredImpl) then) =
      __$$AuthSessionExpiredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? reason, bool shouldRedirectToLogin});
}

/// @nodoc
class __$$AuthSessionExpiredImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthSessionExpiredImpl>
    implements _$$AuthSessionExpiredImplCopyWith<$Res> {
  __$$AuthSessionExpiredImplCopyWithImpl(_$AuthSessionExpiredImpl _value,
      $Res Function(_$AuthSessionExpiredImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = freezed,
    Object? shouldRedirectToLogin = null,
  }) {
    return _then(_$AuthSessionExpiredImpl(
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      shouldRedirectToLogin: null == shouldRedirectToLogin
          ? _value.shouldRedirectToLogin
          : shouldRedirectToLogin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthSessionExpiredImpl implements AuthSessionExpired {
  const _$AuthSessionExpiredImpl(
      {this.reason, this.shouldRedirectToLogin = true});

  /// سبب انتهاء الجلسة
  @override
  final String? reason;

  /// هل يجب التوجيه لصفحة تسجيل الدخول
  @override
  @JsonKey()
  final bool shouldRedirectToLogin;

  @override
  String toString() {
    return 'AuthState.sessionExpired(reason: $reason, shouldRedirectToLogin: $shouldRedirectToLogin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionExpiredImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shouldRedirectToLogin, shouldRedirectToLogin) ||
                other.shouldRedirectToLogin == shouldRedirectToLogin));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, shouldRedirectToLogin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionExpiredImplCopyWith<_$AuthSessionExpiredImpl> get copyWith =>
      __$$AuthSessionExpiredImplCopyWithImpl<_$AuthSessionExpiredImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(UserModel user, bool isRefreshed) authenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String phone, String? message, bool otpSent)
        phoneNotVerified,
    required TResult Function(String message, String? code, bool canRetry)
        error,
    required TResult Function(String? reason, bool shouldRedirectToLogin)
        sessionExpired,
  }) {
    return sessionExpired(reason, shouldRedirectToLogin);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(UserModel user, bool isRefreshed)? authenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult? Function(String message, String? code, bool canRetry)? error,
    TResult? Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
  }) {
    return sessionExpired?.call(reason, shouldRedirectToLogin);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(UserModel user, bool isRefreshed)? authenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String phone, String? message, bool otpSent)?
        phoneNotVerified,
    TResult Function(String message, String? code, bool canRetry)? error,
    TResult Function(String? reason, bool shouldRedirectToLogin)?
        sessionExpired,
    required TResult orElse(),
  }) {
    if (sessionExpired != null) {
      return sessionExpired(reason, shouldRedirectToLogin);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthPhoneNotVerified value) phoneNotVerified,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthSessionExpired value) sessionExpired,
  }) {
    return sessionExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthSessionExpired value)? sessionExpired,
  }) {
    return sessionExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthPhoneNotVerified value)? phoneNotVerified,
    TResult Function(AuthError value)? error,
    TResult Function(AuthSessionExpired value)? sessionExpired,
    required TResult orElse(),
  }) {
    if (sessionExpired != null) {
      return sessionExpired(this);
    }
    return orElse();
  }
}

abstract class AuthSessionExpired implements AuthState {
  const factory AuthSessionExpired(
      {final String? reason,
      final bool shouldRedirectToLogin}) = _$AuthSessionExpiredImpl;

  /// سبب انتهاء الجلسة
  String? get reason;

  /// هل يجب التوجيه لصفحة تسجيل الدخول
  bool get shouldRedirectToLogin;
  @JsonKey(ignore: true)
  _$$AuthSessionExpiredImplCopyWith<_$AuthSessionExpiredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
