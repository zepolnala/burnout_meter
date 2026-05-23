// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthSample _$HealthSampleFromJson(Map<String, dynamic> json) {
  return _HealthSample.fromJson(json);
}

/// @nodoc
mixin _$HealthSample {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'heart_rate', 'hrv', 'sleep_duration', 'respiratory_rate'
  double get value => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get deviceSource => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthSampleCopyWith<HealthSample> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthSampleCopyWith<$Res> {
  factory $HealthSampleCopyWith(
          HealthSample value, $Res Function(HealthSample) then) =
      _$HealthSampleCopyWithImpl<$Res, HealthSample>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      double value,
      DateTime timestamp,
      String deviceSource});
}

/// @nodoc
class _$HealthSampleCopyWithImpl<$Res, $Val extends HealthSample>
    implements $HealthSampleCopyWith<$Res> {
  _$HealthSampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? value = null,
    Object? timestamp = null,
    Object? deviceSource = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deviceSource: null == deviceSource
          ? _value.deviceSource
          : deviceSource // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthSampleImplCopyWith<$Res>
    implements $HealthSampleCopyWith<$Res> {
  factory _$$HealthSampleImplCopyWith(
          _$HealthSampleImpl value, $Res Function(_$HealthSampleImpl) then) =
      __$$HealthSampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      double value,
      DateTime timestamp,
      String deviceSource});
}

/// @nodoc
class __$$HealthSampleImplCopyWithImpl<$Res>
    extends _$HealthSampleCopyWithImpl<$Res, _$HealthSampleImpl>
    implements _$$HealthSampleImplCopyWith<$Res> {
  __$$HealthSampleImplCopyWithImpl(
      _$HealthSampleImpl _value, $Res Function(_$HealthSampleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? value = null,
    Object? timestamp = null,
    Object? deviceSource = null,
  }) {
    return _then(_$HealthSampleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deviceSource: null == deviceSource
          ? _value.deviceSource
          : deviceSource // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthSampleImpl implements _HealthSample {
  const _$HealthSampleImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.value,
      required this.timestamp,
      required this.deviceSource});

  factory _$HealthSampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthSampleImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String type;
// 'heart_rate', 'hrv', 'sleep_duration', 'respiratory_rate'
  @override
  final double value;
  @override
  final DateTime timestamp;
  @override
  final String deviceSource;

  @override
  String toString() {
    return 'HealthSample(id: $id, userId: $userId, type: $type, value: $value, timestamp: $timestamp, deviceSource: $deviceSource)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthSampleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.deviceSource, deviceSource) ||
                other.deviceSource == deviceSource));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, type, value, timestamp, deviceSource);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthSampleImplCopyWith<_$HealthSampleImpl> get copyWith =>
      __$$HealthSampleImplCopyWithImpl<_$HealthSampleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthSampleImplToJson(
      this,
    );
  }
}

abstract class _HealthSample implements HealthSample {
  const factory _HealthSample(
      {required final String id,
      required final String userId,
      required final String type,
      required final double value,
      required final DateTime timestamp,
      required final String deviceSource}) = _$HealthSampleImpl;

  factory _HealthSample.fromJson(Map<String, dynamic> json) =
      _$HealthSampleImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get type;
  @override // 'heart_rate', 'hrv', 'sleep_duration', 'respiratory_rate'
  double get value;
  @override
  DateTime get timestamp;
  @override
  String get deviceSource;
  @override
  @JsonKey(ignore: true)
  _$$HealthSampleImplCopyWith<_$HealthSampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
