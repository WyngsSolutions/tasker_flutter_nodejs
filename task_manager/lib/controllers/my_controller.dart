// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, invalid_return_type_for_catch_error, avoid_function_literals_in_foreach_calls, unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';
import '../utils/constants.dart';
import 'package:http_parser/http_parser.dart';

import 'notifications_controller.dart';

class MyController {

  //SIGN UP
  Future signUpUser(String userName, String email, String password, bool isMember) async {
    try {
      String url = Constants.signUpUrl;
      dynamic jsonBody = '{ "name" : "$userName", "email" : "$email",  "password" : "$password", "isMember" : "$isMember"}';
      dynamic headers = await setHeaders();
      Response response = await post(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Constants.appUser = AppUser.fromJson(data['newUser']);
        String token = data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token); 
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = Constants.appUser;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = response.body;
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInUser(String email, String password) async {
    try {
      String url = Constants.loginUrl;
      dynamic jsonBody = '{"email" : "$email",  "password" : "$password"}';
      dynamic headers = await setHeaders();
      Response response = await post(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Constants.appUser = AppUser.fromJson(data['user']);
        String token = data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token); 
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = Constants.appUser;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = response.body;
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInSocialUser(String userId, String name, String email, String? photoUrl) async {
    try {
      String url = "";
      dynamic jsonBody = '{ "userId": $userId, "username": $name, "email": $email, "picture": ${(photoUrl == null ) ? '' : photoUrl} }';
      dynamic headers = {};
      Response response = await post(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Constants.appUser = AppUser.fromJson(data);
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = Constants.appUser;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future signUpAppleUser(String userName, String appleUserIdentier, String email, String password) async {
    try {
      String url = "";
      dynamic jsonBody = '{ "userId": $appleUserIdentier, "username": $userName, "email": $email, "picture": '' }';
      dynamic headers = {};
      Response response = await post(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Constants.appUser = AppUser.fromJson(data);
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = Constants.appUser;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  //FORGOT PASSWORD
  Future forgotPassword(String email) async {
    try {
      String url = Constants.forgotPasswordUrl;
      url = url.replaceAll('{email}', email);
      dynamic headers = await setHeaders();
      Response response = await post(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Future deleteAccount(String password) async {
    try {
      String url = Constants.deleteAccountUrl;
      url = url.replaceFirst('{userId}', Constants.appUser.userId);
      url = url.replaceFirst('{password}', password);
      dynamic headers = await setHeaders();
      Response response = await delete(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = response.body;
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //TASKS
  Future getAllTasks(List tasks) async {
    try {
      String url = Constants.getTasksUrl;
      dynamic headers = await setHeaders();
      Response response = await get(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        tasks = data['tasks'];
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Tasks'] = tasks;
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addTask(String taskTitle, String taskDescription, Map taskCategory, String taskDate, Map? member, String taskReminder) async {
    try {
      String url = Constants.createTaskUrl;
      dynamic jsonBody = '{ "title" : "$taskTitle", "description" : "$taskDescription", "category" : "${taskCategory['_id']}", "date" : "$taskDate", "member" : "${(member != null) ?  member['_id'] : ""}", "reminder" : "$taskReminder"}';
      dynamic headers = await setHeaders();
      Response response = await post(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        if(taskReminder.isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskReminder);
          NotificationHandler.showScheduledNotification(taskReminderDate.microsecond, taskTitle, taskDescription, '' , taskReminderDate);
        }
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future editTask(Map taskDetail, String taskTitle, String taskDescription, Map taskCategory, String taskDate, Map? member, String taskReminder) async {
    try {
      String url = Constants.updateTaskUrl;
      url = url.replaceAll('{taskId}', taskDetail['_id']);
      dynamic jsonBody = '{ "title" : "$taskTitle", "description" : "$taskDescription", "category" : "${taskCategory['_id']}", "date" : "$taskDate", "member" : "${(member != null) ?  member['_id'] : ""}", "reminder" : "$taskReminder"}';
      dynamic headers = await setHeaders();
      Response response = await patch(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        //REMOVE FIRST REMINDER IF ALREADY THERE
        if(taskDetail['reminder'].toString().isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskDetail['reminder']);
          NotificationHandler.deleteLocalNotificationWithId(taskReminderDate.microsecond);
        }
        //SETUP NEW REMINDER
        if(taskReminder.isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskReminder);
          NotificationHandler.showScheduledNotification(taskReminderDate.microsecond, taskTitle, taskDescription,  "",  taskReminderDate);
        }
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteTask(Map taskDetail) async {
    try {
      String url = Constants.deleteTaskUrl;
      url = url.replaceAll('{taskId}', taskDetail['_id']);
      dynamic headers = await setHeaders();
      Response response = await delete(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  //TEAM MEMBERS
  Future getMembers() async {
    try {
      String url = Constants.getTeamUrl;
      dynamic headers = await setHeaders();
      Response response = await get(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Members'] = data['members'];
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addTeamMember(String memberName, String memberEmail, File? memberPicture) async {
    try {
      String url = Constants.addMemberUrl;
      dynamic headers = await setFormHeaders();
      var request = new MultipartRequest("POST", Uri.parse(url));
      request.fields['name'] = memberName;
      request.fields['email'] = memberEmail;
      request.headers.addAll(headers);
      //request.files.add(new MultipartFile.fromBytes('avatar', await File.fromUri(memberPicture!.uri).readAsBytes(),filename: basename(memberPicture.path), contentType: new MediaType('image', 'jpeg')));
      if(memberPicture != null)
        request.files.add(new MultipartFile.fromBytes('avatar', await File.fromUri(memberPicture.uri).readAsBytes(),filename: basename(memberPicture.path), contentType: new MediaType('image', 'jpeg')));
      // else
      //   request.files.add(new MultipartFile.fromBytes('avatar', [] ,filename: '', contentType: new MediaType('image', 'jpeg')));

      dynamic response = await request.send();
      String responseData = await utf8.decoder.bind(response.stream).join();
      dynamic data = jsonDecode(responseData);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Members'] = data['members'];
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future editTeamMember(Map member, String memberName, String memberEmail, File? memberPicture) async {
    try {
      String url = Constants.editMemberUrl;
      url = url.replaceAll('{memberId}', member['_id']);
      dynamic headers = await setFormHeaders();
      var request = new MultipartRequest("PATCH", Uri.parse(url));
      request.fields['name'] = memberName;
      request.fields['email'] = memberEmail;
      request.headers.addAll(headers);
      if(memberPicture != null)
        request.files.add(new MultipartFile.fromBytes('avatar', await File.fromUri(memberPicture.uri).readAsBytes(),filename: basename(memberPicture.path), contentType: new MediaType('image', 'jpeg')));
      else
        request.files.add(new MultipartFile.fromBytes('avatar', [] ,filename: '', contentType: new MediaType('image', 'jpeg')));

      dynamic response = await request.send();
      String responseData = await utf8.decoder.bind(response.stream).join();
      dynamic data = jsonDecode(responseData);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Members'] = data['members'];
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteMember(Map member) async {
    try {
      String url = Constants.deleteMemberUrl;
      url = url.replaceAll('{memberId}', member['_id']);
      dynamic headers = await setHeaders();
      Response response = await delete(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //CATEGORIES
   Future getAllCategories(List categories) async {
    try {
      String url = Constants.getCategoryUrl;
      dynamic headers = await setHeaders();
      Response response = await get(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        categories = data['category'];
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Categories'] = categories;
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addCategory(String catName) async {
    try {
      String url = Constants.addCategoryUrl;
      dynamic jsonBody = '{ "name" : "$catName"}';
      dynamic headers = await setHeaders();
      Response response = await post(Uri.parse(url), headers: headers, body: jsonBody);
      if(response.statusCode == 200)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = response.body;
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Future deleteCategory(Map category) async {
    try {
      String url = Constants.deleteCategoryUrl;
      url = url.replaceAll('{categoryId}', category['_id']);
      dynamic headers = await setHeaders();
      Response response = await delete(Uri.parse(url), headers: headers);
      if(response.statusCode == 200)
      {
        dynamic data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        return setUpFailure();
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  // Future sendChatNotificationToUser(AppUser user) async {
  //   try {
  //     Map<String, String> requestHeaders = {
  //       "Content-type": "application/json", 
  //       "Authorization" : "Basic ${Constants.oneSignalRestKey}"
  //     };

  //     //if(user.oneSignalUserId.isEmpty)
  //     user = await AppUser.getUserDetailByUserId(user.userId);
  //     var url = 'https://onesignal.com/api/v1/notifications';
  //     final Uri _uri = Uri.parse(url);
  //     //String json = '{ "include_player_ids" : ["${user.oneSignalUserID}"], "app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "New Message"}, "contents" : {"en" : "You have a message from ${Constants.appUser.fullName}"}, "data" : { "userID" : "${Constants.appUser.userID}" } }';
  //     String json = '{ "include_player_ids" : ["${user.oneSignalUserId}"] ,"app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "New Request"},"contents" : {"en" : "You have received a request message from ${Constants.appUser.name}"}}';
  //     Response response = await post(_uri, headers: requestHeaders, body: json);
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
    
  //     if (response.statusCode == 200) {
  //       Map finalResponse = <dynamic, dynamic>{}; //empty map
  //       finalResponse['Status'] = "Success";
  //       return finalResponse;
  //     } else {
  //       Map finalResponse = <dynamic, dynamic>{}; //empty map
  //       finalResponse['Error'] = "Error";
  //       finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
  //       return finalResponse;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return setUpFailure();
  //   }
  // }

  // Future sendGeneralNotificationToUser(AppUser user, String msgTitle, String msgText) async {
  //   try {
  //     Map<String, String> requestHeaders = {
  //       "Content-type": "application/json", 
  //       "Authorization" : "Basic ${Constants.oneSignalRestKey}"
  //     };

  //     //if(user.oneSignalUserId.isEmpty)
  //     user = await AppUser.getUserDetailByUserId(user.userId);
  //     var url = 'https://onesignal.com/api/v1/notifications';
  //     final Uri _uri = Uri.parse(url);
  //     String json = '{ "include_player_ids" : ["${user.oneSignalUserId}"] ,"app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "$msgTitle"},"contents" : {"en" : "$msgText"}}';
  //     Response response = await post(_uri, headers: requestHeaders, body: json);
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
    
  //     if (response.statusCode == 200) {
  //       Map finalResponse = <dynamic, dynamic>{}; //empty map
  //       finalResponse['Status'] = "Success";
  //       return finalResponse;
  //     } else {
  //       Map finalResponse = <dynamic, dynamic>{}; //empty map
  //       finalResponse['Error'] = "Error";
  //       finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
  //       return finalResponse;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return setUpFailure();
  //   }
  // }
  
  Future<Map<String, String>> setHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token') ?? "";
    print(userToken);
    Map<String, String> headers;
    if(userToken.isEmpty)
    {
      headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
    }
    else
    {
      headers = {
        "x-access-token" : userToken,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
    }
    return headers;
  }

  Future<Map<String, String>> setFormHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token') ?? "";
    print(userToken);
    Map<String, String> headers;
    if(userToken.isEmpty)
    {
      headers = {
        'Content-type': 'multipart/form-data',
        'Accept': 'multipart/form-data',
      };
    }
    else
    {
      headers = {
        "x-access-token" : userToken,
        'Content-type': 'multipart/form-data',
        'Accept': 'multipart/form-data',
      };
    }
    return headers;
  }

  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Please try again later. Server is busy.";
    return finalResponse;
  }
}
