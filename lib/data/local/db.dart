import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

class LocalHealthSamples extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()(); // 'heart_rate', 'hrv', 'sleep_duration', etc.
  RealColumn get value => real()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get deviceSource => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalScores extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get orgId => text()();
  TextColumn get teamId => text()();
  RealColumn get burnoutIndex => real()();
  RealColumn get sleepScore => real()();
  RealColumn get recoveryScore => real()();
  RealColumn get stressScore => real()();
  RealColumn get loadScore => real()();
  DateTimeColumn get calculatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalActions extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get teamId => text()();
  TextColumn get type => text()();
  TextColumn get targetUserId => text()();
  TextColumn get senderUserId => text()();
  TextColumn get status => text()(); // 'sent', 'received', 'acknowledged', 'dismissed'
  TextColumn get payloadJson => text().nullable()(); // JSON payload stored as string
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LocalHealthSamples, LocalScores, LocalActions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'burnout_meter_local.db'));
    return NativeDatabase.createInBackground(file);
  });
}
