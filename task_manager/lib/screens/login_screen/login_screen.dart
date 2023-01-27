// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/controllers/my_controller.dart';
import 'package:task_manager/controllers/social_login_controller.dart';
import 'package:task_manager/screens/forgot_password/forgot_password.dart';
import 'package:task_manager/screens/signup_screen/signup_screen.dart';
import 'package:task_manager/utils/constants.dart';
import '../../utils/size_config.dart';
import '../navigation_view/navigation_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
  }

  void signInPressed() async
  {
    if(email.text.isEmpty)
      Constants.showDialog("Please enter email");
    else if(!GetUtils.isEmail(email.text))
      Constants.showDialog("Please enter valid email");
    else if(password.text.isEmpty)
      Constants.showDialog("Please enter password");
    else if(password.text.length < 6)
      Constants.showDialog("Password lenght should be atleast 8 characters");
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      dynamic result =  await MyController().signInUser(email.text, password.text);
      EasyLoading.dismiss();
      if(result['Status'] == 'Success'){
        await Constants.appUser.saveUserDetails();
        Get.offAll(const NavigationView(defaultPage: 0,));
      }
      else{
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            
            Container(
              height: SizeConfig.blockSizeVertical*22,
              color: Constants.appThemeColor,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*7, left: SizeConfig.blockSizeHorizontal*5, right: SizeConfig.blockSizeHorizontal*5),
                    height: SizeConfig.blockSizeVertical*6,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3),
                            child: Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.fontSize*2.4
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),


            Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*18),
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3.5, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6, bottom: SizeConfig.blockSizeVertical*2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [                    

                    //Email
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize*1.6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      //height: SizeConfig.blockSizeVertical*6,
                      decoration: BoxDecoration(
                        color: (email.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: (email.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                          width: 1
                        )
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                          controller: email,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (val){
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter email',
                            hintStyle: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                            suffixIcon: Container(
                              margin: EdgeInsets.symmetric(horizontal : SizeConfig.blockSizeHorizontal*3, vertical: SizeConfig.blockSizeVertical*2),
                              height: SizeConfig.blockSizeVertical*2,
                              width: SizeConfig.blockSizeVertical*2,
                            ), 
                          ),
                        ),
                      ),
                    ),

                    //Password
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize*1.6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                      padding: EdgeInsets.only(left: 20),
                      //height: SizeConfig.blockSizeVertical*6,
                      decoration: BoxDecoration(
                        color: (password.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: (password.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                          width: 1
                        )
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                          controller: password,
                          obscureText: isVisible,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (val){
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter password',
                            hintStyle: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal : SizeConfig.blockSizeHorizontal*2, vertical: SizeConfig.blockSizeVertical*2),
                                height: SizeConfig.blockSizeVertical*2,
                                width: SizeConfig.blockSizeVertical*2,
                                child: Icon(
                                  (!isVisible) ? Icons.visibility : Icons.visibility_off,
                                  size: SizeConfig.blockSizeVertical*2,
                                ),
                              ),
                            ), 
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 1.5),
                      child: GestureDetector(
                        onTap: (){
                          Get.to(const ForgotPassword());
                        },
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize * 1.6,
                            color: Constants.appThemeColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: signInPressed,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *4),
                        height: SizeConfig.blockSizeVertical*6.3,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize*1.6,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ),
                    ),

                    // Container(
                    //   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
                    //   child: Text(
                    //     'Or using other method',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontSize: SizeConfig.fontSize*1.6,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.grey[400]!
                    //     ),
                    //   ),
                    // ),

                    // // socialIcon('Sign Up With Google', 'assets/google.png'),
                    // // SizedBox(height: SizeConfig.blockSizeVertical *2,),
                    // // socialIcon('Sign Up With Facebook', 'assets/fb.png')
                    // Container(
                    //   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 6),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       GestureDetector(
                    //         onTap: (){
                    //           SocialLoginController().googleSignIn();
                    //         },
                    //         child:  FaIcon(FontAwesomeIcons.google, size: SizeConfig.blockSizeVertical * 4, color: Constants.appThemeColor,)
                    //       ),
                    //       SizedBox(width: SizeConfig.blockSizeHorizontal * 6,),
                    //       GestureDetector(
                    //         onTap: (){
                    //           SocialLoginController().signInWithFacebook();
                    //         },
                    //         child:  FaIcon(FontAwesomeIcons.facebook, size: SizeConfig.blockSizeVertical * 4, color: Constants.appThemeColor,)
                    //       ),
                    //       if(Platform.isIOS)            
                    //       Container(
                    //         margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6, bottom: SizeConfig.blockSizeVertical*0.5),
                    //         child: GestureDetector(
                    //           onTap: (){
                    //           SocialLoginController().signInApple();
                    //         },
                    //           child:  FaIcon(FontAwesomeIcons.apple, size: SizeConfig.blockSizeVertical * 5, color: Constants.appThemeColor,)
                    //         ),
                    //       ), 
                    //       Container(
                    //         margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6,),
                    //         child: GestureDetector(
                    //           onTap: (){
                    //             SocialLoginController().signInTwitter();
                    //           },
                    //           child:  FaIcon(FontAwesomeIcons.twitter, size: SizeConfig.blockSizeVertical * 4.5, color: Constants.appThemeColor,)
                    //         ),
                    //       ), 
                    //     ],
                    //   ),
                    // )
                  
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 6,
        color: Colors.white,
        child: Center(
          child: Align(
            alignment: Alignment.topCenter,
            child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Don\'t have an account ?',
              style: GoogleFonts.poppins(color: Color(0XFF9A97AD), fontSize: SizeConfig.fontSize * 1.6),
              children: <TextSpan>[
                TextSpan(
                  text: ' Register Now',
                  style: GoogleFonts.poppins(
                    color: Constants.appThemeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.fontSize *1.6,
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () {
                      Get.to(const SignUpScreen());
                    }
                  )
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget socialIcon(String title, String image){
    return GestureDetector(
      child: Container(
        height: SizeConfig.blockSizeVertical*6.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color(0XFFE1E0E6),
            width: 1
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.blockSizeVertical*2.8,
              width: SizeConfig.blockSizeVertical*2.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.contain
                )
              ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF171B2E),
                fontSize: SizeConfig.fontSize*1.6,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        )
      ),
    );
  } 
}
