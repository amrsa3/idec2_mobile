// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_instruction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentInstructionModel _$PaymentInstructionModelFromJson(
    Map<String, dynamic> json) {
  return _PaymentInstructionModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentInstructionModel {
  String get type =>
      throw _privateConstructorUsedError; // REDIRECT or INPUT_REQUIRED
  @JsonKey(name: 'data')
  PaymentInstructionDataModel get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentInstructionModelCopyWith<PaymentInstructionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentInstructionModelCopyWith<$Res> {
  factory $PaymentInstructionModelCopyWith(PaymentInstructionModel value,
          $Res Function(PaymentInstructionModel) then) =
      _$PaymentInstructionModelCopyWithImpl<$Res, PaymentInstructionModel>;
  @useResult
  $Res call(
      {String type, @JsonKey(name: 'data') PaymentInstructionDataModel data});

  $PaymentInstructionDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$PaymentInstructionModelCopyWithImpl<$Res,
        $Val extends PaymentInstructionModel>
    implements $PaymentInstructionModelCopyWith<$Res> {
  _$PaymentInstructionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaymentInstructionDataModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaymentInstructionDataModelCopyWith<$Res> get data {
    return $PaymentInstructionDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentInstructionModelImplCopyWith<$Res>
    implements $PaymentInstructionModelCopyWith<$Res> {
  factory _$$PaymentInstructionModelImplCopyWith(
          _$PaymentInstructionModelImpl value,
          $Res Function(_$PaymentInstructionModelImpl) then) =
      __$$PaymentInstructionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type, @JsonKey(name: 'data') PaymentInstructionDataModel data});

  @override
  $PaymentInstructionDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$PaymentInstructionModelImplCopyWithImpl<$Res>
    extends _$PaymentInstructionModelCopyWithImpl<$Res,
        _$PaymentInstructionModelImpl>
    implements _$$PaymentInstructionModelImplCopyWith<$Res> {
  __$$PaymentInstructionModelImplCopyWithImpl(
      _$PaymentInstructionModelImpl _value,
      $Res Function(_$PaymentInstructionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_$PaymentInstructionModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaymentInstructionDataModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentInstructionModelImpl implements _PaymentInstructionModel {
  const _$PaymentInstructionModelImpl(
      {required this.type, @JsonKey(name: 'data') required this.data});

  factory _$PaymentInstructionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentInstructionModelImplFromJson(json);

  @override
  final String type;
// REDIRECT or INPUT_REQUIRED
  @override
  @JsonKey(name: 'data')
  final PaymentInstructionDataModel data;

  @override
  String toString() {
    return 'PaymentInstructionModel(type: $type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInstructionModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInstructionModelImplCopyWith<_$PaymentInstructionModelImpl>
      get copyWith => __$$PaymentInstructionModelImplCopyWithImpl<
          _$PaymentInstructionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentInstructionModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentInstructionModel implements PaymentInstructionModel {
  const factory _PaymentInstructionModel(
          {required final String type,
          @JsonKey(name: 'data')
          required final PaymentInstructionDataModel data}) =
      _$PaymentInstructionModelImpl;

  factory _PaymentInstructionModel.fromJson(Map<String, dynamic> json) =
      _$PaymentInstructionModelImpl.fromJson;

  @override
  String get type;
  @override // REDIRECT or INPUT_REQUIRED
  @JsonKey(name: 'data')
  PaymentInstructionDataModel get data;
  @override
  @JsonKey(ignore: true)
  _$$PaymentInstructionModelImplCopyWith<_$PaymentInstructionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaymentInstructionDataModel _$PaymentInstructionDataModelFromJson(
    Map<String, dynamic> json) {
  return _PaymentInstructionDataModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentInstructionDataModel {
  String? get url => throw _privateConstructorUsedError; // For REDIRECT type
  List<PaymentFieldModel>? get fields => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentInstructionDataModelCopyWith<PaymentInstructionDataModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentInstructionDataModelCopyWith<$Res> {
  factory $PaymentInstructionDataModelCopyWith(
          PaymentInstructionDataModel value,
          $Res Function(PaymentInstructionDataModel) then) =
      _$PaymentInstructionDataModelCopyWithImpl<$Res,
          PaymentInstructionDataModel>;
  @useResult
  $Res call({String? url, List<PaymentFieldModel>? fields});
}

/// @nodoc
class _$PaymentInstructionDataModelCopyWithImpl<$Res,
        $Val extends PaymentInstructionDataModel>
    implements $PaymentInstructionDataModelCopyWith<$Res> {
  _$PaymentInstructionDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? fields = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      fields: freezed == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<PaymentFieldModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentInstructionDataModelImplCopyWith<$Res>
    implements $PaymentInstructionDataModelCopyWith<$Res> {
  factory _$$PaymentInstructionDataModelImplCopyWith(
          _$PaymentInstructionDataModelImpl value,
          $Res Function(_$PaymentInstructionDataModelImpl) then) =
      __$$PaymentInstructionDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, List<PaymentFieldModel>? fields});
}

/// @nodoc
class __$$PaymentInstructionDataModelImplCopyWithImpl<$Res>
    extends _$PaymentInstructionDataModelCopyWithImpl<$Res,
        _$PaymentInstructionDataModelImpl>
    implements _$$PaymentInstructionDataModelImplCopyWith<$Res> {
  __$$PaymentInstructionDataModelImplCopyWithImpl(
      _$PaymentInstructionDataModelImpl _value,
      $Res Function(_$PaymentInstructionDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? fields = freezed,
  }) {
    return _then(_$PaymentInstructionDataModelImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      fields: freezed == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<PaymentFieldModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentInstructionDataModelImpl
    implements _PaymentInstructionDataModel {
  const _$PaymentInstructionDataModelImpl(
      {this.url, final List<PaymentFieldModel>? fields})
      : _fields = fields;

  factory _$PaymentInstructionDataModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PaymentInstructionDataModelImplFromJson(json);

  @override
  final String? url;
// For REDIRECT type
  final List<PaymentFieldModel>? _fields;
// For REDIRECT type
  @override
  List<PaymentFieldModel>? get fields {
    final value = _fields;
    if (value == null) return null;
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PaymentInstructionDataModel(url: $url, fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInstructionDataModelImpl &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, const DeepCollectionEquality().hash(_fields));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInstructionDataModelImplCopyWith<_$PaymentInstructionDataModelImpl>
      get copyWith => __$$PaymentInstructionDataModelImplCopyWithImpl<
          _$PaymentInstructionDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentInstructionDataModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentInstructionDataModel
    implements PaymentInstructionDataModel {
  const factory _PaymentInstructionDataModel(
          {final String? url, final List<PaymentFieldModel>? fields}) =
      _$PaymentInstructionDataModelImpl;

  factory _PaymentInstructionDataModel.fromJson(Map<String, dynamic> json) =
      _$PaymentInstructionDataModelImpl.fromJson;

  @override
  String? get url;
  @override // For REDIRECT type
  List<PaymentFieldModel>? get fields;
  @override
  @JsonKey(ignore: true)
  _$$PaymentInstructionDataModelImplCopyWith<_$PaymentInstructionDataModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaymentFieldModel _$PaymentFieldModelFromJson(Map<String, dynamic> json) {
  return _PaymentFieldModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentFieldModel {
  String get name => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get type =>
      throw _privateConstructorUsedError; // text, number, password
  String? get placeholder => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentFieldModelCopyWith<PaymentFieldModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentFieldModelCopyWith<$Res> {
  factory $PaymentFieldModelCopyWith(
          PaymentFieldModel value, $Res Function(PaymentFieldModel) then) =
      _$PaymentFieldModelCopyWithImpl<$Res, PaymentFieldModel>;
  @useResult
  $Res call(
      {String name,
      String label,
      String? type,
      String? placeholder,
      bool required});
}

/// @nodoc
class _$PaymentFieldModelCopyWithImpl<$Res, $Val extends PaymentFieldModel>
    implements $PaymentFieldModelCopyWith<$Res> {
  _$PaymentFieldModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? label = null,
    Object? type = freezed,
    Object? placeholder = freezed,
    Object? required = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentFieldModelImplCopyWith<$Res>
    implements $PaymentFieldModelCopyWith<$Res> {
  factory _$$PaymentFieldModelImplCopyWith(_$PaymentFieldModelImpl value,
          $Res Function(_$PaymentFieldModelImpl) then) =
      __$$PaymentFieldModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String label,
      String? type,
      String? placeholder,
      bool required});
}

/// @nodoc
class __$$PaymentFieldModelImplCopyWithImpl<$Res>
    extends _$PaymentFieldModelCopyWithImpl<$Res, _$PaymentFieldModelImpl>
    implements _$$PaymentFieldModelImplCopyWith<$Res> {
  __$$PaymentFieldModelImplCopyWithImpl(_$PaymentFieldModelImpl _value,
      $Res Function(_$PaymentFieldModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? label = null,
    Object? type = freezed,
    Object? placeholder = freezed,
    Object? required = null,
  }) {
    return _then(_$PaymentFieldModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentFieldModelImpl implements _PaymentFieldModel {
  const _$PaymentFieldModelImpl(
      {required this.name,
      required this.label,
      this.type,
      this.placeholder,
      this.required = false});

  factory _$PaymentFieldModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentFieldModelImplFromJson(json);

  @override
  final String name;
  @override
  final String label;
  @override
  final String? type;
// text, number, password
  @override
  final String? placeholder;
  @override
  @JsonKey()
  final bool required;

  @override
  String toString() {
    return 'PaymentFieldModel(name: $name, label: $label, type: $type, placeholder: $placeholder, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentFieldModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.required, required) ||
                other.required == required));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, label, type, placeholder, required);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentFieldModelImplCopyWith<_$PaymentFieldModelImpl> get copyWith =>
      __$$PaymentFieldModelImplCopyWithImpl<_$PaymentFieldModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentFieldModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentFieldModel implements PaymentFieldModel {
  const factory _PaymentFieldModel(
      {required final String name,
      required final String label,
      final String? type,
      final String? placeholder,
      final bool required}) = _$PaymentFieldModelImpl;

  factory _PaymentFieldModel.fromJson(Map<String, dynamic> json) =
      _$PaymentFieldModelImpl.fromJson;

  @override
  String get name;
  @override
  String get label;
  @override
  String? get type;
  @override // text, number, password
  String? get placeholder;
  @override
  bool get required;
  @override
  @JsonKey(ignore: true)
  _$$PaymentFieldModelImplCopyWith<_$PaymentFieldModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
