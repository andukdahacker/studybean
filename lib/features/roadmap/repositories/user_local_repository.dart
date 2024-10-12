import 'package:studybean/common/db/local_db.dart';
import 'package:studybean/features/auth/models/user.dart';
import 'package:uuid/uuid.dart';

class UserLocalRepository {
  final LocalDB _db;

  UserLocalRepository(this._db);

  Future<User> createUser() async {
    final userId = const Uuid().v4();
    await _db.instance.rawInsert(
        'INSERT INTO user(id, credits, createdAt, updatedAt, lastRefreshCreditsAt) VALUES(?, ?, ?, ?, ?)',
        [
          userId,
          10,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ]);
    final result = await _db.instance
        .rawQuery('SELECT * FROM user WHERE id = ?', [userId]);
    final user = User.fromJson(result.first);
    return user;
  }

  Future<User> refreshCredits(String userId) async {
    final oldUser = await _db.instance
        .rawQuery('SELECT * FROM user WHERE id = ?', [userId]);

    if (oldUser.isEmpty) {
      return createUser();
    }

    final lastRefreshCreditsAt =
        oldUser.first['lastRefreshCreditsAt'] as String?;

    final lastRefreshCreditsDateTime =
        DateTime.tryParse(lastRefreshCreditsAt ?? '');

    if (lastRefreshCreditsDateTime == null) {
      return createUser();
    }

    final isAfter24Hours = DateTime.now()
        .isAfter(lastRefreshCreditsDateTime.add(const Duration(hours: 24)));

    if (!isAfter24Hours) {
      return User.fromJson(oldUser.first);
    }

    await _db.instance.rawUpdate(
        'UPDATE user SET credits = 10, lastRefreshCreditsAt = ? WHERE id = ?', [
      DateTime.now().toIso8601String(),
      userId,
    ]);

    final result = await _db.instance
        .rawQuery('SELECT * FROM user WHERE id = ?', [userId]);
    final user = User.fromJson(result.first);
    return user;
  }

  Future<void> decreaseCredits() async {
    await _db.instance.rawUpdate('UPDATE user SET credits = credits - 1');
  }

  Future<User?> getUser() async {
    final result = await _db.instance.rawQuery('SELECT * FROM user');
    if (result.isEmpty) {
      return null;
    }
    return User.fromJson(result.first);
  }

  Future<void> removeUser() async {
    await _db.instance.rawDelete('DELETE FROM user');
  }
}
