// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthResult {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModel? user, String message) success,
    required TResult Function(String message) error,
    required TResult Function(String message) loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel? user, String message)? success,
    TResult? Function(String message)? error,
    TResult? Function(String message)? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel? user, String message)? success,
    TResult Function(String message)? error,
    TResult Function(String message)? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthSuccess value) success,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthLoading value) loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthSuccess value)? success,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthLoading value)? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthSuccess value)? success,
    TResult Function(AuthError value)? error,
    TResult Function(AuthLoading value)? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthResultCopyWith<AuthResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResultCopyWith<$Res> {
  factory $AuthResultCopyWith(
          AuthResult value, $Res Function(AuthResult) then) =
      _$AuthResultCopyWithImpl<$Res, AuthResult>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AuthResultCopyWithImpl<$Res, $Val extends AuthResult>
    implements $AuthResultCopyWith<$Res> {
  _$AuthResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthSuccessImplCopyWith<$Res>
    implements $AuthResultCopyWith<$Res> {
  factory _$$AuthSuccessImplCopyWith(
          _$AuthSuccessImpl value, $Res Function(_$AuthSuccessImpl) then) =
      __$$AuthSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel? user, String message});

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthSuccessImplCopyWithImpl<$Res>
    extends _$AuthResultCopyWithImpl<$Res, _$AuthSuccessImpl>
    implements _$$AuthSuccessImplCopyWith<$Res> {
  __$$AuthSuccessImplCopyWithImpl(
      _$AuthSuccessImpl _value, $Res Function(_$AuthSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? message = null,
  }) {
    return _then(_$AuthSuccessImpl(
      freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthSuccessImpl implements AuthSuccess {
  const _$AuthSuccessImpl(this.user, this.message);

  @override
  final UserModel? user;
  @override
  final String message;

  @override
  String toString() {
    return 'AuthResult.success(user: $user, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSuccessImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSuccessImplCopyWith<_$AuthSuccessImpl> get copyWith =>
      __$$AuthSuccessImplCopyWithImpl<_$AuthSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModel? user, String message) success,
    required TResult Function(String message) error,
    required TResult Function(String message) loading,
  }) {
    return success(user, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel? user, String message)? success,
    TResult? Function(String message)? error,
    TResult? Function(String message)? loading,
  }) {
    return success?.call(user, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel? user, String message)? success,
    TResult Function(String message)? error,
    TResult Function(String message)? loading,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(user, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthSuccess value) success,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthLoading value) loading,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthSuccess value)? success,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthLoading value)? loading,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthSuccess value)? success,
    TResult Function(AuthError value)? error,
    TResult Function(AuthLoading value)? loading,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class AuthSuccess implements AuthResult {
  const factory AuthSuccess(final UserModel? user, final String message) =
      _$AuthSuccessImpl;

  UserModel? get user;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$AuthSuccessImplCopyWith<_$AuthSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res>
    implements $AuthResultCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
          _$AuthErrorImpl value, $Res Function(_$AuthErrorImpl) then) =
      __$$AuthErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthResultCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
      _$AuthErrorImpl _value, $Res Function(_$AuthErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AuthErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthResult.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModel? user, String message) success,
    required TResult Function(String message) error,
    required TResult Function(String message) loading,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel? user, String message)? success,
    TResult? Function(String message)? error,
    TResult? Function(String message)? loading,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel? user, String message)? success,
    TResult Function(String message)? error,
    TResult Function(String message)? loading,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthSuccess value) success,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthLoading value) loading,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthSuccess value)? success,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthLoading value)? loading,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthSuccess value)? success,
    TResult Function(AuthError value)? error,
    TResult Function(AuthLoading value)? loading,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AuthResult {
  const factory AuthError(final String message) = _$AuthErrorImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res>
    implements $AuthResultCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
          _$AuthLoadingImpl value, $Res Function(_$AuthLoadingImpl) then) =
      __$$AuthLoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthResultCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
      _$AuthLoadingImpl _value, $Res Function(_$AuthLoadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AuthLoadingImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthResult.loading(message: $message)';
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
    required TResult Function(UserModel? user, String message) success,
    required TResult Function(String message) error,
    required TResult Function(String message) loading,
  }) {
    return loading(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel? user, String message)? success,
    TResult? Function(String message)? error,
    TResult? Function(String message)? loading,
  }) {
    return loading?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel? user, String message)? success,
    TResult Function(String message)? error,
    TResult Function(String message)? loading,
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
    required TResult Function(AuthSuccess value) success,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthLoading value) loading,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthSuccess value)? success,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthLoading value)? loading,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthSuccess value)? success,
    TResult Function(AuthError value)? error,
    TResult Function(AuthLoading value)? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AuthLoading implements AuthResult {
  const factory AuthLoading(final String message) = _$AuthLoadingImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
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
abstract class _$$InitialStateImplCopyWith<$Res> {
  factory _$$InitialStateImplCopyWith(
          _$InitialStateImpl value, $Res Function(_$InitialStateImpl) then) =
      __$$InitialStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$InitialStateImpl>
    implements _$$InitialStateImplCopyWith<$Res> {
  __$$InitialStateImplCopyWithImpl(
      _$InitialStateImpl _value, $Res Function(_$InitialStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialStateImpl implements InitialState {
  const _$InitialStateImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
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
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialState implements AuthState {
  const factory InitialState() = _$InitialStateImpl;
}

/// @nodoc
abstract class _$$LoadingStateImplCopyWith<$Res> {
  factory _$$LoadingStateImplCopyWith(
          _$LoadingStateImpl value, $Res Function(_$LoadingStateImpl) then) =
      __$$LoadingStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$LoadingStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$LoadingStateImpl>
    implements _$$LoadingStateImplCopyWith<$Res> {
  __$$LoadingStateImplCopyWithImpl(
      _$LoadingStateImpl _value, $Res Function(_$LoadingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$LoadingStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadingStateImpl implements LoadingState {
  const _$LoadingStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.loading(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingStateImplCopyWith<_$LoadingStateImpl> get copyWith =>
      __$$LoadingStateImplCopyWithImpl<_$LoadingStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) {
    return loading(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) {
    return loading?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
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
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadingState implements AuthState {
  const factory LoadingState(final String message) = _$LoadingStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$LoadingStateImplCopyWith<_$LoadingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthenticatedStateImplCopyWith<$Res> {
  factory _$$AuthenticatedStateImplCopyWith(_$AuthenticatedStateImpl value,
          $Res Function(_$AuthenticatedStateImpl) then) =
      __$$AuthenticatedStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthenticatedStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedStateImpl>
    implements _$$AuthenticatedStateImplCopyWith<$Res> {
  __$$AuthenticatedStateImplCopyWithImpl(_$AuthenticatedStateImpl _value,
      $Res Function(_$AuthenticatedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticatedStateImpl(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
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

class _$AuthenticatedStateImpl implements AuthenticatedState {
  const _$AuthenticatedStateImpl(this.user);

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedStateImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedStateImplCopyWith<_$AuthenticatedStateImpl> get copyWith =>
      __$$AuthenticatedStateImplCopyWithImpl<_$AuthenticatedStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) {
    return authenticated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) {
    return authenticated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthenticatedState implements AuthState {
  const factory AuthenticatedState(final UserModel user) =
      _$AuthenticatedStateImpl;

  UserModel get user;
  @JsonKey(ignore: true)
  _$$AuthenticatedStateImplCopyWith<_$AuthenticatedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthenticatedStateImplCopyWith<$Res> {
  factory _$$UnauthenticatedStateImplCopyWith(_$UnauthenticatedStateImpl value,
          $Res Function(_$UnauthenticatedStateImpl) then) =
      __$$UnauthenticatedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthenticatedStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UnauthenticatedStateImpl>
    implements _$$UnauthenticatedStateImplCopyWith<$Res> {
  __$$UnauthenticatedStateImplCopyWithImpl(_$UnauthenticatedStateImpl _value,
      $Res Function(_$UnauthenticatedStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UnauthenticatedStateImpl implements UnauthenticatedState {
  const _$UnauthenticatedStateImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthenticatedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class UnauthenticatedState implements AuthState {
  const factory UnauthenticatedState() = _$UnauthenticatedStateImpl;
}

/// @nodoc
abstract class _$$RegisteredStateImplCopyWith<$Res> {
  factory _$$RegisteredStateImplCopyWith(_$RegisteredStateImpl value,
          $Res Function(_$RegisteredStateImpl) then) =
      __$$RegisteredStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RegisteredStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$RegisteredStateImpl>
    implements _$$RegisteredStateImplCopyWith<$Res> {
  __$$RegisteredStateImplCopyWithImpl(
      _$RegisteredStateImpl _value, $Res Function(_$RegisteredStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RegisteredStateImpl implements RegisteredState {
  const _$RegisteredStateImpl();

  @override
  String toString() {
    return 'AuthState.registered()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RegisteredStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) {
    return registered();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) {
    return registered?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (registered != null) {
      return registered();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) {
    return registered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) {
    return registered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (registered != null) {
      return registered(this);
    }
    return orElse();
  }
}

abstract class RegisteredState implements AuthState {
  const factory RegisteredState() = _$RegisteredStateImpl;
}

/// @nodoc
abstract class _$$ErrorStateImplCopyWith<$Res> {
  factory _$$ErrorStateImplCopyWith(
          _$ErrorStateImpl value, $Res Function(_$ErrorStateImpl) then) =
      __$$ErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorStateImpl>
    implements _$$ErrorStateImplCopyWith<$Res> {
  __$$ErrorStateImplCopyWithImpl(
      _$ErrorStateImpl _value, $Res Function(_$ErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorStateImpl implements ErrorState {
  const _$ErrorStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorStateImplCopyWith<_$ErrorStateImpl> get copyWith =>
      __$$ErrorStateImplCopyWithImpl<_$ErrorStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) loading,
    required TResult Function(UserModel user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() registered,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? loading,
    TResult? Function(UserModel user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function()? registered,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? loading,
    TResult Function(UserModel user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? registered,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialState value) initial,
    required TResult Function(LoadingState value) loading,
    required TResult Function(AuthenticatedState value) authenticated,
    required TResult Function(UnauthenticatedState value) unauthenticated,
    required TResult Function(RegisteredState value) registered,
    required TResult Function(ErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialState value)? initial,
    TResult? Function(LoadingState value)? loading,
    TResult? Function(AuthenticatedState value)? authenticated,
    TResult? Function(UnauthenticatedState value)? unauthenticated,
    TResult? Function(RegisteredState value)? registered,
    TResult? Function(ErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialState value)? initial,
    TResult Function(LoadingState value)? loading,
    TResult Function(AuthenticatedState value)? authenticated,
    TResult Function(UnauthenticatedState value)? unauthenticated,
    TResult Function(RegisteredState value)? registered,
    TResult Function(ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorState implements AuthState {
  const factory ErrorState(final String message) = _$ErrorStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorStateImplCopyWith<_$ErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get rememberMe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String phone, String password, bool rememberMe});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String password, bool rememberMe});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(_$LoginRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl(
      {required this.phone, required this.password, this.rememberMe = false});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String password;
  @override
  @JsonKey()
  final bool rememberMe;

  @override
  String toString() {
    return 'LoginRequest(phone: $phone, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, password, rememberMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest(
      {required final String phone,
      required final String password,
      final bool rememberMe}) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get password;
  @override
  bool get rememberMe;
  @override
  @JsonKey(ignore: true)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  String get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
          RegisterRequest value, $Res Function(RegisterRequest) then) =
      _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call(
      {String phone,
      String password,
      String firstName,
      String lastName,
      String? email});
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(_$RegisterRequestImpl value,
          $Res Function(_$RegisterRequestImpl) then) =
      __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String phone,
      String password,
      String firstName,
      String lastName,
      String? email});
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
      _$RegisterRequestImpl _value, $Res Function(_$RegisterRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
  }) {
    return _then(_$RegisterRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestImpl implements _RegisterRequest {
  const _$RegisterRequestImpl(
      {required this.phone,
      required this.password,
      required this.firstName,
      required this.lastName,
      this.email});

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String password;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? email;

  @override
  String toString() {
    return 'RegisterRequest(phone: $phone, password: $password, firstName: $firstName, lastName: $lastName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phone, password, firstName, lastName, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest(
      {required final String phone,
      required final String password,
      required final String firstName,
      required final String lastName,
      final String? email}) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get password;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpRequest _$OtpRequestFromJson(Map<String, dynamic> json) {
  return _OtpRequest.fromJson(json);
}

/// @nodoc
mixin _$OtpRequest {
  String get phone => throw _privateConstructorUsedError;
  String get purpose => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpRequestCopyWith<OtpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpRequestCopyWith<$Res> {
  factory $OtpRequestCopyWith(
          OtpRequest value, $Res Function(OtpRequest) then) =
      _$OtpRequestCopyWithImpl<$Res, OtpRequest>;
  @useResult
  $Res call({String phone, String purpose});
}

/// @nodoc
class _$OtpRequestCopyWithImpl<$Res, $Val extends OtpRequest>
    implements $OtpRequestCopyWith<$Res> {
  _$OtpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? purpose = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpRequestImplCopyWith<$Res>
    implements $OtpRequestCopyWith<$Res> {
  factory _$$OtpRequestImplCopyWith(
          _$OtpRequestImpl value, $Res Function(_$OtpRequestImpl) then) =
      __$$OtpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String purpose});
}

/// @nodoc
class __$$OtpRequestImplCopyWithImpl<$Res>
    extends _$OtpRequestCopyWithImpl<$Res, _$OtpRequestImpl>
    implements _$$OtpRequestImplCopyWith<$Res> {
  __$$OtpRequestImplCopyWithImpl(
      _$OtpRequestImpl _value, $Res Function(_$OtpRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? purpose = null,
  }) {
    return _then(_$OtpRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpRequestImpl implements _OtpRequest {
  const _$OtpRequestImpl({required this.phone, this.purpose = 'verification'});

  factory _$OtpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpRequestImplFromJson(json);

  @override
  final String phone;
  @override
  @JsonKey()
  final String purpose;

  @override
  String toString() {
    return 'OtpRequest(phone: $phone, purpose: $purpose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.purpose, purpose) || other.purpose == purpose));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, purpose);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpRequestImplCopyWith<_$OtpRequestImpl> get copyWith =>
      __$$OtpRequestImplCopyWithImpl<_$OtpRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpRequestImplToJson(
      this,
    );
  }
}

abstract class _OtpRequest implements OtpRequest {
  const factory _OtpRequest(
      {required final String phone, final String purpose}) = _$OtpRequestImpl;

  factory _OtpRequest.fromJson(Map<String, dynamic> json) =
      _$OtpRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get purpose;
  @override
  @JsonKey(ignore: true)
  _$$OtpRequestImplCopyWith<_$OtpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpVerifyRequest _$OtpVerifyRequestFromJson(Map<String, dynamic> json) {
  return _OtpVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyRequest {
  String get phone => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyRequestCopyWith<OtpVerifyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyRequestCopyWith<$Res> {
  factory $OtpVerifyRequestCopyWith(
          OtpVerifyRequest value, $Res Function(OtpVerifyRequest) then) =
      _$OtpVerifyRequestCopyWithImpl<$Res, OtpVerifyRequest>;
  @useResult
  $Res call({String phone, String otp});
}

/// @nodoc
class _$OtpVerifyRequestCopyWithImpl<$Res, $Val extends OtpVerifyRequest>
    implements $OtpVerifyRequestCopyWith<$Res> {
  _$OtpVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyRequestImplCopyWith<$Res>
    implements $OtpVerifyRequestCopyWith<$Res> {
  factory _$$OtpVerifyRequestImplCopyWith(_$OtpVerifyRequestImpl value,
          $Res Function(_$OtpVerifyRequestImpl) then) =
      __$$OtpVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String otp});
}

/// @nodoc
class __$$OtpVerifyRequestImplCopyWithImpl<$Res>
    extends _$OtpVerifyRequestCopyWithImpl<$Res, _$OtpVerifyRequestImpl>
    implements _$$OtpVerifyRequestImplCopyWith<$Res> {
  __$$OtpVerifyRequestImplCopyWithImpl(_$OtpVerifyRequestImpl _value,
      $Res Function(_$OtpVerifyRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
  }) {
    return _then(_$OtpVerifyRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpVerifyRequestImpl implements _OtpVerifyRequest {
  const _$OtpVerifyRequestImpl({required this.phone, required this.otp});

  factory _$OtpVerifyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String otp;

  @override
  String toString() {
    return 'OtpVerifyRequest(phone: $phone, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, otp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyRequestImplCopyWith<_$OtpVerifyRequestImpl> get copyWith =>
      __$$OtpVerifyRequestImplCopyWithImpl<_$OtpVerifyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyRequestImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyRequest implements OtpVerifyRequest {
  const factory _OtpVerifyRequest(
      {required final String phone,
      required final String otp}) = _$OtpVerifyRequestImpl;

  factory _OtpVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get otp;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyRequestImplCopyWith<_$OtpVerifyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PasswordResetRequest _$PasswordResetRequestFromJson(Map<String, dynamic> json) {
  return _PasswordResetRequest.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetRequest {
  String get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PasswordResetRequestCopyWith<PasswordResetRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetRequestCopyWith<$Res> {
  factory $PasswordResetRequestCopyWith(PasswordResetRequest value,
          $Res Function(PasswordResetRequest) then) =
      _$PasswordResetRequestCopyWithImpl<$Res, PasswordResetRequest>;
  @useResult
  $Res call({String phone});
}

/// @nodoc
class _$PasswordResetRequestCopyWithImpl<$Res,
        $Val extends PasswordResetRequest>
    implements $PasswordResetRequestCopyWith<$Res> {
  _$PasswordResetRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordResetRequestImplCopyWith<$Res>
    implements $PasswordResetRequestCopyWith<$Res> {
  factory _$$PasswordResetRequestImplCopyWith(_$PasswordResetRequestImpl value,
          $Res Function(_$PasswordResetRequestImpl) then) =
      __$$PasswordResetRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone});
}

/// @nodoc
class __$$PasswordResetRequestImplCopyWithImpl<$Res>
    extends _$PasswordResetRequestCopyWithImpl<$Res, _$PasswordResetRequestImpl>
    implements _$$PasswordResetRequestImplCopyWith<$Res> {
  __$$PasswordResetRequestImplCopyWithImpl(_$PasswordResetRequestImpl _value,
      $Res Function(_$PasswordResetRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
  }) {
    return _then(_$PasswordResetRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordResetRequestImpl implements _PasswordResetRequest {
  const _$PasswordResetRequestImpl({required this.phone});

  factory _$PasswordResetRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordResetRequestImplFromJson(json);

  @override
  final String phone;

  @override
  String toString() {
    return 'PasswordResetRequest(phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetRequestImplCopyWith<_$PasswordResetRequestImpl>
      get copyWith =>
          __$$PasswordResetRequestImplCopyWithImpl<_$PasswordResetRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetRequestImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetRequest implements PasswordResetRequest {
  const factory _PasswordResetRequest({required final String phone}) =
      _$PasswordResetRequestImpl;

  factory _PasswordResetRequest.fromJson(Map<String, dynamic> json) =
      _$PasswordResetRequestImpl.fromJson;

  @override
  String get phone;
  @override
  @JsonKey(ignore: true)
  _$$PasswordResetRequestImplCopyWith<_$PasswordResetRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ResetPasswordRequest _$ResetPasswordRequestFromJson(Map<String, dynamic> json) {
  return _ResetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordRequest {
  String get phone => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPasswordRequestCopyWith<ResetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordRequestCopyWith<$Res> {
  factory $ResetPasswordRequestCopyWith(ResetPasswordRequest value,
          $Res Function(ResetPasswordRequest) then) =
      _$ResetPasswordRequestCopyWithImpl<$Res, ResetPasswordRequest>;
  @useResult
  $Res call({String phone, String otp, String newPassword});
}

/// @nodoc
class _$ResetPasswordRequestCopyWithImpl<$Res,
        $Val extends ResetPasswordRequest>
    implements $ResetPasswordRequestCopyWith<$Res> {
  _$ResetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPasswordRequestImplCopyWith<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  factory _$$ResetPasswordRequestImplCopyWith(_$ResetPasswordRequestImpl value,
          $Res Function(_$ResetPasswordRequestImpl) then) =
      __$$ResetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String otp, String newPassword});
}

/// @nodoc
class __$$ResetPasswordRequestImplCopyWithImpl<$Res>
    extends _$ResetPasswordRequestCopyWithImpl<$Res, _$ResetPasswordRequestImpl>
    implements _$$ResetPasswordRequestImplCopyWith<$Res> {
  __$$ResetPasswordRequestImplCopyWithImpl(_$ResetPasswordRequestImpl _value,
      $Res Function(_$ResetPasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
    Object? newPassword = null,
  }) {
    return _then(_$ResetPasswordRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPasswordRequestImpl implements _ResetPasswordRequest {
  const _$ResetPasswordRequestImpl(
      {required this.phone, required this.otp, required this.newPassword});

  factory _$ResetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String otp;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'ResetPasswordRequest(phone: $phone, otp: $otp, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, otp, newPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith =>
          __$$ResetPasswordRequestImplCopyWithImpl<_$ResetPasswordRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ResetPasswordRequest implements ResetPasswordRequest {
  const factory _ResetPasswordRequest(
      {required final String phone,
      required final String otp,
      required final String newPassword}) = _$ResetPasswordRequestImpl;

  factory _ResetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get otp;
  @override
  String get newPassword;
  @override
  @JsonKey(ignore: true)
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PasswordResetResponse _$PasswordResetResponseFromJson(
    Map<String, dynamic> json) {
  return _PasswordResetResponse.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get otpCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PasswordResetResponseCopyWith<PasswordResetResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetResponseCopyWith<$Res> {
  factory $PasswordResetResponseCopyWith(PasswordResetResponse value,
          $Res Function(PasswordResetResponse) then) =
      _$PasswordResetResponseCopyWithImpl<$Res, PasswordResetResponse>;
  @useResult
  $Res call({bool success, String message, String? otpCode});
}

/// @nodoc
class _$PasswordResetResponseCopyWithImpl<$Res,
        $Val extends PasswordResetResponse>
    implements $PasswordResetResponseCopyWith<$Res> {
  _$PasswordResetResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? otpCode = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      otpCode: freezed == otpCode
          ? _value.otpCode
          : otpCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordResetResponseImplCopyWith<$Res>
    implements $PasswordResetResponseCopyWith<$Res> {
  factory _$$PasswordResetResponseImplCopyWith(
          _$PasswordResetResponseImpl value,
          $Res Function(_$PasswordResetResponseImpl) then) =
      __$$PasswordResetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, String? otpCode});
}

/// @nodoc
class __$$PasswordResetResponseImplCopyWithImpl<$Res>
    extends _$PasswordResetResponseCopyWithImpl<$Res,
        _$PasswordResetResponseImpl>
    implements _$$PasswordResetResponseImplCopyWith<$Res> {
  __$$PasswordResetResponseImplCopyWithImpl(_$PasswordResetResponseImpl _value,
      $Res Function(_$PasswordResetResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? otpCode = freezed,
  }) {
    return _then(_$PasswordResetResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      otpCode: freezed == otpCode
          ? _value.otpCode
          : otpCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordResetResponseImpl implements _PasswordResetResponse {
  const _$PasswordResetResponseImpl(
      {required this.success, required this.message, this.otpCode});

  factory _$PasswordResetResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordResetResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final String? otpCode;

  @override
  String toString() {
    return 'PasswordResetResponse(success: $success, message: $message, otpCode: $otpCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.otpCode, otpCode) || other.otpCode == otpCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, otpCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetResponseImplCopyWith<_$PasswordResetResponseImpl>
      get copyWith => __$$PasswordResetResponseImplCopyWithImpl<
          _$PasswordResetResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetResponseImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetResponse implements PasswordResetResponse {
  const factory _PasswordResetResponse(
      {required final bool success,
      required final String message,
      final String? otpCode}) = _$PasswordResetResponseImpl;

  factory _PasswordResetResponse.fromJson(Map<String, dynamic> json) =
      _$PasswordResetResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  String? get otpCode;
  @override
  @JsonKey(ignore: true)
  _$$PasswordResetResponseImplCopyWith<_$PasswordResetResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call(
      {bool success,
      String message,
      String? accessToken,
      String? refreshToken,
      UserModel? user,
      String? token});

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? token = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
          _$AuthResponseImpl value, $Res Function(_$AuthResponseImpl) then) =
      __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      String? accessToken,
      String? refreshToken,
      UserModel? user,
      String? token});

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
      _$AuthResponseImpl _value, $Res Function(_$AuthResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? token = freezed,
  }) {
    return _then(_$AuthResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl(
      {required this.success,
      required this.message,
      this.accessToken,
      this.refreshToken,
      this.user,
      this.token});

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final UserModel? user;
  @override
  final String? token;

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, accessToken: $accessToken, refreshToken: $refreshToken, user: $user, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, message, accessToken, refreshToken, user, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse(
      {required final bool success,
      required final String message,
      final String? accessToken,
      final String? refreshToken,
      final UserModel? user,
      final String? token}) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  String? get accessToken;
  @override
  String? get refreshToken;
  @override
  UserModel? get user;
  @override
  String? get token;
  @override
  @JsonKey(ignore: true)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) {
  return _SessionInfo.fromJson(json);
}

/// @nodoc
mixin _$SessionInfo {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get lastActivity => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  Duration get inactivityDuration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionInfoCopyWith<SessionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionInfoCopyWith<$Res> {
  factory $SessionInfoCopyWith(
          SessionInfo value, $Res Function(SessionInfo) then) =
      _$SessionInfoCopyWithImpl<$Res, SessionInfo>;
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      DateTime startTime,
      DateTime lastActivity,
      bool isActive,
      Duration duration,
      Duration inactivityDuration});
}

/// @nodoc
class _$SessionInfoCopyWithImpl<$Res, $Val extends SessionInfo>
    implements $SessionInfoCopyWith<$Res> {
  _$SessionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? lastActivity = null,
    Object? isActive = null,
    Object? duration = null,
    Object? inactivityDuration = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivity: null == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      inactivityDuration: null == inactivityDuration
          ? _value.inactivityDuration
          : inactivityDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionInfoImplCopyWith<$Res>
    implements $SessionInfoCopyWith<$Res> {
  factory _$$SessionInfoImplCopyWith(
          _$SessionInfoImpl value, $Res Function(_$SessionInfoImpl) then) =
      __$$SessionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      DateTime startTime,
      DateTime lastActivity,
      bool isActive,
      Duration duration,
      Duration inactivityDuration});
}

/// @nodoc
class __$$SessionInfoImplCopyWithImpl<$Res>
    extends _$SessionInfoCopyWithImpl<$Res, _$SessionInfoImpl>
    implements _$$SessionInfoImplCopyWith<$Res> {
  __$$SessionInfoImplCopyWithImpl(
      _$SessionInfoImpl _value, $Res Function(_$SessionInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? lastActivity = null,
    Object? isActive = null,
    Object? duration = null,
    Object? inactivityDuration = null,
  }) {
    return _then(_$SessionInfoImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivity: null == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      inactivityDuration: null == inactivityDuration
          ? _value.inactivityDuration
          : inactivityDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionInfoImpl implements _SessionInfo {
  const _$SessionInfoImpl(
      {required this.sessionId,
      required this.userId,
      required this.startTime,
      required this.lastActivity,
      required this.isActive,
      required this.duration,
      required this.inactivityDuration});

  factory _$SessionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionInfoImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime lastActivity;
  @override
  final bool isActive;
  @override
  final Duration duration;
  @override
  final Duration inactivityDuration;

  @override
  String toString() {
    return 'SessionInfo(sessionId: $sessionId, userId: $userId, startTime: $startTime, lastActivity: $lastActivity, isActive: $isActive, duration: $duration, inactivityDuration: $inactivityDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionInfoImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.lastActivity, lastActivity) ||
                other.lastActivity == lastActivity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.inactivityDuration, inactivityDuration) ||
                other.inactivityDuration == inactivityDuration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userId, startTime,
      lastActivity, isActive, duration, inactivityDuration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionInfoImplCopyWith<_$SessionInfoImpl> get copyWith =>
      __$$SessionInfoImplCopyWithImpl<_$SessionInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionInfoImplToJson(
      this,
    );
  }
}

abstract class _SessionInfo implements SessionInfo {
  const factory _SessionInfo(
      {required final String sessionId,
      required final String userId,
      required final DateTime startTime,
      required final DateTime lastActivity,
      required final bool isActive,
      required final Duration duration,
      required final Duration inactivityDuration}) = _$SessionInfoImpl;

  factory _SessionInfo.fromJson(Map<String, dynamic> json) =
      _$SessionInfoImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime get lastActivity;
  @override
  bool get isActive;
  @override
  Duration get duration;
  @override
  Duration get inactivityDuration;
  @override
  @JsonKey(ignore: true)
  _$$SessionInfoImplCopyWith<_$SessionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) {
  return _TokenInfo.fromJson(json);
}

/// @nodoc
mixin _$TokenInfo {
  bool get hasAccessToken => throw _privateConstructorUsedError;
  bool get hasRefreshToken => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;
  String? get expiryTime => throw _privateConstructorUsedError;
  String? get lastRefresh => throw _privateConstructorUsedError;
  int? get timeUntilExpiry => throw _privateConstructorUsedError;
  bool get integrityValid => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TokenInfoCopyWith<TokenInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenInfoCopyWith<$Res> {
  factory $TokenInfoCopyWith(TokenInfo value, $Res Function(TokenInfo) then) =
      _$TokenInfoCopyWithImpl<$Res, TokenInfo>;
  @useResult
  $Res call(
      {bool hasAccessToken,
      bool hasRefreshToken,
      bool isValid,
      String? expiryTime,
      String? lastRefresh,
      int? timeUntilExpiry,
      bool integrityValid,
      String platform});
}

/// @nodoc
class _$TokenInfoCopyWithImpl<$Res, $Val extends TokenInfo>
    implements $TokenInfoCopyWith<$Res> {
  _$TokenInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAccessToken = null,
    Object? hasRefreshToken = null,
    Object? isValid = null,
    Object? expiryTime = freezed,
    Object? lastRefresh = freezed,
    Object? timeUntilExpiry = freezed,
    Object? integrityValid = null,
    Object? platform = null,
  }) {
    return _then(_value.copyWith(
      hasAccessToken: null == hasAccessToken
          ? _value.hasAccessToken
          : hasAccessToken // ignore: cast_nullable_to_non_nullable
              as bool,
      hasRefreshToken: null == hasRefreshToken
          ? _value.hasRefreshToken
          : hasRefreshToken // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryTime: freezed == expiryTime
          ? _value.expiryTime
          : expiryTime // ignore: cast_nullable_to_non_nullable
              as String?,
      lastRefresh: freezed == lastRefresh
          ? _value.lastRefresh
          : lastRefresh // ignore: cast_nullable_to_non_nullable
              as String?,
      timeUntilExpiry: freezed == timeUntilExpiry
          ? _value.timeUntilExpiry
          : timeUntilExpiry // ignore: cast_nullable_to_non_nullable
              as int?,
      integrityValid: null == integrityValid
          ? _value.integrityValid
          : integrityValid // ignore: cast_nullable_to_non_nullable
              as bool,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenInfoImplCopyWith<$Res>
    implements $TokenInfoCopyWith<$Res> {
  factory _$$TokenInfoImplCopyWith(
          _$TokenInfoImpl value, $Res Function(_$TokenInfoImpl) then) =
      __$$TokenInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasAccessToken,
      bool hasRefreshToken,
      bool isValid,
      String? expiryTime,
      String? lastRefresh,
      int? timeUntilExpiry,
      bool integrityValid,
      String platform});
}

/// @nodoc
class __$$TokenInfoImplCopyWithImpl<$Res>
    extends _$TokenInfoCopyWithImpl<$Res, _$TokenInfoImpl>
    implements _$$TokenInfoImplCopyWith<$Res> {
  __$$TokenInfoImplCopyWithImpl(
      _$TokenInfoImpl _value, $Res Function(_$TokenInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAccessToken = null,
    Object? hasRefreshToken = null,
    Object? isValid = null,
    Object? expiryTime = freezed,
    Object? lastRefresh = freezed,
    Object? timeUntilExpiry = freezed,
    Object? integrityValid = null,
    Object? platform = null,
  }) {
    return _then(_$TokenInfoImpl(
      hasAccessToken: null == hasAccessToken
          ? _value.hasAccessToken
          : hasAccessToken // ignore: cast_nullable_to_non_nullable
              as bool,
      hasRefreshToken: null == hasRefreshToken
          ? _value.hasRefreshToken
          : hasRefreshToken // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryTime: freezed == expiryTime
          ? _value.expiryTime
          : expiryTime // ignore: cast_nullable_to_non_nullable
              as String?,
      lastRefresh: freezed == lastRefresh
          ? _value.lastRefresh
          : lastRefresh // ignore: cast_nullable_to_non_nullable
              as String?,
      timeUntilExpiry: freezed == timeUntilExpiry
          ? _value.timeUntilExpiry
          : timeUntilExpiry // ignore: cast_nullable_to_non_nullable
              as int?,
      integrityValid: null == integrityValid
          ? _value.integrityValid
          : integrityValid // ignore: cast_nullable_to_non_nullable
              as bool,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenInfoImpl implements _TokenInfo {
  const _$TokenInfoImpl(
      {required this.hasAccessToken,
      required this.hasRefreshToken,
      required this.isValid,
      this.expiryTime,
      this.lastRefresh,
      this.timeUntilExpiry,
      required this.integrityValid,
      required this.platform});

  factory _$TokenInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenInfoImplFromJson(json);

  @override
  final bool hasAccessToken;
  @override
  final bool hasRefreshToken;
  @override
  final bool isValid;
  @override
  final String? expiryTime;
  @override
  final String? lastRefresh;
  @override
  final int? timeUntilExpiry;
  @override
  final bool integrityValid;
  @override
  final String platform;

  @override
  String toString() {
    return 'TokenInfo(hasAccessToken: $hasAccessToken, hasRefreshToken: $hasRefreshToken, isValid: $isValid, expiryTime: $expiryTime, lastRefresh: $lastRefresh, timeUntilExpiry: $timeUntilExpiry, integrityValid: $integrityValid, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenInfoImpl &&
            (identical(other.hasAccessToken, hasAccessToken) ||
                other.hasAccessToken == hasAccessToken) &&
            (identical(other.hasRefreshToken, hasRefreshToken) ||
                other.hasRefreshToken == hasRefreshToken) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.expiryTime, expiryTime) ||
                other.expiryTime == expiryTime) &&
            (identical(other.lastRefresh, lastRefresh) ||
                other.lastRefresh == lastRefresh) &&
            (identical(other.timeUntilExpiry, timeUntilExpiry) ||
                other.timeUntilExpiry == timeUntilExpiry) &&
            (identical(other.integrityValid, integrityValid) ||
                other.integrityValid == integrityValid) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hasAccessToken,
      hasRefreshToken,
      isValid,
      expiryTime,
      lastRefresh,
      timeUntilExpiry,
      integrityValid,
      platform);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenInfoImplCopyWith<_$TokenInfoImpl> get copyWith =>
      __$$TokenInfoImplCopyWithImpl<_$TokenInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenInfoImplToJson(
      this,
    );
  }
}

abstract class _TokenInfo implements TokenInfo {
  const factory _TokenInfo(
      {required final bool hasAccessToken,
      required final bool hasRefreshToken,
      required final bool isValid,
      final String? expiryTime,
      final String? lastRefresh,
      final int? timeUntilExpiry,
      required final bool integrityValid,
      required final String platform}) = _$TokenInfoImpl;

  factory _TokenInfo.fromJson(Map<String, dynamic> json) =
      _$TokenInfoImpl.fromJson;

  @override
  bool get hasAccessToken;
  @override
  bool get hasRefreshToken;
  @override
  bool get isValid;
  @override
  String? get expiryTime;
  @override
  String? get lastRefresh;
  @override
  int? get timeUntilExpiry;
  @override
  bool get integrityValid;
  @override
  String get platform;
  @override
  @JsonKey(ignore: true)
  _$$TokenInfoImplCopyWith<_$TokenInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StorageInfo _$StorageInfoFromJson(Map<String, dynamic> json) {
  return _StorageInfo.fromJson(json);
}

/// @nodoc
mixin _$StorageInfo {
  String? get lastSyncTime => throw _privateConstructorUsedError;
  int get pendingOperationsCount => throw _privateConstructorUsedError;
  bool get hasUserData => throw _privateConstructorUsedError;
  bool get hasAuthData => throw _privateConstructorUsedError;
  int get totalOfflineData => throw _privateConstructorUsedError;
  int get dataRetentionPeriod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StorageInfoCopyWith<StorageInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorageInfoCopyWith<$Res> {
  factory $StorageInfoCopyWith(
          StorageInfo value, $Res Function(StorageInfo) then) =
      _$StorageInfoCopyWithImpl<$Res, StorageInfo>;
  @useResult
  $Res call(
      {String? lastSyncTime,
      int pendingOperationsCount,
      bool hasUserData,
      bool hasAuthData,
      int totalOfflineData,
      int dataRetentionPeriod});
}

/// @nodoc
class _$StorageInfoCopyWithImpl<$Res, $Val extends StorageInfo>
    implements $StorageInfoCopyWith<$Res> {
  _$StorageInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastSyncTime = freezed,
    Object? pendingOperationsCount = null,
    Object? hasUserData = null,
    Object? hasAuthData = null,
    Object? totalOfflineData = null,
    Object? dataRetentionPeriod = null,
  }) {
    return _then(_value.copyWith(
      lastSyncTime: freezed == lastSyncTime
          ? _value.lastSyncTime
          : lastSyncTime // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingOperationsCount: null == pendingOperationsCount
          ? _value.pendingOperationsCount
          : pendingOperationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasUserData: null == hasUserData
          ? _value.hasUserData
          : hasUserData // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAuthData: null == hasAuthData
          ? _value.hasAuthData
          : hasAuthData // ignore: cast_nullable_to_non_nullable
              as bool,
      totalOfflineData: null == totalOfflineData
          ? _value.totalOfflineData
          : totalOfflineData // ignore: cast_nullable_to_non_nullable
              as int,
      dataRetentionPeriod: null == dataRetentionPeriod
          ? _value.dataRetentionPeriod
          : dataRetentionPeriod // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StorageInfoImplCopyWith<$Res>
    implements $StorageInfoCopyWith<$Res> {
  factory _$$StorageInfoImplCopyWith(
          _$StorageInfoImpl value, $Res Function(_$StorageInfoImpl) then) =
      __$$StorageInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? lastSyncTime,
      int pendingOperationsCount,
      bool hasUserData,
      bool hasAuthData,
      int totalOfflineData,
      int dataRetentionPeriod});
}

/// @nodoc
class __$$StorageInfoImplCopyWithImpl<$Res>
    extends _$StorageInfoCopyWithImpl<$Res, _$StorageInfoImpl>
    implements _$$StorageInfoImplCopyWith<$Res> {
  __$$StorageInfoImplCopyWithImpl(
      _$StorageInfoImpl _value, $Res Function(_$StorageInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastSyncTime = freezed,
    Object? pendingOperationsCount = null,
    Object? hasUserData = null,
    Object? hasAuthData = null,
    Object? totalOfflineData = null,
    Object? dataRetentionPeriod = null,
  }) {
    return _then(_$StorageInfoImpl(
      lastSyncTime: freezed == lastSyncTime
          ? _value.lastSyncTime
          : lastSyncTime // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingOperationsCount: null == pendingOperationsCount
          ? _value.pendingOperationsCount
          : pendingOperationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasUserData: null == hasUserData
          ? _value.hasUserData
          : hasUserData // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAuthData: null == hasAuthData
          ? _value.hasAuthData
          : hasAuthData // ignore: cast_nullable_to_non_nullable
              as bool,
      totalOfflineData: null == totalOfflineData
          ? _value.totalOfflineData
          : totalOfflineData // ignore: cast_nullable_to_non_nullable
              as int,
      dataRetentionPeriod: null == dataRetentionPeriod
          ? _value.dataRetentionPeriod
          : dataRetentionPeriod // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StorageInfoImpl implements _StorageInfo {
  const _$StorageInfoImpl(
      {this.lastSyncTime,
      required this.pendingOperationsCount,
      required this.hasUserData,
      required this.hasAuthData,
      required this.totalOfflineData,
      required this.dataRetentionPeriod});

  factory _$StorageInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StorageInfoImplFromJson(json);

  @override
  final String? lastSyncTime;
  @override
  final int pendingOperationsCount;
  @override
  final bool hasUserData;
  @override
  final bool hasAuthData;
  @override
  final int totalOfflineData;
  @override
  final int dataRetentionPeriod;

  @override
  String toString() {
    return 'StorageInfo(lastSyncTime: $lastSyncTime, pendingOperationsCount: $pendingOperationsCount, hasUserData: $hasUserData, hasAuthData: $hasAuthData, totalOfflineData: $totalOfflineData, dataRetentionPeriod: $dataRetentionPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageInfoImpl &&
            (identical(other.lastSyncTime, lastSyncTime) ||
                other.lastSyncTime == lastSyncTime) &&
            (identical(other.pendingOperationsCount, pendingOperationsCount) ||
                other.pendingOperationsCount == pendingOperationsCount) &&
            (identical(other.hasUserData, hasUserData) ||
                other.hasUserData == hasUserData) &&
            (identical(other.hasAuthData, hasAuthData) ||
                other.hasAuthData == hasAuthData) &&
            (identical(other.totalOfflineData, totalOfflineData) ||
                other.totalOfflineData == totalOfflineData) &&
            (identical(other.dataRetentionPeriod, dataRetentionPeriod) ||
                other.dataRetentionPeriod == dataRetentionPeriod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastSyncTime,
      pendingOperationsCount,
      hasUserData,
      hasAuthData,
      totalOfflineData,
      dataRetentionPeriod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageInfoImplCopyWith<_$StorageInfoImpl> get copyWith =>
      __$$StorageInfoImplCopyWithImpl<_$StorageInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StorageInfoImplToJson(
      this,
    );
  }
}

abstract class _StorageInfo implements StorageInfo {
  const factory _StorageInfo(
      {final String? lastSyncTime,
      required final int pendingOperationsCount,
      required final bool hasUserData,
      required final bool hasAuthData,
      required final int totalOfflineData,
      required final int dataRetentionPeriod}) = _$StorageInfoImpl;

  factory _StorageInfo.fromJson(Map<String, dynamic> json) =
      _$StorageInfoImpl.fromJson;

  @override
  String? get lastSyncTime;
  @override
  int get pendingOperationsCount;
  @override
  bool get hasUserData;
  @override
  bool get hasAuthData;
  @override
  int get totalOfflineData;
  @override
  int get dataRetentionPeriod;
  @override
  @JsonKey(ignore: true)
  _$$StorageInfoImplCopyWith<_$StorageInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectivityInfo _$ConnectivityInfoFromJson(Map<String, dynamic> json) {
  return _ConnectivityInfo.fromJson(json);
}

/// @nodoc
mixin _$ConnectivityInfo {
  String get currentStatus => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  String get connectionType => throw _privateConstructorUsedError;
  String get lastCheck => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConnectivityInfoCopyWith<ConnectivityInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectivityInfoCopyWith<$Res> {
  factory $ConnectivityInfoCopyWith(
          ConnectivityInfo value, $Res Function(ConnectivityInfo) then) =
      _$ConnectivityInfoCopyWithImpl<$Res, ConnectivityInfo>;
  @useResult
  $Res call(
      {String currentStatus,
      bool isConnected,
      String connectionType,
      String lastCheck,
      String platform});
}

/// @nodoc
class _$ConnectivityInfoCopyWithImpl<$Res, $Val extends ConnectivityInfo>
    implements $ConnectivityInfoCopyWith<$Res> {
  _$ConnectivityInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStatus = null,
    Object? isConnected = null,
    Object? connectionType = null,
    Object? lastCheck = null,
    Object? platform = null,
  }) {
    return _then(_value.copyWith(
      currentStatus: null == currentStatus
          ? _value.currentStatus
          : currentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionType: null == connectionType
          ? _value.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as String,
      lastCheck: null == lastCheck
          ? _value.lastCheck
          : lastCheck // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectivityInfoImplCopyWith<$Res>
    implements $ConnectivityInfoCopyWith<$Res> {
  factory _$$ConnectivityInfoImplCopyWith(_$ConnectivityInfoImpl value,
          $Res Function(_$ConnectivityInfoImpl) then) =
      __$$ConnectivityInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currentStatus,
      bool isConnected,
      String connectionType,
      String lastCheck,
      String platform});
}

/// @nodoc
class __$$ConnectivityInfoImplCopyWithImpl<$Res>
    extends _$ConnectivityInfoCopyWithImpl<$Res, _$ConnectivityInfoImpl>
    implements _$$ConnectivityInfoImplCopyWith<$Res> {
  __$$ConnectivityInfoImplCopyWithImpl(_$ConnectivityInfoImpl _value,
      $Res Function(_$ConnectivityInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStatus = null,
    Object? isConnected = null,
    Object? connectionType = null,
    Object? lastCheck = null,
    Object? platform = null,
  }) {
    return _then(_$ConnectivityInfoImpl(
      currentStatus: null == currentStatus
          ? _value.currentStatus
          : currentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionType: null == connectionType
          ? _value.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as String,
      lastCheck: null == lastCheck
          ? _value.lastCheck
          : lastCheck // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectivityInfoImpl implements _ConnectivityInfo {
  const _$ConnectivityInfoImpl(
      {required this.currentStatus,
      required this.isConnected,
      required this.connectionType,
      required this.lastCheck,
      required this.platform});

  factory _$ConnectivityInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectivityInfoImplFromJson(json);

  @override
  final String currentStatus;
  @override
  final bool isConnected;
  @override
  final String connectionType;
  @override
  final String lastCheck;
  @override
  final String platform;

  @override
  String toString() {
    return 'ConnectivityInfo(currentStatus: $currentStatus, isConnected: $isConnected, connectionType: $connectionType, lastCheck: $lastCheck, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectivityInfoImpl &&
            (identical(other.currentStatus, currentStatus) ||
                other.currentStatus == currentStatus) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.lastCheck, lastCheck) ||
                other.lastCheck == lastCheck) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentStatus, isConnected,
      connectionType, lastCheck, platform);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectivityInfoImplCopyWith<_$ConnectivityInfoImpl> get copyWith =>
      __$$ConnectivityInfoImplCopyWithImpl<_$ConnectivityInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectivityInfoImplToJson(
      this,
    );
  }
}

abstract class _ConnectivityInfo implements ConnectivityInfo {
  const factory _ConnectivityInfo(
      {required final String currentStatus,
      required final bool isConnected,
      required final String connectionType,
      required final String lastCheck,
      required final String platform}) = _$ConnectivityInfoImpl;

  factory _ConnectivityInfo.fromJson(Map<String, dynamic> json) =
      _$ConnectivityInfoImpl.fromJson;

  @override
  String get currentStatus;
  @override
  bool get isConnected;
  @override
  String get connectionType;
  @override
  String get lastCheck;
  @override
  String get platform;
  @override
  @JsonKey(ignore: true)
  _$$ConnectivityInfoImplCopyWith<_$ConnectivityInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) {
  return _SystemInfo.fromJson(json);
}

/// @nodoc
mixin _$SystemInfo {
  SessionInfo get sessionInfo => throw _privateConstructorUsedError;
  TokenInfo get tokenInfo => throw _privateConstructorUsedError;
  StorageInfo get storageInfo => throw _privateConstructorUsedError;
  ConnectivityInfo get connectivityInfo => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SystemInfoCopyWith<SystemInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemInfoCopyWith<$Res> {
  factory $SystemInfoCopyWith(
          SystemInfo value, $Res Function(SystemInfo) then) =
      _$SystemInfoCopyWithImpl<$Res, SystemInfo>;
  @useResult
  $Res call(
      {SessionInfo sessionInfo,
      TokenInfo tokenInfo,
      StorageInfo storageInfo,
      ConnectivityInfo connectivityInfo,
      DateTime timestamp});

  $SessionInfoCopyWith<$Res> get sessionInfo;
  $TokenInfoCopyWith<$Res> get tokenInfo;
  $StorageInfoCopyWith<$Res> get storageInfo;
  $ConnectivityInfoCopyWith<$Res> get connectivityInfo;
}

/// @nodoc
class _$SystemInfoCopyWithImpl<$Res, $Val extends SystemInfo>
    implements $SystemInfoCopyWith<$Res> {
  _$SystemInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionInfo = null,
    Object? tokenInfo = null,
    Object? storageInfo = null,
    Object? connectivityInfo = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      sessionInfo: null == sessionInfo
          ? _value.sessionInfo
          : sessionInfo // ignore: cast_nullable_to_non_nullable
              as SessionInfo,
      tokenInfo: null == tokenInfo
          ? _value.tokenInfo
          : tokenInfo // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
      storageInfo: null == storageInfo
          ? _value.storageInfo
          : storageInfo // ignore: cast_nullable_to_non_nullable
              as StorageInfo,
      connectivityInfo: null == connectivityInfo
          ? _value.connectivityInfo
          : connectivityInfo // ignore: cast_nullable_to_non_nullable
              as ConnectivityInfo,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SessionInfoCopyWith<$Res> get sessionInfo {
    return $SessionInfoCopyWith<$Res>(_value.sessionInfo, (value) {
      return _then(_value.copyWith(sessionInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get tokenInfo {
    return $TokenInfoCopyWith<$Res>(_value.tokenInfo, (value) {
      return _then(_value.copyWith(tokenInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StorageInfoCopyWith<$Res> get storageInfo {
    return $StorageInfoCopyWith<$Res>(_value.storageInfo, (value) {
      return _then(_value.copyWith(storageInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConnectivityInfoCopyWith<$Res> get connectivityInfo {
    return $ConnectivityInfoCopyWith<$Res>(_value.connectivityInfo, (value) {
      return _then(_value.copyWith(connectivityInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SystemInfoImplCopyWith<$Res>
    implements $SystemInfoCopyWith<$Res> {
  factory _$$SystemInfoImplCopyWith(
          _$SystemInfoImpl value, $Res Function(_$SystemInfoImpl) then) =
      __$$SystemInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SessionInfo sessionInfo,
      TokenInfo tokenInfo,
      StorageInfo storageInfo,
      ConnectivityInfo connectivityInfo,
      DateTime timestamp});

  @override
  $SessionInfoCopyWith<$Res> get sessionInfo;
  @override
  $TokenInfoCopyWith<$Res> get tokenInfo;
  @override
  $StorageInfoCopyWith<$Res> get storageInfo;
  @override
  $ConnectivityInfoCopyWith<$Res> get connectivityInfo;
}

/// @nodoc
class __$$SystemInfoImplCopyWithImpl<$Res>
    extends _$SystemInfoCopyWithImpl<$Res, _$SystemInfoImpl>
    implements _$$SystemInfoImplCopyWith<$Res> {
  __$$SystemInfoImplCopyWithImpl(
      _$SystemInfoImpl _value, $Res Function(_$SystemInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionInfo = null,
    Object? tokenInfo = null,
    Object? storageInfo = null,
    Object? connectivityInfo = null,
    Object? timestamp = null,
  }) {
    return _then(_$SystemInfoImpl(
      sessionInfo: null == sessionInfo
          ? _value.sessionInfo
          : sessionInfo // ignore: cast_nullable_to_non_nullable
              as SessionInfo,
      tokenInfo: null == tokenInfo
          ? _value.tokenInfo
          : tokenInfo // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
      storageInfo: null == storageInfo
          ? _value.storageInfo
          : storageInfo // ignore: cast_nullable_to_non_nullable
              as StorageInfo,
      connectivityInfo: null == connectivityInfo
          ? _value.connectivityInfo
          : connectivityInfo // ignore: cast_nullable_to_non_nullable
              as ConnectivityInfo,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemInfoImpl implements _SystemInfo {
  const _$SystemInfoImpl(
      {required this.sessionInfo,
      required this.tokenInfo,
      required this.storageInfo,
      required this.connectivityInfo,
      required this.timestamp});

  factory _$SystemInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemInfoImplFromJson(json);

  @override
  final SessionInfo sessionInfo;
  @override
  final TokenInfo tokenInfo;
  @override
  final StorageInfo storageInfo;
  @override
  final ConnectivityInfo connectivityInfo;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'SystemInfo(sessionInfo: $sessionInfo, tokenInfo: $tokenInfo, storageInfo: $storageInfo, connectivityInfo: $connectivityInfo, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemInfoImpl &&
            (identical(other.sessionInfo, sessionInfo) ||
                other.sessionInfo == sessionInfo) &&
            (identical(other.tokenInfo, tokenInfo) ||
                other.tokenInfo == tokenInfo) &&
            (identical(other.storageInfo, storageInfo) ||
                other.storageInfo == storageInfo) &&
            (identical(other.connectivityInfo, connectivityInfo) ||
                other.connectivityInfo == connectivityInfo) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionInfo, tokenInfo,
      storageInfo, connectivityInfo, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemInfoImplCopyWith<_$SystemInfoImpl> get copyWith =>
      __$$SystemInfoImplCopyWithImpl<_$SystemInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemInfoImplToJson(
      this,
    );
  }
}

abstract class _SystemInfo implements SystemInfo {
  const factory _SystemInfo(
      {required final SessionInfo sessionInfo,
      required final TokenInfo tokenInfo,
      required final StorageInfo storageInfo,
      required final ConnectivityInfo connectivityInfo,
      required final DateTime timestamp}) = _$SystemInfoImpl;

  factory _SystemInfo.fromJson(Map<String, dynamic> json) =
      _$SystemInfoImpl.fromJson;

  @override
  SessionInfo get sessionInfo;
  @override
  TokenInfo get tokenInfo;
  @override
  StorageInfo get storageInfo;
  @override
  ConnectivityInfo get connectivityInfo;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$SystemInfoImplCopyWith<_$SystemInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
