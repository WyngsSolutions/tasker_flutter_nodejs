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
  static List myCategories =[];
  static String iosAppLink = "https://apps.apple.com/us/app/kv-tasker/id1668081522";
  static String androidAppLink = "https://play.google.com/store/apps/details?id=com.kv.tasker.app";
  //APIS
  //USER
  static String baseUrl = "http://15.206.224.239:1001/";
  static String signUpUrl = baseUrl + "users/register";
  static String loginUrl =  baseUrl + "users/login";
  static String socialLoginUrl =  baseUrl + "users/socialLogin";
  static String forgotPasswordUrl =  baseUrl + "users/resetPassword/{email}";
  static String deleteAccountUrl = baseUrl + "users/deleteAccount/{userId}/{password}";
  static String getUserImage =  baseUrl + "userProfile/{userId}/avatar";
  static String postUserPhoto =  baseUrl + "profilePicture";
  //TASK
  static String getTasksUrl =  baseUrl + "tasks/tasksList";
  static String getTasksbyDateUrl = baseUrl + "tasks/search/{date}";
  static String createTaskUrl =  baseUrl + "tasks/createTask";
  static String updateTaskUrl =  baseUrl + "tasks/updateTask/{taskId}";
  static String deleteTaskUrl = baseUrl + "tasks/deleteTask/{taskId}";
  //CATEGORY
  static String getCategoryUrl =  baseUrl + "categories/allCategories";
  static String addCategoryUrl =  baseUrl + "categories/addCategory";
  static String deleteCategoryUrl =  baseUrl + "categories/removeCategory/{categoryId}";
  //TEAM
  static String getTeamUrl =  baseUrl + "teams/allMembers";
  static String addMemberUrl =  baseUrl + "teams/addMember";
  static String deleteMemberUrl =  baseUrl + "teams/deleteMember/{memberId}";
  static String editMemberUrl =  baseUrl + "teams/editMember/{memberId}";


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