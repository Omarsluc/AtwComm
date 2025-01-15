import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//*******! this class for how to save data into sharrd pref using Expire date *******************************

class CacheHelper {
  // this make the class can not inite object form it cause single pattern desgin principle
  CacheHelper._();

  /// Removes a value from SharedPreferences with given [key].
  static removeData(String key) async {
    debugPrint('SharedPrefHelper : data with key : $key has been removed');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  /// Removes all keys and values in the SharedPreferences
  static clearAllData() async {
    debugPrint('SharedPrefHelper : all data has been cleared');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();

    await sharedPreferences.clear();
  }

  /// Saves a [value] with a [key] in the SharedPreferences.
  static setData({required String key, required dynamic value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    debugPrint("SharedPrefHelper : setData with key : $key and value : $value");
    switch (value.runtimeType) {
      case String:
        await sharedPreferences.setString(key, value);
        break;
      case int:
        await sharedPreferences.setInt(key, value);
        break;
      case double:
        await sharedPreferences.setDouble(key, value);
        break;
      case bool:
        await sharedPreferences.setBool(key, value);
        break;
      default:
        return null;
    }
  }

  /// Gets a bool value from SharedPreferences with given [key].
  static getBool(String key) async {
    debugPrint('SharedPrefHelper : getBool with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? false;
  }

  /// Gets a double value from SharedPreferences with given [key].
  static getDouble(String key) async {
    debugPrint('SharedPrefHelper : getDouble with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(key) ?? 0.0;
  }

  /// Gets an int value from SharedPreferences with given [key].
  static getInt(String key) async {
    debugPrint('SharedPrefHelper : getInt with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key) ?? 0;
  }

  /// Gets an String value from SharedPreferences with given [key].
  static getString(String key) async {
    debugPrint('SharedPrefHelper : getString with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? '';
  }

  //************ THIS  SECTION FOR SECURE DATA IN SECURE STORAGE ******************************  */
  /// secure string in secure storage with value
  static setSecuredString({required String key, required String value}) async {
    final storage = new FlutterSecureStorage();

    debugPrint('FlutterSecureStorage : saved String $key with value $value');
    return await storage.write(key: key, value: value);
  }

  /// get secure String with key
  static getSecuredString({required String key}) async {
    final storage = new FlutterSecureStorage();
    debugPrint('FlutterSecureStorage : get Secured String $key ');
    return await storage.read(
          key: key,
        ) ??
        '';
  }

  //**************************************************************************************** */

  static const String _keyData = 'myData';
  static const String _keyExpiration = 'exipartionTime';

  ///save data with expiration date in sharred pref
  Future<bool> savedDataWithExpireDate(
      String data, Duration expireDuration) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      DateTime expireTime = DateTime.now().add(expireDuration);

      pref.setString(_keyData, data);
      pref.setString(_keyExpiration, expireTime.toIso8601String());

      log('Data saved successfully with expire time  SharredPref ');
      return true;
    } catch (e) {
      log('Data saved Not Saved  ');

      return false;
    }
  }

  //******************************************************************* */
//! get data if not expire *////////////////////////////////////////////////
  // get data from sharred pref if not expire
  Future<String?> getDataIfNotExpired() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var dataSaved = pref.getString(_keyData);
      var expireDateStr = pref.getString(_keyExpiration);

      if (dataSaved == null || expireDateStr == null) {
        log('No Data found or expiration data in sharred pref');
        return null;
      }
      //** Here we check if the expire time in valid or not */
      DateTime expireTime = DateTime.parse(expireDateStr);
      if (expireTime.isAfter(DateTime.now())) {
        //expire date not end so the data is stable and i did not need
        /// to connet the api to fetch new data
        return dataSaved;
      } else {
        // data expired i need to fetch antoher data i remove the sharred pref
        pref.remove(_keyData);
        pref.remove(_keyExpiration);
        log('Data has expired. Removed from SharedPreferences.');
        return null;
      }
    } catch (e) {
      print('Error retrieving data from SharedPreferences: $e');
      return null;
    }
  }
  //******************************-*************************************** */

  void clearDataFormSharredPref() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove(_keyData);
      preferences.remove(_keyExpiration);
      log('Data removed successffully');
    } catch (e) {
      log(e.toString());
    }
  }
}
