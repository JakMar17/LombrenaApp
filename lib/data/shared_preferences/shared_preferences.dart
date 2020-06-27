import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences _sharedPreferences;

  void setInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  SharedPreferences getPreferences() {
    if(_sharedPreferences == null) {
      setInstance();
      return null;
    }

    return _sharedPreferences;
  }

  Preferences() {
    if(_sharedPreferences == null)
      setInstance();
  }
}