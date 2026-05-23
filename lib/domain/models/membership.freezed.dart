// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Membership _$MembershipFromJson(Map<String, dynamic> json) {
  return _Membership.fromJson(json);
}

/// @nodoc
mixin _$Membership {
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // 'employee', 'manager', 'admin'
  String? get teamId =>
      throw _privateConstructorUsedError; // For employees (assigned to single team)
  List<String>? get managedTeamIds =>
      throw _privateConstructorUsedError; // For managers (managing list of teams)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipCopyWith<Membership> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipCopyWith<$Res> {
  factory $MembershipCopyWith(
          Membership value, $Res Function(Membership) then) =
      _$MembershipCopyWithImpl<$Res, Membership>;
  @useResult
  $Res call(
      {String userId,
      String email,
      String orgId,
      String role,
      String? teamId,
      List<String>? managedTeamIds,
      DateTime updatedAt});
}

/// @nodoc
class _$MembershipCopyWithImpl<$Res, $Val extends Membership>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? orgId = null,
    Object? role = null,
    Object? teamId = freezed,
    Object? managedTeamIds = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      managedTeamIds: freezed == managedTeamIds
          ? _value.managedTeamIds
          : managedTeamIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipImplCopyWith<$Res>
    implements $MembershipCopyWith<$Res> {
  factory _$$MembershipImplCopyWith(
          _$MembershipImpl value, $Res Function(_$MembershipImpl) then) =
      __$$MembershipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String email,
      String orgId,
      String role,
      String? teamId,
      List<String>? managedTeamIds,
      DateTime updatedAt});
}

/// @nodoc
class __$$MembershipImplCopyWithImpl<$Res>
    extends _$MembershipCopyWithImpl<$Res, _$MembershipImpl>
    implements _$$MembershipImplCopyWith<$Res> {
  __$$MembershipImplCopyWithImpl(
      _$MembershipImpl _value, $Res Function(_$MembershipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? orgId = null,
    Object? role = null,
    Object? teamId = freezed,
    Object? managedTeamIds = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$MembershipImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      managedTeamIds: freezed == managedTeamIds
          ? _value._managedTeamIds
          : managedTeamIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipImpl implements _Membership {
  const _$MembershipImpl(
      {required this.userId,
      required this.email,
      required this.orgId,
      required this.role,
      this.teamId,
      final List<String>? managedTeamIds,
      required this.updatedAt})
      : _managedTeamIds = managedTeamIds;

  factory _$MembershipImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipImplFromJson(json);

  @override
  final String userId;
  @override
  final String email;
  @override
  final String orgId;
  @override
  final String role;
// 'employee', 'manager', 'admin'
  @override
  final String? teamId;
// For employees (assigned to single team)
  final List<String>? _managedTeamIds;
// For employees (assigned to single team)
  @override
  List<String>? get managedTeamIds {
    final value = _managedTeamIds;
    if (value == null) return null;
    if (_managedTeamIds is EqualUnmodifiableListView) return _managedTeamIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// For managers (managing list of teams)
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Membership(userId: $userId, email: $email, orgId: $orgId, role: $role, teamId: $teamId, managedTeamIds: $managedTeamIds, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            const DeepCollectionEquality()
                .equals(other._managedTeamIds, _managedTeamIds) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, email, orgId, role,
      teamId, const DeepCollectionEquality().hash(_managedTeamIds), updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipImplCopyWith<_$MembershipImpl> get copyWith =>
      __$$MembershipImplCopyWithImpl<_$MembershipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipImplToJson(
      this,
    );
  }
}

abstract class _Membership implements Membership {
  const factory _Membership(
      {required final String userId,
      required final String email,
      required final String orgId,
      required final String role,
      final String? teamId,
      final List<String>? managedTeamIds,
      required final DateTime updatedAt}) = _$MembershipImpl;

  factory _Membership.fromJson(Map<String, dynamic> json) =
      _$MembershipImpl.fromJson;

  @override
  String get userId;
  @override
  String get email;
  @override
  String get orgId;
  @override
  String get role;
  @override // 'employee', 'manager', 'admin'
  String? get teamId;
  @override // For employees (assigned to single team)
  List<String>? get managedTeamIds;
  @override // For managers (managing list of teams)
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MembershipImplCopyWith<_$MembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
