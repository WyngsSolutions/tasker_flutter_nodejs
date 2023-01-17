import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/app_user.dart';

class Constants {
  static final Constants _singleton = Constants._internal();
  static String appName = "Task Manager";
  static bool isUserSignedIn = false;
  static bool isFirstTimeAppLaunched = true;
  static AppUser appUser = AppUser();
  static Color appThemeColor = Color(0xFF6E3EF7);//const Color(0xff000E50);

  static String oneSignalId = "13fa3a3e-14ca-4727-a27b-4bb4ed291c38";
  static String oneSignalRestKey = "NzU0N2Y1M2MtNGE3NS00NTI4LWE0NjAtZTkzNDczMjVmOGY3";
  //FOR NAVGATON
  static Function? callBackFunction;
  static String topViewName = "";

  factory Constants() {
    return _singleton;
  }

  Constants._internal();

  static void showDialog(String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(appName),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }  

  static void showDialogWithTitle(String title ,String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }   
}