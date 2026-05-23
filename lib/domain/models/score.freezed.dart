// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Subscores _$SubscoresFromJson(Map<String, dynamic> json) {
  return _Subscores.fromJson(json);
}

/// @nodoc
mixin _$Subscores {
  double get sleep =>
      throw _privateConstructorUsedError; // 0-100 derived sleep score
  double get recovery =>
      throw _privateConstructorUsedError; // 0-100 recovery score (based on HRV)
  double get stress => throw _privateConstructorUsedError; // 0-100 stress index
  double get load => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubscoresCopyWith<Subscores> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscoresCopyWith<$Res> {
  factory $SubscoresCopyWith(Subscores value, $Res Function(Subscores) then) =
      _$SubscoresCopyWithImpl<$Res, Subscores>;
  @useResult
  $Res call({double sleep, double recovery, double stress, double load});
}

/// @nodoc
class _$SubscoresCopyWithImpl<$Res, $Val extends Subscores>
    implements $SubscoresCopyWith<$Res> {
  _$SubscoresCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleep = null,
    Object? recovery = null,
    Object? stress = null,
    Object? load = null,
  }) {
    return _then(_value.copyWith(
      sleep: null == sleep
          ? _value.sleep
          : sleep // ignore: cast_nullable_to_non_nullable
              as double,
      recovery: null == recovery
          ? _value.recovery
          : recovery // ignore: cast_nullable_to_non_nullable
              as double,
      stress: null == stress
          ? _value.stress
          : stress // ignore: cast_nullable_to_non_nullable
              as double,
      load: null == load
          ? _value.load
          : load // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscoresImplCopyWith<$Res>
    implements $SubscoresCopyWith<$Res> {
  factory _$$SubscoresImplCopyWith(
          _$SubscoresImpl value, $Res Function(_$SubscoresImpl) then) =
      __$$SubscoresImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double sleep, double recovery, double stress, double load});
}

/// @nodoc
class __$$SubscoresImplCopyWithImpl<$Res>
    extends _$SubscoresCopyWithImpl<$Res, _$SubscoresImpl>
    implements _$$SubscoresImplCopyWith<$Res> {
  __$$SubscoresImplCopyWithImpl(
      _$SubscoresImpl _value, $Res Function(_$SubscoresImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleep = null,
    Object? recovery = null,
    Object? stress = null,
    Object? load = null,
  }) {
    return _then(_$SubscoresImpl(
      sleep: null == sleep
          ? _value.sleep
          : sleep // ignore: cast_nullable_to_non_nullable
              as double,
      recovery: null == recovery
          ? _value.recovery
          : recovery // ignore: cast_nullable_to_non_nullable
              as double,
      stress: null == stress
          ? _value.stress
          : stress // ignore: cast_nullable_to_non_nullable
              as double,
      load: null == load
          ? _value.load
          : load // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscoresImpl implements _Subscores {
  const _$SubscoresImpl(
      {required this.sleep,
      required this.recovery,
      required this.stress,
      required this.load});

  factory _$SubscoresImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscoresImplFromJson(json);

  @override
  final double sleep;
// 0-100 derived sleep score
  @override
  final double recovery;
// 0-100 recovery score (based on HRV)
  @override
  final double stress;
// 0-100 stress index
  @override
  final double load;

  @override
  String toString() {
    return 'Subscores(sleep: $sleep, recovery: $recovery, stress: $stress, load: $load)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscoresImpl &&
            (identical(other.sleep, sleep) || other.sleep == sleep) &&
            (identical(other.recovery, recovery) ||
                other.recovery == recovery) &&
            (identical(other.stress, stress) || other.stress == stress) &&
            (identical(other.load, load) || other.load == load));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sleep, recovery, stress, load);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscoresImplCopyWith<_$SubscoresImpl> get copyWith =>
      __$$SubscoresImplCopyWithImpl<_$SubscoresImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscoresImplToJson(
      this,
    );
  }
}

abstract class _Subscores implements Subscores {
  const factory _Subscores(
      {required final double sleep,
      required final double recovery,
      required final double stress,
      required final double load}) = _$SubscoresImpl;

  factory _Subscores.fromJson(Map<String, dynamic> json) =
      _$SubscoresImpl.fromJson;

  @override
  double get sleep;
  @override // 0-100 derived sleep score
  double get recovery;
  @override // 0-100 recovery score (based on HRV)
  double get stress;
  @override // 0-100 stress index
  double get load;
  @override
  @JsonKey(ignore: true)
  _$$SubscoresImplCopyWith<_$SubscoresImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Score _$ScoreFromJson(Map<String, dynamic> json) {
  return _Score.fromJson(json);
}

/// @nodoc
mixin _$Score {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  double get burnoutIndex =>
      throw _privateConstructorUsedError; // 0-100 overall score
  Subscores get subscores => throw _privateConstructorUsedError; // desglosado
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res, Score>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String orgId,
      String teamId,
      double burnoutIndex,
      Subscores subscores,
      DateTime calculatedAt});

  $SubscoresCopyWith<$Res> get subscores;
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res, $Val extends Score>
    implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orgId = null,
    Object? teamId = null,
    Object? burnoutIndex = null,
    Object? subscores = null,
    Object? calculatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      burnoutIndex: null == burnoutIndex
          ? _value.burnoutIndex
          : burnoutIndex // ignore: cast_nullable_to_non_nullable
              as double,
      subscores: null == subscores
          ? _value.subscores
          : subscores // ignore: cast_nullable_to_non_nullable
              as Subscores,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SubscoresCopyWith<$Res> get subscores {
    return $SubscoresCopyWith<$Res>(_value.subscores, (value) {
      return _then(_value.copyWith(subscores: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScoreImplCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$ScoreImplCopyWith(
          _$ScoreImpl value, $Res Function(_$ScoreImpl) then) =
      __$$ScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String orgId,
      String teamId,
      double burnoutIndex,
      Subscores subscores,
      DateTime calculatedAt});

  @override
  $SubscoresCopyWith<$Res> get subscores;
}

/// @nodoc
class __$$ScoreImplCopyWithImpl<$Res>
    extends _$ScoreCopyWithImpl<$Res, _$ScoreImpl>
    implements _$$ScoreImplCopyWith<$Res> {
  __$$ScoreImplCopyWithImpl(
      _$ScoreImpl _value, $Res Function(_$ScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orgId = null,
    Object? teamId = null,
    Object? burnoutIndex = null,
    Object? subscores = null,
    Object? calculatedAt = null,
  }) {
    return _then(_$ScoreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      burnoutIndex: null == burnoutIndex
          ? _value.burnoutIndex
          : burnoutIndex // ignore: cast_nullable_to_non_nullable
              as double,
      subscores: null == subscores
          ? _value.subscores
          : subscores // ignore: cast_nullable_to_non_nullable
              as Subscores,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreImpl implements _Score {
  const _$ScoreImpl(
      {required this.id,
      required this.userId,
      required this.orgId,
      required this.teamId,
      required this.burnoutIndex,
      required this.subscores,
      required this.calculatedAt});

  factory _$ScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String orgId;
  @override
  final String teamId;
  @override
  final double burnoutIndex;
// 0-100 overall score
  @override
  final Subscores subscores;
// desglosado
  @override
  final DateTime calculatedAt;

  @override
  String toString() {
    return 'Score(id: $id, userId: $userId, orgId: $orgId, teamId: $teamId, burnoutIndex: $burnoutIndex, subscores: $subscores, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.burnoutIndex, burnoutIndex) ||
                other.burnoutIndex == burnoutIndex) &&
            (identical(other.subscores, subscores) ||
                other.subscores == subscores) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, orgId, teamId,
      burnoutIndex, subscores, calculatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      __$$ScoreImplCopyWithImpl<_$ScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreImplToJson(
      this,
    );
  }
}

abstract class _Score implements Score {
  const factory _Score(
      {required final String id,
      required final String userId,
      required final String orgId,
      required final String teamId,
      required final double burnoutIndex,
      required final Subscores subscores,
      required final DateTime calculatedAt}) = _$ScoreImpl;

  factory _Score.fromJson(Map<String, dynamic> json) = _$ScoreImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get orgId;
  @override
  String get teamId;
  @override
  double get burnoutIndex;
  @override // 0-100 overall score
  Subscores get subscores;
  @override // desglosado
  DateTime get calculatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
