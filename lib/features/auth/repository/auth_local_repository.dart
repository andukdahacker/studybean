import '../../../common/db/local_db.dart';
import '../models/user.dart';

class AuthLocalRepository {
  AuthLocalRepository(this._db);

  final LocalDB _db;

  Future<User?> getUser() async {
    final result = await _db.instance.rawQuery('SELECT * FROM user');
    if (result.isEmpty) {
      return null;
    }
    return User.fromJson(result.first);
  }

  Future<void> setUser(User user) async {
    await _db.instance.rawInsert(
        'INSERT INTO user(id, username, email, credits, paidCredits, createdAt, updatedAt) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [
          user.id,
          user.username,
          user.email,
          user.credits,
          user.paidCredits,
          user.createdAt.toIso8601String(),
          user.updatedAt.toIso8601String()
        ]);
  }

  Future<void> removeUser() async {
    await _db.instance.rawDelete('DELETE FROM user');
  }
}
