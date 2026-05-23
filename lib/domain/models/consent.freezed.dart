// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Consent _$ConsentFromJson(Map<String, dynamic> json) {
  return _Consent.fromJson(json);
}

/// @nodoc
mixin _$Consent {
  String get userId => throw _privateConstructorUsedError;
  bool get sharingEnabled =>
      throw _privateConstructorUsedError; // Enable sharing of calculated scores
  bool get actionsEnabled =>
      throw _privateConstructorUsedError; // Enable receiving manager/admin actions
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConsentCopyWith<Consent> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsentCopyWith<$Res> {
  factory $ConsentCopyWith(Consent value, $Res Function(Consent) then) =
      _$ConsentCopyWithImpl<$Res, Consent>;
  @useResult
  $Res call(
      {String userId,
      bool sharingEnabled,
      bool actionsEnabled,
      DateTime updatedAt});
}

/// @nodoc
class _$ConsentCopyWithImpl<$Res, $Val extends Consent>
    implements $ConsentCopyWith<$Res> {
  _$ConsentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sharingEnabled = null,
    Object? actionsEnabled = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sharingEnabled: null == sharingEnabled
          ? _value.sharingEnabled
          : sharingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      actionsEnabled: null == actionsEnabled
          ? _value.actionsEnabled
          : actionsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsentImplCopyWith<$Res> implements $ConsentCopyWith<$Res> {
  factory _$$ConsentImplCopyWith(
          _$ConsentImpl value, $Res Function(_$ConsentImpl) then) =
      __$$ConsentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool sharingEnabled,
      bool actionsEnabled,
      DateTime updatedAt});
}

/// @nodoc
class __$$ConsentImplCopyWithImpl<$Res>
    extends _$ConsentCopyWithImpl<$Res, _$ConsentImpl>
    implements _$$ConsentImplCopyWith<$Res> {
  __$$ConsentImplCopyWithImpl(
      _$ConsentImpl _value, $Res Function(_$ConsentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sharingEnabled = null,
    Object? actionsEnabled = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ConsentImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sharingEnabled: null == sharingEnabled
          ? _value.sharingEnabled
          : sharingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      actionsEnabled: null == actionsEnabled
          ? _value.actionsEnabled
          : actionsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsentImpl implements _Consent {
  const _$ConsentImpl(
      {required this.userId,
      required this.sharingEnabled,
      required this.actionsEnabled,
      required this.updatedAt});

  factory _$ConsentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsentImplFromJson(json);

  @override
  final String userId;
  @override
  final bool sharingEnabled;
// Enable sharing of calculated scores
  @override
  final bool actionsEnabled;
// Enable receiving manager/admin actions
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Consent(userId: $userId, sharingEnabled: $sharingEnabled, actionsEnabled: $actionsEnabled, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsentImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sharingEnabled, sharingEnabled) ||
                other.sharingEnabled == sharingEnabled) &&
            (identical(other.actionsEnabled, actionsEnabled) ||
                other.actionsEnabled == actionsEnabled) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, sharingEnabled, actionsEnabled, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsentImplCopyWith<_$ConsentImpl> get copyWith =>
      __$$ConsentImplCopyWithImpl<_$ConsentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsentImplToJson(
      this,
    );
  }
}

abstract class _Consent implements Consent {
  const factory _Consent(
      {required final String userId,
      required final bool sharingEnabled,
      required final bool actionsEnabled,
      required final DateTime updatedAt}) = _$ConsentImpl;

  factory _Consent.fromJson(Map<String, dynamic> json) = _$ConsentImpl.fromJson;

  @override
  String get userId;
  @override
  bool get sharingEnabled;
  @override // Enable sharing of calculated scores
  bool get actionsEnabled;
  @override // Enable receiving manager/admin actions
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ConsentImplCopyWith<_$ConsentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
