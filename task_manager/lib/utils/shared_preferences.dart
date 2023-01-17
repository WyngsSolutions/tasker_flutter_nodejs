import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences{

  String token ="token";
  bool isLoggedIn = false;

  /*
  // Save Defaults
  */
  Future saveStringToSF(String key, String value)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print('Saved $key  = $value');
  }

  Future saveIntToSF(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future saveDoubleToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('doubleValue', 115.0);
  }

  Future saveBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', true);
  }

  /*
  // Get Defaults
  */
   getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(key);
  }

  Future getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool(key);
  }

  Future getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    return prefs.getInt(key);
  }

  Future getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    return prefs.getDouble(key);
  }

  /*
  // Remove Defaults
  */
  Future removeValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove(key);
  }

  /*
  // Key Exists In Defaults
  */
  Future doesKeyExist()async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('value');
  }

  //Extra
  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }
}