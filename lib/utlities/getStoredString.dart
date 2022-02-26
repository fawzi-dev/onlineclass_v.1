import 'package:shared_preferences/shared_preferences.dart';

class GetStoredData {

  static SharedPreferences? _preferences;
  static const _stageKey = 'stagesKey';

  static Future init() async{
     _preferences = await SharedPreferences.getInstance();
  }

  static Future setString(String stages) async{
   await _preferences?.setString(_stageKey, stages);
   print('Data |||||||||||||||'+stages);
  }

  static String? getString() => _preferences?.getString(_stageKey);
}

class GetUserData {

  static SharedPreferences? _preferences;
  static const _userKey = 'userKeys';
  static const _nameKey = 'namekey';
  static const _usernameKey = 'usernameKey';

  static Future init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setString(String users,String name,String username) async{
    await _preferences?.setString(_userKey, users);
    await _preferences?.setString(_nameKey, name);
    await _preferences?.setString(_usernameKey, username);
    print('Data |||||||||||||||'+users);
  }

  static String? getString() => _preferences?.getString(_userKey);
  static String? getNameString() => _preferences?.getString(_nameKey);
  static String? getUsernameString() => _preferences?.getString(_usernameKey);
  

}