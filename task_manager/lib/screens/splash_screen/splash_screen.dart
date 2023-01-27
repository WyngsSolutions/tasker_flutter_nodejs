// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/home_screen/home_screen.dart';
import 'package:task_manager/utils/color.dart';
import 'package:task_manager/utils/size_config.dart';

import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../login_screen/login_screen.dart';
import '../navigation_view/navigation_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkIfUserLoggedIn();
    });
  }

  void checkIfUserLoggedIn() async {
    //Check User Login
    Constants.appUser = await AppUser.getUserDetail();
    if(Constants.appUser.email.isEmpty)   
      Get.offAll(const LoginScreen(),);
    else
    {
      //Constants.appUser = await AppUser.getUserDetailByUserId(Constants.appUser.userId);
      Get.offAll(const NavigationView(defaultPage: 0,),);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.blockSizeHorizontal * 80,
              width: SizeConfig.blockSizeHorizontal * 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.jpeg'),
                )
              ),
            )
          ],
        ),
        // child: Center(
        //   child: Text(
        //     'Task Manager',
        //     style: TextStyle(
        //       fontSize: SizeConfig.fontSize * 3,
        //       color: Colors.white
        //     ),
        //   ),
        // ),
      ),
    );
  }
}