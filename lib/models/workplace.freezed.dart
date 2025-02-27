// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workplace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workplace _$WorkplaceFromJson(Map<String, dynamic> json) {
  return _Workplace.fromJson(json);
}

/// @nodoc
mixin _$Workplace {
  String get name => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;

  /// Serializes this Workplace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workplace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkplaceCopyWith<Workplace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkplaceCopyWith<$Res> {
  factory $WorkplaceCopyWith(Workplace value, $Res Function(Workplace) then) =
      _$WorkplaceCopyWithImpl<$Res, Workplace>;
  @useResult
  $Res call({String name, String city});
}

/// @nodoc
class _$WorkplaceCopyWithImpl<$Res, $Val extends Workplace>
    implements $WorkplaceCopyWith<$Res> {
  _$WorkplaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workplace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? city = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkplaceImplCopyWith<$Res>
    implements $WorkplaceCopyWith<$Res> {
  factory _$$WorkplaceImplCopyWith(
          _$WorkplaceImpl value, $Res Function(_$WorkplaceImpl) then) =
      __$$WorkplaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String city});
}

/// @nodoc
class __$$WorkplaceImplCopyWithImpl<$Res>
    extends _$WorkplaceCopyWithImpl<$Res, _$WorkplaceImpl>
    implements _$$WorkplaceImplCopyWith<$Res> {
  __$$WorkplaceImplCopyWithImpl(
      _$WorkplaceImpl _value, $Res Function(_$WorkplaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Workplace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? city = null,
  }) {
    return _then(_$WorkplaceImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkplaceImpl implements _Workplace {
  const _$WorkplaceImpl({required this.name, required this.city});

  factory _$WorkplaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkplaceImplFromJson(json);

  @override
  final String name;
  @override
  final String city;

  @override
  String toString() {
    return 'Workplace(name: $name, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkplaceImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, city);

  /// Create a copy of Workplace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkplaceImplCopyWith<_$WorkplaceImpl> get copyWith =>
      __$$WorkplaceImplCopyWithImpl<_$WorkplaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkplaceImplToJson(
      this,
    );
  }
}

abstract class _Workplace implements Workplace {
  const factory _Workplace(
      {required final String name,
      required final String city}) = _$WorkplaceImpl;

  factory _Workplace.fromJson(Map<String, dynamic> json) =
      _$WorkplaceImpl.fromJson;

  @override
  String get name;
  @override
  String get city;

  /// Create a copy of Workplace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkplaceImplCopyWith<_$WorkplaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
