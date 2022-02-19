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