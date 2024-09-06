import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studybean/common/logging/logger.dart';

class LocalDB {
  final Database instance;

  static Future<Database> openDb() async {
    final path = join(await getDatabasesPath(), 'studybean.db');
    final db = await openDatabase(
      path,
      onCreate: (db, version) async {
        try {
          await db.execute(
              'CREATE TABLE user(id TEXT PRIMARY KEY, username TEXT, email TEXT, credits INTEGER, paidCredits INTEGER, createdAt TEXT, updatedAt TEXT)');
          await db
              .execute('CREATE TABLE subjects(id TEXT PRIMARY KEY, name TEXT)');
          await db.execute(
              'CREATE TABLE roadmaps(id TEXT PRIMARY KEY, userId TEXT, goal TEXT, createdAt TEXT, updatedAt TEXT, subjectId TEXT NOT NULL, FOREIGN KEY (subjectId) REFERENCES subjects(id) ON DELETE CASCADE)');
          await db.execute(
              'CREATE TABLE milestones(id TEXT PRIMARY KEY, name TEXT, position INTEGER, roadmapId TEXT NOT NULL, FOREIGN KEY (roadmapId) REFERENCES roadmaps(id) ON DELETE CASCADE)');
          await db.execute(
              'CREATE TABLE actions(id TEXT PRIMARY KEY, name TEXT, description TEXT, duration INTEGER, durationUnit TEXT, deadline TEXT, isCompleted INTEGER, createdAt TEXT, updatedAt TEXT, milestoneId TEXT NOT NULL, FOREIGN KEY (milestoneId) REFERENCES milestones(id) ON DELETE CASCADE)');
          await db.execute(
            'CREATE TABLE resources(id TEXT PRIMARY KEY, title TEXT NOT NULL, url TEXT NOT NULL, description TEXT, actionId TEXT NOT NULL, FOREIGN KEY (actionId) REFERENCES actions(id) ON DELETE CASCADE)',
          );
        } catch (e, stackTrace) {
          appLogger.severe(e.toString(), stackTrace);
        }
      },
      version: 1,
    );

    return db;
  }

  LocalDB(this.instance);

  Future<void> close() async {
    await instance.close();
  }
}
