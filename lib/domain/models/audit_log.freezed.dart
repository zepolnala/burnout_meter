// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) {
  return _AuditLog.fromJson(json);
}

/// @nodoc
mixin _$AuditLog {
  String get id => throw _privateConstructorUsedError;
  String get actorUserId =>
      throw _privateConstructorUsedError; // User making the access
  String get actorRole =>
      throw _privateConstructorUsedError; // Role of the actor
  String get actionType =>
      throw _privateConstructorUsedError; // 'read_score_detail', 'read_team_aggregates', 'create_action', 'update_consent'
  String get orgId => throw _privateConstructorUsedError;
  String? get targetUserId =>
      throw _privateConstructorUsedError; // Whose data was accessed (if individual)
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuditLogCopyWith<AuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogCopyWith<$Res> {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) then) =
      _$AuditLogCopyWithImpl<$Res, AuditLog>;
  @useResult
  $Res call(
      {String id,
      String actorUserId,
      String actorRole,
      String actionType,
      String orgId,
      String? targetUserId,
      DateTime timestamp,
      String? details});
}

/// @nodoc
class _$AuditLogCopyWithImpl<$Res, $Val extends AuditLog>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUserId = null,
    Object? actorRole = null,
    Object? actionType = null,
    Object? orgId = null,
    Object? targetUserId = freezed,
    Object? timestamp = null,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorUserId: null == actorUserId
          ? _value.actorUserId
          : actorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: freezed == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogImplCopyWith<$Res>
    implements $AuditLogCopyWith<$Res> {
  factory _$$AuditLogImplCopyWith(
          _$AuditLogImpl value, $Res Function(_$AuditLogImpl) then) =
      __$$AuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String actorUserId,
      String actorRole,
      String actionType,
      String orgId,
      String? targetUserId,
      DateTime timestamp,
      String? details});
}

/// @nodoc
class __$$AuditLogImplCopyWithImpl<$Res>
    extends _$AuditLogCopyWithImpl<$Res, _$AuditLogImpl>
    implements _$$AuditLogImplCopyWith<$Res> {
  __$$AuditLogImplCopyWithImpl(
      _$AuditLogImpl _value, $Res Function(_$AuditLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUserId = null,
    Object? actorRole = null,
    Object? actionType = null,
    Object? orgId = null,
    Object? targetUserId = freezed,
    Object? timestamp = null,
    Object? details = freezed,
  }) {
    return _then(_$AuditLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorUserId: null == actorUserId
          ? _value.actorUserId
          : actorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: freezed == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogImpl implements _AuditLog {
  const _$AuditLogImpl(
      {required this.id,
      required this.actorUserId,
      required this.actorRole,
      required this.actionType,
      required this.orgId,
      this.targetUserId,
      required this.timestamp,
      this.details});

  factory _$AuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogImplFromJson(json);

  @override
  final String id;
  @override
  final String actorUserId;
// User making the access
  @override
  final String actorRole;
// Role of the actor
  @override
  final String actionType;
// 'read_score_detail', 'read_team_aggregates', 'create_action', 'update_consent'
  @override
  final String orgId;
  @override
  final String? targetUserId;
// Whose data was accessed (if individual)
  @override
  final DateTime timestamp;
  @override
  final String? details;

  @override
  String toString() {
    return 'AuditLog(id: $id, actorUserId: $actorUserId, actorRole: $actorRole, actionType: $actionType, orgId: $orgId, targetUserId: $targetUserId, timestamp: $timestamp, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorUserId, actorUserId) ||
                other.actorUserId == actorUserId) &&
            (identical(other.actorRole, actorRole) ||
                other.actorRole == actorRole) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, actorUserId, actorRole,
      actionType, orgId, targetUserId, timestamp, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      __$$AuditLogImplCopyWithImpl<_$AuditLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogImplToJson(
      this,
    );
  }
}

abstract class _AuditLog implements AuditLog {
  const factory _AuditLog(
      {required final String id,
      required final String actorUserId,
      required final String actorRole,
      required final String actionType,
      required final String orgId,
      final String? targetUserId,
      required final DateTime timestamp,
      final String? details}) = _$AuditLogImpl;

  factory _AuditLog.fromJson(Map<String, dynamic> json) =
      _$AuditLogImpl.fromJson;

  @override
  String get id;
  @override
  String get actorUserId;
  @override // User making the access
  String get actorRole;
  @override // Role of the actor
  String get actionType;
  @override // 'read_score_detail', 'read_team_aggregates', 'create_action', 'update_consent'
  String get orgId;
  @override
  String? get targetUserId;
  @override // Whose data was accessed (if individual)
  DateTime get timestamp;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
