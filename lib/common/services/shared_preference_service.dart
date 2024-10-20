import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences pref;

  SharedPreferenceService({required this.pref});

  Future<void> resetCredits() async {
    final lastResetCredit = pref.getString('lastResetCredit');
    if (lastResetCredit != null) {
      final lastReset = DateTime.parse(lastResetCredit);
      if (lastReset.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
        return;
      }
    }
    setCredits(10);
    await pref.setString('lastResetCredit', DateTime.now().toIso8601String());
  }

  Future<void> decrementCredits() async {
    final credits = getCredits();
    await setCredits(credits - 1);
  }

  Future<void> setCredits(int credits) async {
    await pref.setInt('credits', credits);
  }

  int getCredits() {
    return pref.getInt('credits') ?? 0;
  }

  bool checkIfFirstTime() {
    return pref.getBool('firstTime') ?? true;
  }

  Future<void> setFirstTime() async {
    await pref.setBool('firstTime', false);
  }

  Future<void> setToken(String token) async {
    await pref.setString('token', token);
  }

  Future<void> removeToken() async {
    await pref.remove('token');
  }

  String getToken() {
    return pref.getString('token') ?? '';
  }
}