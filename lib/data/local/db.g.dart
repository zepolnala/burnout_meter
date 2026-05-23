// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $LocalHealthSamplesTable extends LocalHealthSamples
    with TableInfo<$LocalHealthSamplesTable, LocalHealthSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalHealthSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deviceSourceMeta =
      const VerificationMeta('deviceSource');
  @override
  late final GeneratedColumn<String> deviceSource = GeneratedColumn<String>(
      'device_source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, type, value, timestamp, deviceSource];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_health_samples';
  @override
  VerificationContext validateIntegrity(Insertable<LocalHealthSample> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('device_source')) {
      context.handle(
          _deviceSourceMeta,
          deviceSource.isAcceptableOrUnknown(
              data['device_source']!, _deviceSourceMeta));
    } else if (isInserting) {
      context.missing(_deviceSourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalHealthSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalHealthSample(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      deviceSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_source'])!,
    );
  }

  @override
  $LocalHealthSamplesTable createAlias(String alias) {
    return $LocalHealthSamplesTable(attachedDatabase, alias);
  }
}

class LocalHealthSample extends DataClass
    implements Insertable<LocalHealthSample> {
  final String id;
  final String userId;
  final String type;
  final double value;
  final DateTime timestamp;
  final String deviceSource;
  const LocalHealthSample(
      {required this.id,
      required this.userId,
      required this.type,
      required this.value,
      required this.timestamp,
      required this.deviceSource});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<double>(value);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['device_source'] = Variable<String>(deviceSource);
    return map;
  }

  LocalHealthSamplesCompanion toCompanion(bool nullToAbsent) {
    return LocalHealthSamplesCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      value: Value(value),
      timestamp: Value(timestamp),
      deviceSource: Value(deviceSource),
    );
  }

  factory LocalHealthSample.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalHealthSample(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<double>(json['value']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      deviceSource: serializer.fromJson<String>(json['deviceSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<double>(value),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'deviceSource': serializer.toJson<String>(deviceSource),
    };
  }

  LocalHealthSample copyWith(
          {String? id,
          String? userId,
          String? type,
          double? value,
          DateTime? timestamp,
          String? deviceSource}) =>
      LocalHealthSample(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        value: value ?? this.value,
        timestamp: timestamp ?? this.timestamp,
        deviceSource: deviceSource ?? this.deviceSource,
      );
  LocalHealthSample copyWithCompanion(LocalHealthSamplesCompanion data) {
    return LocalHealthSample(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      deviceSource: data.deviceSource.present
          ? data.deviceSource.value
          : this.deviceSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalHealthSample(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('deviceSource: $deviceSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, type, value, timestamp, deviceSource);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalHealthSample &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.value == this.value &&
          other.timestamp == this.timestamp &&
          other.deviceSource == this.deviceSource);
}

class LocalHealthSamplesCompanion extends UpdateCompanion<LocalHealthSample> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> type;
  final Value<double> value;
  final Value<DateTime> timestamp;
  final Value<String> deviceSource;
  final Value<int> rowid;
  const LocalHealthSamplesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.deviceSource = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalHealthSamplesCompanion.insert({
    required String id,
    required String userId,
    required String type,
    required double value,
    required DateTime timestamp,
    required String deviceSource,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        type = Value(type),
        value = Value(value),
        timestamp = Value(timestamp),
        deviceSource = Value(deviceSource);
  static Insertable<LocalHealthSample> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<double>? value,
    Expression<DateTime>? timestamp,
    Expression<String>? deviceSource,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
      if (deviceSource != null) 'device_source': deviceSource,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalHealthSamplesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? type,
      Value<double>? value,
      Value<DateTime>? timestamp,
      Value<String>? deviceSource,
      Value<int>? rowid}) {
    return LocalHealthSamplesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      deviceSource: deviceSource ?? this.deviceSource,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (deviceSource.present) {
      map['device_source'] = Variable<String>(deviceSource.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalHealthSamplesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('deviceSource: $deviceSource, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalScoresTable extends LocalScores
    with TableInfo<$LocalScoresTable, LocalScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
      'org_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
      'team_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _burnoutIndexMeta =
      const VerificationMeta('burnoutIndex');
  @override
  late final GeneratedColumn<double> burnoutIndex = GeneratedColumn<double>(
      'burnout_index', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sleepScoreMeta =
      const VerificationMeta('sleepScore');
  @override
  late final GeneratedColumn<double> sleepScore = GeneratedColumn<double>(
      'sleep_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _recoveryScoreMeta =
      const VerificationMeta('recoveryScore');
  @override
  late final GeneratedColumn<double> recoveryScore = GeneratedColumn<double>(
      'recovery_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stressScoreMeta =
      const VerificationMeta('stressScore');
  @override
  late final GeneratedColumn<double> stressScore = GeneratedColumn<double>(
      'stress_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _loadScoreMeta =
      const VerificationMeta('loadScore');
  @override
  late final GeneratedColumn<double> loadScore = GeneratedColumn<double>(
      'load_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _calculatedAtMeta =
      const VerificationMeta('calculatedAt');
  @override
  late final GeneratedColumn<DateTime> calculatedAt = GeneratedColumn<DateTime>(
      'calculated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        orgId,
        teamId,
        burnoutIndex,
        sleepScore,
        recoveryScore,
        stressScore,
        loadScore,
        calculatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_scores';
  @override
  VerificationContext validateIntegrity(Insertable<LocalScore> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
          _orgIdMeta, orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta));
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(_teamIdMeta,
          teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta));
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('burnout_index')) {
      context.handle(
          _burnoutIndexMeta,
          burnoutIndex.isAcceptableOrUnknown(
              data['burnout_index']!, _burnoutIndexMeta));
    } else if (isInserting) {
      context.missing(_burnoutIndexMeta);
    }
    if (data.containsKey('sleep_score')) {
      context.handle(
          _sleepScoreMeta,
          sleepScore.isAcceptableOrUnknown(
              data['sleep_score']!, _sleepScoreMeta));
    } else if (isInserting) {
      context.missing(_sleepScoreMeta);
    }
    if (data.containsKey('recovery_score')) {
      context.handle(
          _recoveryScoreMeta,
          recoveryScore.isAcceptableOrUnknown(
              data['recovery_score']!, _recoveryScoreMeta));
    } else if (isInserting) {
      context.missing(_recoveryScoreMeta);
    }
    if (data.containsKey('stress_score')) {
      context.handle(
          _stressScoreMeta,
          stressScore.isAcceptableOrUnknown(
              data['stress_score']!, _stressScoreMeta));
    } else if (isInserting) {
      context.missing(_stressScoreMeta);
    }
    if (data.containsKey('load_score')) {
      context.handle(_loadScoreMeta,
          loadScore.isAcceptableOrUnknown(data['load_score']!, _loadScoreMeta));
    } else if (isInserting) {
      context.missing(_loadScoreMeta);
    }
    if (data.containsKey('calculated_at')) {
      context.handle(
          _calculatedAtMeta,
          calculatedAt.isAcceptableOrUnknown(
              data['calculated_at']!, _calculatedAtMeta));
    } else if (isInserting) {
      context.missing(_calculatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalScore(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      orgId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}org_id'])!,
      teamId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}team_id'])!,
      burnoutIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}burnout_index'])!,
      sleepScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sleep_score'])!,
      recoveryScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}recovery_score'])!,
      stressScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stress_score'])!,
      loadScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}load_score'])!,
      calculatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}calculated_at'])!,
    );
  }

  @override
  $LocalScoresTable createAlias(String alias) {
    return $LocalScoresTable(attachedDatabase, alias);
  }
}

class LocalScore extends DataClass implements Insertable<LocalScore> {
  final String id;
  final String userId;
  final String orgId;
  final String teamId;
  final double burnoutIndex;
  final double sleepScore;
  final double recoveryScore;
  final double stressScore;
  final double loadScore;
  final DateTime calculatedAt;
  const LocalScore(
      {required this.id,
      required this.userId,
      required this.orgId,
      required this.teamId,
      required this.burnoutIndex,
      required this.sleepScore,
      required this.recoveryScore,
      required this.stressScore,
      required this.loadScore,
      required this.calculatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['org_id'] = Variable<String>(orgId);
    map['team_id'] = Variable<String>(teamId);
    map['burnout_index'] = Variable<double>(burnoutIndex);
    map['sleep_score'] = Variable<double>(sleepScore);
    map['recovery_score'] = Variable<double>(recoveryScore);
    map['stress_score'] = Variable<double>(stressScore);
    map['load_score'] = Variable<double>(loadScore);
    map['calculated_at'] = Variable<DateTime>(calculatedAt);
    return map;
  }

  LocalScoresCompanion toCompanion(bool nullToAbsent) {
    return LocalScoresCompanion(
      id: Value(id),
      userId: Value(userId),
      orgId: Value(orgId),
      teamId: Value(teamId),
      burnoutIndex: Value(burnoutIndex),
      sleepScore: Value(sleepScore),
      recoveryScore: Value(recoveryScore),
      stressScore: Value(stressScore),
      loadScore: Value(loadScore),
      calculatedAt: Value(calculatedAt),
    );
  }

  factory LocalScore.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalScore(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      orgId: serializer.fromJson<String>(json['orgId']),
      teamId: serializer.fromJson<String>(json['teamId']),
      burnoutIndex: serializer.fromJson<double>(json['burnoutIndex']),
      sleepScore: serializer.fromJson<double>(json['sleepScore']),
      recoveryScore: serializer.fromJson<double>(json['recoveryScore']),
      stressScore: serializer.fromJson<double>(json['stressScore']),
      loadScore: serializer.fromJson<double>(json['loadScore']),
      calculatedAt: serializer.fromJson<DateTime>(json['calculatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'orgId': serializer.toJson<String>(orgId),
      'teamId': serializer.toJson<String>(teamId),
      'burnoutIndex': serializer.toJson<double>(burnoutIndex),
      'sleepScore': serializer.toJson<double>(sleepScore),
      'recoveryScore': serializer.toJson<double>(recoveryScore),
      'stressScore': serializer.toJson<double>(stressScore),
      'loadScore': serializer.toJson<double>(loadScore),
      'calculatedAt': serializer.toJson<DateTime>(calculatedAt),
    };
  }

  LocalScore copyWith(
          {String? id,
          String? userId,
          String? orgId,
          String? teamId,
          double? burnoutIndex,
          double? sleepScore,
          double? recoveryScore,
          double? stressScore,
          double? loadScore,
          DateTime? calculatedAt}) =>
      LocalScore(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        orgId: orgId ?? this.orgId,
        teamId: teamId ?? this.teamId,
        burnoutIndex: burnoutIndex ?? this.burnoutIndex,
        sleepScore: sleepScore ?? this.sleepScore,
        recoveryScore: recoveryScore ?? this.recoveryScore,
        stressScore: stressScore ?? this.stressScore,
        loadScore: loadScore ?? this.loadScore,
        calculatedAt: calculatedAt ?? this.calculatedAt,
      );
  LocalScore copyWithCompanion(LocalScoresCompanion data) {
    return LocalScore(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      burnoutIndex: data.burnoutIndex.present
          ? data.burnoutIndex.value
          : this.burnoutIndex,
      sleepScore:
          data.sleepScore.present ? data.sleepScore.value : this.sleepScore,
      recoveryScore: data.recoveryScore.present
          ? data.recoveryScore.value
          : this.recoveryScore,
      stressScore:
          data.stressScore.present ? data.stressScore.value : this.stressScore,
      loadScore: data.loadScore.present ? data.loadScore.value : this.loadScore,
      calculatedAt: data.calculatedAt.present
          ? data.calculatedAt.value
          : this.calculatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalScore(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('orgId: $orgId, ')
          ..write('teamId: $teamId, ')
          ..write('burnoutIndex: $burnoutIndex, ')
          ..write('sleepScore: $sleepScore, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('stressScore: $stressScore, ')
          ..write('loadScore: $loadScore, ')
          ..write('calculatedAt: $calculatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, orgId, teamId, burnoutIndex,
      sleepScore, recoveryScore, stressScore, loadScore, calculatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalScore &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.orgId == this.orgId &&
          other.teamId == this.teamId &&
          other.burnoutIndex == this.burnoutIndex &&
          other.sleepScore == this.sleepScore &&
          other.recoveryScore == this.recoveryScore &&
          other.stressScore == this.stressScore &&
          other.loadScore == this.loadScore &&
          other.calculatedAt == this.calculatedAt);
}

class LocalScoresCompanion extends UpdateCompanion<LocalScore> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> orgId;
  final Value<String> teamId;
  final Value<double> burnoutIndex;
  final Value<double> sleepScore;
  final Value<double> recoveryScore;
  final Value<double> stressScore;
  final Value<double> loadScore;
  final Value<DateTime> calculatedAt;
  final Value<int> rowid;
  const LocalScoresCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.orgId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.burnoutIndex = const Value.absent(),
    this.sleepScore = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.stressScore = const Value.absent(),
    this.loadScore = const Value.absent(),
    this.calculatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalScoresCompanion.insert({
    required String id,
    required String userId,
    required String orgId,
    required String teamId,
    required double burnoutIndex,
    required double sleepScore,
    required double recoveryScore,
    required double stressScore,
    required double loadScore,
    required DateTime calculatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        orgId = Value(orgId),
        teamId = Value(teamId),
        burnoutIndex = Value(burnoutIndex),
        sleepScore = Value(sleepScore),
        recoveryScore = Value(recoveryScore),
        stressScore = Value(stressScore),
        loadScore = Value(loadScore),
        calculatedAt = Value(calculatedAt);
  static Insertable<LocalScore> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? orgId,
    Expression<String>? teamId,
    Expression<double>? burnoutIndex,
    Expression<double>? sleepScore,
    Expression<double>? recoveryScore,
    Expression<double>? stressScore,
    Expression<double>? loadScore,
    Expression<DateTime>? calculatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (orgId != null) 'org_id': orgId,
      if (teamId != null) 'team_id': teamId,
      if (burnoutIndex != null) 'burnout_index': burnoutIndex,
      if (sleepScore != null) 'sleep_score': sleepScore,
      if (recoveryScore != null) 'recovery_score': recoveryScore,
      if (stressScore != null) 'stress_score': stressScore,
      if (loadScore != null) 'load_score': loadScore,
      if (calculatedAt != null) 'calculated_at': calculatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalScoresCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? orgId,
      Value<String>? teamId,
      Value<double>? burnoutIndex,
      Value<double>? sleepScore,
      Value<double>? recoveryScore,
      Value<double>? stressScore,
      Value<double>? loadScore,
      Value<DateTime>? calculatedAt,
      Value<int>? rowid}) {
    return LocalScoresCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orgId: orgId ?? this.orgId,
      teamId: teamId ?? this.teamId,
      burnoutIndex: burnoutIndex ?? this.burnoutIndex,
      sleepScore: sleepScore ?? this.sleepScore,
      recoveryScore: recoveryScore ?? this.recoveryScore,
      stressScore: stressScore ?? this.stressScore,
      loadScore: loadScore ?? this.loadScore,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (burnoutIndex.present) {
      map['burnout_index'] = Variable<double>(burnoutIndex.value);
    }
    if (sleepScore.present) {
      map['sleep_score'] = Variable<double>(sleepScore.value);
    }
    if (recoveryScore.present) {
      map['recovery_score'] = Variable<double>(recoveryScore.value);
    }
    if (stressScore.present) {
      map['stress_score'] = Variable<double>(stressScore.value);
    }
    if (loadScore.present) {
      map['load_score'] = Variable<double>(loadScore.value);
    }
    if (calculatedAt.present) {
      map['calculated_at'] = Variable<DateTime>(calculatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalScoresCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('orgId: $orgId, ')
          ..write('teamId: $teamId, ')
          ..write('burnoutIndex: $burnoutIndex, ')
          ..write('sleepScore: $sleepScore, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('stressScore: $stressScore, ')
          ..write('loadScore: $loadScore, ')
          ..write('calculatedAt: $calculatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalActionsTable extends LocalActions
    with TableInfo<$LocalActionsTable, LocalAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
      'org_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
      'team_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetUserIdMeta =
      const VerificationMeta('targetUserId');
  @override
  late final GeneratedColumn<String> targetUserId = GeneratedColumn<String>(
      'target_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderUserIdMeta =
      const VerificationMeta('senderUserId');
  @override
  late final GeneratedColumn<String> senderUserId = GeneratedColumn<String>(
      'sender_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orgId,
        teamId,
        type,
        targetUserId,
        senderUserId,
        status,
        payloadJson,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_actions';
  @override
  VerificationContext validateIntegrity(Insertable<LocalAction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
          _orgIdMeta, orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta));
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(_teamIdMeta,
          teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta));
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_user_id')) {
      context.handle(
          _targetUserIdMeta,
          targetUserId.isAcceptableOrUnknown(
              data['target_user_id']!, _targetUserIdMeta));
    } else if (isInserting) {
      context.missing(_targetUserIdMeta);
    }
    if (data.containsKey('sender_user_id')) {
      context.handle(
          _senderUserIdMeta,
          senderUserId.isAcceptableOrUnknown(
              data['sender_user_id']!, _senderUserIdMeta));
    } else if (isInserting) {
      context.missing(_senderUserIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orgId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}org_id'])!,
      teamId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}team_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      targetUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_user_id'])!,
      senderUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_user_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LocalActionsTable createAlias(String alias) {
    return $LocalActionsTable(attachedDatabase, alias);
  }
}

class LocalAction extends DataClass implements Insertable<LocalAction> {
  final String id;
  final String orgId;
  final String teamId;
  final String type;
  final String targetUserId;
  final String senderUserId;
  final String status;
  final String? payloadJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalAction(
      {required this.id,
      required this.orgId,
      required this.teamId,
      required this.type,
      required this.targetUserId,
      required this.senderUserId,
      required this.status,
      this.payloadJson,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['team_id'] = Variable<String>(teamId);
    map['type'] = Variable<String>(type);
    map['target_user_id'] = Variable<String>(targetUserId);
    map['sender_user_id'] = Variable<String>(senderUserId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalActionsCompanion toCompanion(bool nullToAbsent) {
    return LocalActionsCompanion(
      id: Value(id),
      orgId: Value(orgId),
      teamId: Value(teamId),
      type: Value(type),
      targetUserId: Value(targetUserId),
      senderUserId: Value(senderUserId),
      status: Value(status),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalAction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAction(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      teamId: serializer.fromJson<String>(json['teamId']),
      type: serializer.fromJson<String>(json['type']),
      targetUserId: serializer.fromJson<String>(json['targetUserId']),
      senderUserId: serializer.fromJson<String>(json['senderUserId']),
      status: serializer.fromJson<String>(json['status']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'teamId': serializer.toJson<String>(teamId),
      'type': serializer.toJson<String>(type),
      'targetUserId': serializer.toJson<String>(targetUserId),
      'senderUserId': serializer.toJson<String>(senderUserId),
      'status': serializer.toJson<String>(status),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalAction copyWith(
          {String? id,
          String? orgId,
          String? teamId,
          String? type,
          String? targetUserId,
          String? senderUserId,
          String? status,
          Value<String?> payloadJson = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LocalAction(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        teamId: teamId ?? this.teamId,
        type: type ?? this.type,
        targetUserId: targetUserId ?? this.targetUserId,
        senderUserId: senderUserId ?? this.senderUserId,
        status: status ?? this.status,
        payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalAction copyWithCompanion(LocalActionsCompanion data) {
    return LocalAction(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      type: data.type.present ? data.type.value : this.type,
      targetUserId: data.targetUserId.present
          ? data.targetUserId.value
          : this.targetUserId,
      senderUserId: data.senderUserId.present
          ? data.senderUserId.value
          : this.senderUserId,
      status: data.status.present ? data.status.value : this.status,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAction(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('teamId: $teamId, ')
          ..write('type: $type, ')
          ..write('targetUserId: $targetUserId, ')
          ..write('senderUserId: $senderUserId, ')
          ..write('status: $status, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orgId, teamId, type, targetUserId,
      senderUserId, status, payloadJson, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAction &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.teamId == this.teamId &&
          other.type == this.type &&
          other.targetUserId == this.targetUserId &&
          other.senderUserId == this.senderUserId &&
          other.status == this.status &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalActionsCompanion extends UpdateCompanion<LocalAction> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> teamId;
  final Value<String> type;
  final Value<String> targetUserId;
  final Value<String> senderUserId;
  final Value<String> status;
  final Value<String?> payloadJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalActionsCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.type = const Value.absent(),
    this.targetUserId = const Value.absent(),
    this.senderUserId = const Value.absent(),
    this.status = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalActionsCompanion.insert({
    required String id,
    required String orgId,
    required String teamId,
    required String type,
    required String targetUserId,
    required String senderUserId,
    required String status,
    this.payloadJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        orgId = Value(orgId),
        teamId = Value(teamId),
        type = Value(type),
        targetUserId = Value(targetUserId),
        senderUserId = Value(senderUserId),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<LocalAction> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? teamId,
    Expression<String>? type,
    Expression<String>? targetUserId,
    Expression<String>? senderUserId,
    Expression<String>? status,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (teamId != null) 'team_id': teamId,
      if (type != null) 'type': type,
      if (targetUserId != null) 'target_user_id': targetUserId,
      if (senderUserId != null) 'sender_user_id': senderUserId,
      if (status != null) 'status': status,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalActionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? orgId,
      Value<String>? teamId,
      Value<String>? type,
      Value<String>? targetUserId,
      Value<String>? senderUserId,
      Value<String>? status,
      Value<String?>? payloadJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LocalActionsCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      teamId: teamId ?? this.teamId,
      type: type ?? this.type,
      targetUserId: targetUserId ?? this.targetUserId,
      senderUserId: senderUserId ?? this.senderUserId,
      status: status ?? this.status,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetUserId.present) {
      map['target_user_id'] = Variable<String>(targetUserId.value);
    }
    if (senderUserId.present) {
      map['sender_user_id'] = Variable<String>(senderUserId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalActionsCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('teamId: $teamId, ')
          ..write('type: $type, ')
          ..write('targetUserId: $targetUserId, ')
          ..write('senderUserId: $senderUserId, ')
          ..write('status: $status, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalHealthSamplesTable localHealthSamples =
      $LocalHealthSamplesTable(this);
  late final $LocalScoresTable localScores = $LocalScoresTable(this);
  late final $LocalActionsTable localActions = $LocalActionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [localHealthSamples, localScores, localActions];
}

typedef $$LocalHealthSamplesTableCreateCompanionBuilder
    = LocalHealthSamplesCompanion Function({
  required String id,
  required String userId,
  required String type,
  required double value,
  required DateTime timestamp,
  required String deviceSource,
  Value<int> rowid,
});
typedef $$LocalHealthSamplesTableUpdateCompanionBuilder
    = LocalHealthSamplesCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> type,
  Value<double> value,
  Value<DateTime> timestamp,
  Value<String> deviceSource,
  Value<int> rowid,
});

class $$LocalHealthSamplesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalHealthSamplesTable,
    LocalHealthSample,
    $$LocalHealthSamplesTableFilterComposer,
    $$LocalHealthSamplesTableOrderingComposer,
    $$LocalHealthSamplesTableCreateCompanionBuilder,
    $$LocalHealthSamplesTableUpdateCompanionBuilder> {
  $$LocalHealthSamplesTableTableManager(
      _$AppDatabase db, $LocalHealthSamplesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LocalHealthSamplesTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$LocalHealthSamplesTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> deviceSource = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalHealthSamplesCompanion(
            id: id,
            userId: userId,
            type: type,
            value: value,
            timestamp: timestamp,
            deviceSource: deviceSource,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String type,
            required double value,
            required DateTime timestamp,
            required String deviceSource,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalHealthSamplesCompanion.insert(
            id: id,
            userId: userId,
            type: type,
            value: value,
            timestamp: timestamp,
            deviceSource: deviceSource,
            rowid: rowid,
          ),
        ));
}

class $$LocalHealthSamplesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LocalHealthSamplesTable> {
  $$LocalHealthSamplesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceSource => $state.composableBuilder(
      column: $state.table.deviceSource,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LocalHealthSamplesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LocalHealthSamplesTable> {
  $$LocalHealthSamplesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceSource => $state.composableBuilder(
      column: $state.table.deviceSource,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LocalScoresTableCreateCompanionBuilder = LocalScoresCompanion
    Function({
  required String id,
  required String userId,
  required String orgId,
  required String teamId,
  required double burnoutIndex,
  required double sleepScore,
  required double recoveryScore,
  required double stressScore,
  required double loadScore,
  required DateTime calculatedAt,
  Value<int> rowid,
});
typedef $$LocalScoresTableUpdateCompanionBuilder = LocalScoresCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> orgId,
  Value<String> teamId,
  Value<double> burnoutIndex,
  Value<double> sleepScore,
  Value<double> recoveryScore,
  Value<double> stressScore,
  Value<double> loadScore,
  Value<DateTime> calculatedAt,
  Value<int> rowid,
});

class $$LocalScoresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalScoresTable,
    LocalScore,
    $$LocalScoresTableFilterComposer,
    $$LocalScoresTableOrderingComposer,
    $$LocalScoresTableCreateCompanionBuilder,
    $$LocalScoresTableUpdateCompanionBuilder> {
  $$LocalScoresTableTableManager(_$AppDatabase db, $LocalScoresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LocalScoresTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LocalScoresTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> orgId = const Value.absent(),
            Value<String> teamId = const Value.absent(),
            Value<double> burnoutIndex = const Value.absent(),
            Value<double> sleepScore = const Value.absent(),
            Value<double> recoveryScore = const Value.absent(),
            Value<double> stressScore = const Value.absent(),
            Value<double> loadScore = const Value.absent(),
            Value<DateTime> calculatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalScoresCompanion(
            id: id,
            userId: userId,
            orgId: orgId,
            teamId: teamId,
            burnoutIndex: burnoutIndex,
            sleepScore: sleepScore,
            recoveryScore: recoveryScore,
            stressScore: stressScore,
            loadScore: loadScore,
            calculatedAt: calculatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String orgId,
            required String teamId,
            required double burnoutIndex,
            required double sleepScore,
            required double recoveryScore,
            required double stressScore,
            required double loadScore,
            required DateTime calculatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalScoresCompanion.insert(
            id: id,
            userId: userId,
            orgId: orgId,
            teamId: teamId,
            burnoutIndex: burnoutIndex,
            sleepScore: sleepScore,
            recoveryScore: recoveryScore,
            stressScore: stressScore,
            loadScore: loadScore,
            calculatedAt: calculatedAt,
            rowid: rowid,
          ),
        ));
}

class $$LocalScoresTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LocalScoresTable> {
  $$LocalScoresTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get orgId => $state.composableBuilder(
      column: $state.table.orgId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teamId => $state.composableBuilder(
      column: $state.table.teamId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get burnoutIndex => $state.composableBuilder(
      column: $state.table.burnoutIndex,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get sleepScore => $state.composableBuilder(
      column: $state.table.sleepScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get recoveryScore => $state.composableBuilder(
      column: $state.table.recoveryScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stressScore => $state.composableBuilder(
      column: $state.table.stressScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get loadScore => $state.composableBuilder(
      column: $state.table.loadScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get calculatedAt => $state.composableBuilder(
      column: $state.table.calculatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LocalScoresTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LocalScoresTable> {
  $$LocalScoresTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get orgId => $state.composableBuilder(
      column: $state.table.orgId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teamId => $state.composableBuilder(
      column: $state.table.teamId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get burnoutIndex => $state.composableBuilder(
      column: $state.table.burnoutIndex,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get sleepScore => $state.composableBuilder(
      column: $state.table.sleepScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get recoveryScore => $state.composableBuilder(
      column: $state.table.recoveryScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stressScore => $state.composableBuilder(
      column: $state.table.stressScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get loadScore => $state.composableBuilder(
      column: $state.table.loadScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get calculatedAt => $state.composableBuilder(
      column: $state.table.calculatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LocalActionsTableCreateCompanionBuilder = LocalActionsCompanion
    Function({
  required String id,
  required String orgId,
  required String teamId,
  required String type,
  required String targetUserId,
  required String senderUserId,
  required String status,
  Value<String?> payloadJson,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LocalActionsTableUpdateCompanionBuilder = LocalActionsCompanion
    Function({
  Value<String> id,
  Value<String> orgId,
  Value<String> teamId,
  Value<String> type,
  Value<String> targetUserId,
  Value<String> senderUserId,
  Value<String> status,
  Value<String?> payloadJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalActionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalActionsTable,
    LocalAction,
    $$LocalActionsTableFilterComposer,
    $$LocalActionsTableOrderingComposer,
    $$LocalActionsTableCreateCompanionBuilder,
    $$LocalActionsTableUpdateCompanionBuilder> {
  $$LocalActionsTableTableManager(_$AppDatabase db, $LocalActionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LocalActionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LocalActionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orgId = const Value.absent(),
            Value<String> teamId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> targetUserId = const Value.absent(),
            Value<String> senderUserId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> payloadJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalActionsCompanion(
            id: id,
            orgId: orgId,
            teamId: teamId,
            type: type,
            targetUserId: targetUserId,
            senderUserId: senderUserId,
            status: status,
            payloadJson: payloadJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String orgId,
            required String teamId,
            required String type,
            required String targetUserId,
            required String senderUserId,
            required String status,
            Value<String?> payloadJson = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalActionsCompanion.insert(
            id: id,
            orgId: orgId,
            teamId: teamId,
            type: type,
            targetUserId: targetUserId,
            senderUserId: senderUserId,
            status: status,
            payloadJson: payloadJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$LocalActionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LocalActionsTable> {
  $$LocalActionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get orgId => $state.composableBuilder(
      column: $state.table.orgId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teamId => $state.composableBuilder(
      column: $state.table.teamId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get targetUserId => $state.composableBuilder(
      column: $state.table.targetUserId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderUserId => $state.composableBuilder(
      column: $state.table.senderUserId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LocalActionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LocalActionsTable> {
  $$LocalActionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get orgId => $state.composableBuilder(
      column: $state.table.orgId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teamId => $state.composableBuilder(
      column: $state.table.teamId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get targetUserId => $state.composableBuilder(
      column: $state.table.targetUserId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderUserId => $state.composableBuilder(
      column: $state.table.senderUserId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalHealthSamplesTableTableManager get localHealthSamples =>
      $$LocalHealthSamplesTableTableManager(_db, _db.localHealthSamples);
  $$LocalScoresTableTableManager get localScores =>
      $$LocalScoresTableTableManager(_db, _db.localScores);
  $$LocalActionsTableTableManager get localActions =>
      $$LocalActionsTableTableManager(_db, _db.localActions);
}
