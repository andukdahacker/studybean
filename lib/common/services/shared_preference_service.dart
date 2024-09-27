import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences pref;

  SharedPreferenceService({required this.pref});

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