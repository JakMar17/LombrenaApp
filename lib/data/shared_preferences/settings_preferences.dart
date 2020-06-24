import 'package:shared_preferences/shared_preferences.dart';
import 'package:vreme/data/shared_preferences/shared_preferences.dart';

class SettingsPreferences {

  SharedPreferences _sharedPreferences;

  final String showCategory = "settings_show_categories";
  final String showClose = "settings_show_close_data";

  SettingsPreferences() {
    Preferences p = Preferences();
    _sharedPreferences = p.getPreferences();
  }

  bool getSetting(String name) {
    try{
      bool x = _sharedPreferences.getBool(name);
      return x == null ? true : x;
      } catch(Exception) {
        return false;
      }
  }

  void setSetting(String name, bool value) {
    try{
        _sharedPreferences.setBool(name, value);
      } catch(Exception) {
        print("error");
      }
  }
}

class SettingPreference {
  String id;
  String value;

  SettingPreference({
    this.id,
    this.value
  });
}