// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/controllers/notifications_controller.dart';
import 'package:task_manager/models/app_user.dart';

import '../utils/constants.dart';

class AppController {

  final firestoreInstance = FirebaseFirestore.instance;

  //SIGN UP
  Future signUpUser(String userName, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
      AppUser newUser = AppUser(userId: userCredential.user!.uid, name: userName, email: email);
      AppUser resultUser = await newUser.signUpUser(newUser);
      if (resultUser.email.isNotEmpty) 
      {
        Constants.appUser = resultUser;
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.message;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
      AppUser signedInUser = AppUser(
        userId: userCredential.user!.uid, 
        name: '', 
        email: email, 
        oneSignalUserId: '', 
        userProfilePicture: '',
      );

      userCredential.user!.sendEmailVerification();
      AppUser resultUser = await AppUser.getLoggedInUserDetail(signedInUser);
      if (resultUser.email.isNotEmpty) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        Constants.appUser = resultUser;
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot login at this time. Try again later";
        return finalResponse;
      }
    }
     on FirebaseAuthException catch (e) 
    {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.message;
      return finalResponse;
    } 
    catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInSocialUser(String userFbId, String name, String email, String? photoUrl) async {
    try {
      AppUser signedInUser = AppUser(
        userId: userFbId, 
        name: name, 
        email: email, 
        oneSignalUserId: '', 
        userProfilePicture: (photoUrl == null) ? "" : photoUrl,
      );

      AppUser resultUser = await AppUser.getLoggedInUserDetail(signedInUser);
      if (resultUser.email.isNotEmpty) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        Constants.appUser = resultUser;
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot login at this time. Try again later";
        return finalResponse;
      }
    }
     on FirebaseAuthException catch (e) 
    {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.message;
      return finalResponse;
    } 
    catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

   Future signUpAppleUser(String userName, String appleUserIdentier, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
      AppUser newUser = AppUser(userId: userCredential.user!.uid, name: userName, email: email, appleUserIdentier: appleUserIdentier);
      AppUser resultUser = await newUser.signUpUser(newUser);
      if (resultUser.email.isNotEmpty) 
      {
        Constants.appUser = resultUser;
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.message;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //FORGOT PASSWORD
  Future forgotPassword(String email) async {
    try {
      String result = "";
      await FirebaseAuth.instance
      .sendPasswordResetEmail(email: email).then((_) async {
        result = "Success";
      }).catchError((error) {
        result = error.toString();
        print("Failed emailed : $error");
      });

      if (result == "Success") {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = result;
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.code;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  //EDIT USER NAME
  Future updateProfileInfo(String name, String userProfilePicture) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
        return await firestoreInstance.collection("users").doc(Constants.appUser.userId)
        .update({
          'name': name,
          'userProfilePicture' : userProfilePicture,
        }).then((_) async {
          print("success!");
          Map finalResponse = <dynamic, dynamic>{}; //empty map
          finalResponse['Status'] = "Success";
          return finalResponse;
        }).catchError((error) {
          print("Failed to update: $error");
          return setUpFailure();
        });
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Future addTask(String taskTitle, String taskDescription, String taskCategory, String taskDate, Map? member, String taskReminder) async {
    try {   
      dynamic result = await firestoreInstance.collection("tasks").add({
        'taskTitle': taskTitle,
        'taskDescription': taskDescription,
        'taskCategory': taskCategory,
        'taskDate': taskDate,
        'member' : (member == null) ? {} : member,
        'taskReminder': taskReminder,
        'userEmail': Constants.appUser.email,
        'userId': Constants.appUser.userId,
        'addedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        if(taskReminder.isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskReminder);
          NotificationHandler.showScheduledNotification(taskReminderDate.microsecond, taskTitle, taskDescription, '' , taskReminderDate);
        }
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getAllUserTasks(List allTasks) async {
    try {
      dynamic result = await firestoreInstance.collection("tasks")
      .where('userId', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map taskData = result.data();
          taskData['taskId'] = result.id;
          allTasks.add(taskData);
        });
        return true;
      });

      if (result)
      {
        allTasks.sort((a, b) => a['addedTime'].toDate().compareTo(b['addedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteTask(Map task) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("tasks").
        doc(task['taskId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        if(task['taskReminder'].toString().isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(task['taskReminder']);
          NotificationHandler.deleteLocalNotificationWithId(taskReminderDate.microsecond);
        }
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

  Future editTask(Map taskDetail, String taskTitle, String taskDescription, String taskCategory, String taskDate, Map? member, String taskReminder) async {
    try {   
      dynamic result = await firestoreInstance.collection("tasks").doc(taskDetail['taskId'])
      .update({
        'taskTitle': taskTitle,
        'taskDescription': taskDescription,
        'taskCategory': taskCategory,
        'taskDate': taskDate,
        'taskReminder': taskReminder,
        'member' : (member == null) ? {} : member,
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });

      if (result)
      {
        //REMOVE FIRST REMINDER IF ALREADY THERE
        if(taskDetail['taskReminder'].toString().isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskDetail['taskReminder']);
          NotificationHandler.deleteLocalNotificationWithId(taskReminderDate.microsecond);
        }
        //SETUP NEW REMINDER
        if(taskReminder.isNotEmpty)
        {
          DateTime taskReminderDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskReminder);
          NotificationHandler.showScheduledNotification(taskReminderDate.microsecond, taskTitle, taskDescription,  "",  taskReminderDate);
        }
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //UPDATE PROFILE PIC
  Future<dynamic> updateOneSignalUserID(String oneSignalUserID) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance.collection("users").doc(Constants.appUser.userId)
    .update({
      "oneSignalUserId": oneSignalUserID
     }).then((_) async {
      print("success!");
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Success";
      return finalResponse;
    }).catchError((error) {
      print("Failed to update: $error");
      return setUpFailure();
    });
  }

  Future deleteUserAccount(String riderPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: Constants.appUser.email, password: riderPassword);
      print(userCredential.user);
      AuthCredential credentials = EmailAuthProvider.credential(email: Constants.appUser.email, password: riderPassword);
      UserCredential result = await userCredential.user!.reauthenticateWithCredential(credentials);
      await deleteUserFromFirebase(Constants.appUser.userId);
      await result.user!.delete();
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Success";
      return finalResponse;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "The rider password is not correct";
      return finalResponse;
    }
    catch(e){
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "The rider password is not correct";
      return finalResponse;
    }
  }

  Future deleteUserFromFirebase(String userId) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("users").
        doc(userId).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

  Future getAllMembers(List allMembers) async {
    try {
      dynamic result = await firestoreInstance.collection("members")
      .where('memberAddedById', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map memberData = result.data();
          memberData['memberId'] = result.id;
          allMembers.add(memberData);
        });
        return true;
      });

      if (result)
      {
        allMembers.sort((a, b) => a['addedTime'].toDate().compareTo(b['addedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addMember(String memberName, String memberEmail, String memberPhoto) async {
    try {   
      dynamic result = await firestoreInstance.collection("members").add({
        'memberName': memberName,
        'memberEmail': memberEmail,
        'memberPhoto': memberPhoto,
        'memberAddedByEmail': Constants.appUser.email,
        'memberAddedById': Constants.appUser.userId,
        'addedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future editMember(Map memberDetail, String memberName, String memberEmail, String memberPhoto) async {
    try {   
      dynamic result = await firestoreInstance.collection("members").doc(memberDetail['memberId'])
      .update({
        'memberName': memberName,
        'memberEmail': memberEmail,
        'memberPhoto': memberPhoto,
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteMember(Map member) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("members").
        doc(member['memberId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Please try again later. Server is busy.";
    return finalResponse;
  }
}
