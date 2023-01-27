// ignore_for_file: avoid_print
import 'package:shared_preferences/shared_preferences.dart';

class AppUser{

  String userId = "";
  String email = "";
  String name = "";
  String password = "";
  String appleUserIdentier = "";
  String userProfilePicture = "";
  String oneSignalUserId = "";

  AppUser({this.userId = "", this.name = "", this.email = "", this.password = "", this.userProfilePicture = "", this.oneSignalUserId = "", this.appleUserIdentier = ""});

  factory AppUser.fromJson(dynamic json) {
    AppUser user = AppUser(
      userId: json['_id'],
      name : json['name'],
      email : json['email'],
      password : json['password'],
      //userProfilePicture : json['userProfilePicture'],
      //oneSignalUserId : json['oneSignalUserId'],
      //myCategories : json['myCategories'],
      //appleUserIdentier : (json['appleUserIdentier'] == null) ? '' : json['appleUserIdentier']
    );
    return user;
  }

  Future saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("appleUserIdentier", appleUserIdentier);
    prefs.setString("oneSignalUserId", oneSignalUserId);
    prefs.setString("userProfilePicture", userProfilePicture);
  }

  static Future<AppUser> getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppUser user = AppUser();
    user.userId = prefs.getString("userId") ?? "";
    user.name = prefs.getString("name") ?? "";
    user.oneSignalUserId =  prefs.getString("oneSignalUserId") ?? "";
    user.email =  prefs.getString("email") ?? "";
    user.appleUserIdentier = prefs.getString('appleUserIdentier') ?? "";
    user.userProfilePicture =  prefs.getString("userProfilePicture") ?? "";
    return user;
  }

  static Future deleteUserAndOtherPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future saveOneSignalUserID(String oneSignalId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("OneSignalUserId", oneSignalId);
  }

  static Future getOneSignalUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("OneSignalUserId") ?? "";
  }
}
