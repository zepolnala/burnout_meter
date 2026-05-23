// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActionTemplate _$ActionTemplateFromJson(Map<String, dynamic> json) {
  return _ActionTemplate.fromJson(json);
}

/// @nodoc
mixin _$ActionTemplate {
  String get type =>
      throw _privateConstructorUsedError; // 'suggest_break', 'offer_1on1', 'share_resource', 'recommend_time_off', 'wellness_check'
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get defaultPayload =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionTemplateCopyWith<ActionTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionTemplateCopyWith<$Res> {
  factory $ActionTemplateCopyWith(
          ActionTemplate value, $Res Function(ActionTemplate) then) =
      _$ActionTemplateCopyWithImpl<$Res, ActionTemplate>;
  @useResult
  $Res call(
      {String type,
      String title,
      String description,
      Map<String, dynamic>? defaultPayload});
}

/// @nodoc
class _$ActionTemplateCopyWithImpl<$Res, $Val extends ActionTemplate>
    implements $ActionTemplateCopyWith<$Res> {
  _$ActionTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? defaultPayload = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      defaultPayload: freezed == defaultPayload
          ? _value.defaultPayload
          : defaultPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionTemplateImplCopyWith<$Res>
    implements $ActionTemplateCopyWith<$Res> {
  factory _$$ActionTemplateImplCopyWith(_$ActionTemplateImpl value,
          $Res Function(_$ActionTemplateImpl) then) =
      __$$ActionTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String title,
      String description,
      Map<String, dynamic>? defaultPayload});
}

/// @nodoc
class __$$ActionTemplateImplCopyWithImpl<$Res>
    extends _$ActionTemplateCopyWithImpl<$Res, _$ActionTemplateImpl>
    implements _$$ActionTemplateImplCopyWith<$Res> {
  __$$ActionTemplateImplCopyWithImpl(
      _$ActionTemplateImpl _value, $Res Function(_$ActionTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? defaultPayload = freezed,
  }) {
    return _then(_$ActionTemplateImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      defaultPayload: freezed == defaultPayload
          ? _value._defaultPayload
          : defaultPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionTemplateImpl implements _ActionTemplate {
  const _$ActionTemplateImpl(
      {required this.type,
      required this.title,
      required this.description,
      final Map<String, dynamic>? defaultPayload})
      : _defaultPayload = defaultPayload;

  factory _$ActionTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionTemplateImplFromJson(json);

  @override
  final String type;
// 'suggest_break', 'offer_1on1', 'share_resource', 'recommend_time_off', 'wellness_check'
  @override
  final String title;
  @override
  final String description;
  final Map<String, dynamic>? _defaultPayload;
  @override
  Map<String, dynamic>? get defaultPayload {
    final value = _defaultPayload;
    if (value == null) return null;
    if (_defaultPayload is EqualUnmodifiableMapView) return _defaultPayload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ActionTemplate(type: $type, title: $title, description: $description, defaultPayload: $defaultPayload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionTemplateImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._defaultPayload, _defaultPayload));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, title, description,
      const DeepCollectionEquality().hash(_defaultPayload));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionTemplateImplCopyWith<_$ActionTemplateImpl> get copyWith =>
      __$$ActionTemplateImplCopyWithImpl<_$ActionTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionTemplateImplToJson(
      this,
    );
  }
}

abstract class _ActionTemplate implements ActionTemplate {
  const factory _ActionTemplate(
      {required final String type,
      required final String title,
      required final String description,
      final Map<String, dynamic>? defaultPayload}) = _$ActionTemplateImpl;

  factory _ActionTemplate.fromJson(Map<String, dynamic> json) =
      _$ActionTemplateImpl.fromJson;

  @override
  String get type;
  @override // 'suggest_break', 'offer_1on1', 'share_resource', 'recommend_time_off', 'wellness_check'
  String get title;
  @override
  String get description;
  @override
  Map<String, dynamic>? get defaultPayload;
  @override
  @JsonKey(ignore: true)
  _$$ActionTemplateImplCopyWith<_$ActionTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionInstance _$ActionInstanceFromJson(Map<String, dynamic> json) {
  return _ActionInstance.fromJson(json);
}

/// @nodoc
mixin _$ActionInstance {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // matches ActionTemplate.type
  String get targetUserId => throw _privateConstructorUsedError;
  String get senderUserId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'sent', 'received', 'acknowledged', 'dismissed'
  Map<String, dynamic>? get payload =>
      throw _privateConstructorUsedError; // e.g. { 'resourceLink': '...', 'notes': '...' }
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionInstanceCopyWith<ActionInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionInstanceCopyWith<$Res> {
  factory $ActionInstanceCopyWith(
          ActionInstance value, $Res Function(ActionInstance) then) =
      _$ActionInstanceCopyWithImpl<$Res, ActionInstance>;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String teamId,
      String type,
      String targetUserId,
      String senderUserId,
      String status,
      Map<String, dynamic>? payload,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ActionInstanceCopyWithImpl<$Res, $Val extends ActionInstance>
    implements $ActionInstanceCopyWith<$Res> {
  _$ActionInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? teamId = null,
    Object? type = null,
    Object? targetUserId = null,
    Object? senderUserId = null,
    Object? status = null,
    Object? payload = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
      senderUserId: null == senderUserId
          ? _value.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionInstanceImplCopyWith<$Res>
    implements $ActionInstanceCopyWith<$Res> {
  factory _$$ActionInstanceImplCopyWith(_$ActionInstanceImpl value,
          $Res Function(_$ActionInstanceImpl) then) =
      __$$ActionInstanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String teamId,
      String type,
      String targetUserId,
      String senderUserId,
      String status,
      Map<String, dynamic>? payload,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ActionInstanceImplCopyWithImpl<$Res>
    extends _$ActionInstanceCopyWithImpl<$Res, _$ActionInstanceImpl>
    implements _$$ActionInstanceImplCopyWith<$Res> {
  __$$ActionInstanceImplCopyWithImpl(
      _$ActionInstanceImpl _value, $Res Function(_$ActionInstanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? teamId = null,
    Object? type = null,
    Object? targetUserId = null,
    Object? senderUserId = null,
    Object? status = null,
    Object? payload = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ActionInstanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
      senderUserId: null == senderUserId
          ? _value.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionInstanceImpl implements _ActionInstance {
  const _$ActionInstanceImpl(
      {required this.id,
      required this.orgId,
      required this.teamId,
      required this.type,
      required this.targetUserId,
      required this.senderUserId,
      required this.status,
      final Map<String, dynamic>? payload,
      required this.createdAt,
      required this.updatedAt})
      : _payload = payload;

  factory _$ActionInstanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionInstanceImplFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String teamId;
  @override
  final String type;
// matches ActionTemplate.type
  @override
  final String targetUserId;
  @override
  final String senderUserId;
  @override
  final String status;
// 'sent', 'received', 'acknowledged', 'dismissed'
  final Map<String, dynamic>? _payload;
// 'sent', 'received', 'acknowledged', 'dismissed'
  @override
  Map<String, dynamic>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// e.g. { 'resourceLink': '...', 'notes': '...' }
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ActionInstance(id: $id, orgId: $orgId, teamId: $teamId, type: $type, targetUserId: $targetUserId, senderUserId: $senderUserId, status: $status, payload: $payload, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionInstanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.senderUserId, senderUserId) ||
                other.senderUserId == senderUserId) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      teamId,
      type,
      targetUserId,
      senderUserId,
      status,
      const DeepCollectionEquality().hash(_payload),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionInstanceImplCopyWith<_$ActionInstanceImpl> get copyWith =>
      __$$ActionInstanceImplCopyWithImpl<_$ActionInstanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionInstanceImplToJson(
      this,
    );
  }
}

abstract class _ActionInstance implements ActionInstance {
  const factory _ActionInstance(
      {required final String id,
      required final String orgId,
      required final String teamId,
      required final String type,
      required final String targetUserId,
      required final String senderUserId,
      required final String status,
      final Map<String, dynamic>? payload,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ActionInstanceImpl;

  factory _ActionInstance.fromJson(Map<String, dynamic> json) =
      _$ActionInstanceImpl.fromJson;

  @override
  String get id;
  @override
  String get orgId;
  @override
  String get teamId;
  @override
  String get type;
  @override // matches ActionTemplate.type
  String get targetUserId;
  @override
  String get senderUserId;
  @override
  String get status;
  @override // 'sent', 'received', 'acknowledged', 'dismissed'
  Map<String, dynamic>? get payload;
  @override // e.g. { 'resourceLink': '...', 'notes': '...' }
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ActionInstanceImplCopyWith<_$ActionInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
