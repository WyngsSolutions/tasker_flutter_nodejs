// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/social_login_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../login_screen/login_screen.dart';
import '../navigation_view/navigation_view.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;

  Future<void> signUpPressed() async {
    if(username.text.isEmpty)
      Constants.showDialog('Please enter username');
    else if(email.text.isEmpty)
      Constants.showDialog('Please enter email address');
    else if(!GetUtils.isEmail(email.text))
      Constants.showDialog('Please enter a valid email address');
    else if(password.text.isEmpty)
      Constants.showDialog('Please enter password');
    else if(password.text.length<8)
      Constants.showDialog('Password should be atleast 8 letters');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().signUpUser(username.text, email.text, password.text,);
      EasyLoading.dismiss();
      if (result['Status'] == "Success") 
        Get.offAll(const NavigationView(defaultPage: 0,));
      else
        Constants.showDialog(result['ErrorMessage']);
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
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical*3,
                            width: SizeConfig.blockSizeVertical*3,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/arrow_back.png'),
                                fit: BoxFit.contain
                              )
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.fontSize*2.4
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical *3,
                          width: SizeConfig.blockSizeVertical *3,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),


            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*18),
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3.5, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6, bottom: SizeConfig.blockSizeVertical*2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Username
                    Container(
                      child: Text(
                        'Username',
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
                        color: (username.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: (username.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                          width: 1
                        )
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                          controller: username,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (val){
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter username',
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

                    GestureDetector(
                      onTap: signUpPressed,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *4),
                        height: SizeConfig.blockSizeVertical*6.3,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize*1.6,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
                      child: Text(
                        'Or using other method',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize*1.6,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400]!
                        ),
                      ),
                    ),

                    // socialIcon('Sign Up With Google', 'assets/google.png'),
                    // SizedBox(height: SizeConfig.blockSizeVertical *2,),
                    // socialIcon('Sign Up With Facebook', 'assets/fb.png')
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              SocialLoginController().googleSignIn();
                            },
                            child:  FaIcon(FontAwesomeIcons.google, size: SizeConfig.blockSizeVertical * 4, color: Constants.appThemeColor,)
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal * 6,),
                          GestureDetector(
                            onTap: (){
                              SocialLoginController().signInWithFacebook();
                            },
                            child:  FaIcon(FontAwesomeIcons.facebook, size: SizeConfig.blockSizeVertical * 4, color: Constants.appThemeColor,)
                          ),
                          if(Platform.isIOS)            
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6, bottom: SizeConfig.blockSizeVertical*0.5),
                            child: GestureDetector(
                              onTap: (){
                              SocialLoginController().signInApple();
                            },
                              child:  FaIcon(FontAwesomeIcons.apple, size: SizeConfig.blockSizeVertical * 5, color: Constants.appThemeColor,)
                            ),
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6,),
                            child: GestureDetector(
                              onTap: (){
                                SocialLoginController().signInTwitter();
                              },
                              child:  FaIcon(FontAwesomeIcons.twitter, size: SizeConfig.blockSizeVertical * 4.5, color: Constants.appThemeColor,)
                            ),
                          ), 
                        ],
                      ),
                    )
                    
                  ],
                ),
              ),
            )
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
              text: 'Have an account?',
              style: GoogleFonts.poppins(color: Color(0XFF9A97AD), fontSize: SizeConfig.fontSize * 1.6),
              children: <TextSpan>[
                TextSpan(
                  text: ' Login ',
                  style: GoogleFonts.poppins(
                    color: Constants.appThemeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.fontSize *1.6,
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () {
                      Get.to(const LoginScreen());
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

// // ignore_for_file: curly_braces_in_flow_control_structures
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:task_manager/utils/constants.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../controllers/app_controller.dart';
// import '../../utils/color.dart';
// import '../../utils/size_config.dart';
// import '../home_screen/home_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({ Key? key }) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {

//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   void signUpPressed() async
//   {
//     if(name.text.isEmpty)
//       Constants.showDialog("Please enter name");
//     else if(email.text.isEmpty)
//       Constants.showDialog("Please enter email");
//     else if(!GetUtils.isEmail(email.text))
//       Constants.showDialog("Please enter valid email");
//     else if(password.text.isEmpty)
//       Constants.showDialog("Please enter password");
//     else if(password.text.length < 8)
//       Constants.showDialog("Password lenght should be atleast 8 characters");
//     else
//     {
//       EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
//       dynamic result =  await AppController().signUpUser(name.text, email.text, password.text);
//       EasyLoading.dismiss();
//       if(result['Status'] == 'Success'){
//         await Constants.appUser.saveUserDetails();
//         Get.offAll(const HomeScreen());
//       }
//       else{
//         Constants.showDialog(result['ErrorMessage']);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       backgroundColor: appPrimaryColor,
//       body: SingleChildScrollView(
//         child: GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: (){
//             print('close');
//             FocusScopeNode currentFocus = FocusScope.of(context);
//             if (!currentFocus.hasPrimaryFocus)
//               currentFocus.unfocus();
//           },
//           child: Container(
//             margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical*12, SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical* 2),
//             child: Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: [
//                 Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     fontSize: SizeConfig.fontSize * 3.5,
//                     color: appSecondaryColor,
//                     fontWeight: FontWeight.bold
//                   ),
//                 ),
                
              
//                 Container(
//                   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 8),
//                   child: Text(
//                     'Name',
//                     style: TextStyle(
//                       fontSize: SizeConfig.fontSize * 2,
//                       color: Colors.grey[300],
//                       fontWeight: FontWeight.w500
//                     ),
//                   ),
//                 ),
              
//                 Container(
//                   height: SizeConfig.blockSizeVertical * 5,
//                   padding: const EdgeInsets.only(bottom: 5),
//                   decoration: const BoxDecoration(
//                     //color: Colors.red,
//                     border: Border(
//                       bottom: BorderSide(
//                         width: 1,
//                         color: Colors.white
//                       )
//                     )
//                   ),
//                   child: TextField(
//                     controller: name,
//                     style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white,),
//                     decoration: InputDecoration(
//                       hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
//                       border: InputBorder.none
//                     ),
//                   ),
//                 ),
              
//                 Container(
//                   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
//                   child: Text(
//                     'Email Address',
//                     style: TextStyle(
//                       fontSize: SizeConfig.fontSize * 2,
//                       color: Colors.grey[300],
//                       fontWeight: FontWeight.w500
//                     ),
//                   ),
//                 ),
              
//                 Container(
//                   height: SizeConfig.blockSizeVertical * 5,
//                   padding: const EdgeInsets.only(bottom: 5),
//                   decoration: const BoxDecoration(
//                     //color: Colors.red,
//                     border: Border(
//                       bottom: BorderSide(
//                         width: 1,
//                         color: Colors.white
//                       )
//                     )
//                   ),
//                   child: TextField(
//                     controller: email,
//                     style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white,),
//                     decoration: InputDecoration(
//                       hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
//                       border: InputBorder.none
//                     ),
//                   ),
//                 ),
              
//                 Container(
//                   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
//                   child: Text(
//                     'Password',
//                     style: TextStyle(
//                       fontSize: SizeConfig.fontSize * 2,
//                       color: Colors.grey[300],
//                       fontWeight: FontWeight.w500
//                     ),
//                   ),
//                 ),
              
//                 Container(
//                   height: SizeConfig.blockSizeVertical * 5,
//                   padding: const EdgeInsets.only(bottom: 5),
//                   decoration: const BoxDecoration(
//                     //color: Colors.red,
//                     border: Border(
//                       bottom: BorderSide(
//                         width: 1,
//                         color: Colors.white
//                       )
//                     )
//                   ),
//                   child: TextField(
//                     controller: password,
//                     style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white,),
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
//                       border: InputBorder.none
//                     ),
//                   ),
//                 ),
              
//                 Container(
//                   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 5),
//                   child: Center(
//                     child: Align(
//                       alignment: Alignment.topCenter,
//                       child: RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         text: 'By continuing, you agree to our ',
//                         style: GoogleFonts.poppins(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: 'Terms of service',
//                             style: GoogleFonts.poppins(
//                               color: appSecondaryColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: SizeConfig.fontSize * 2.2
//                             ),
//                             recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                                 launch('http://wyngslogistics.com/#/policy');
//                               }
//                             ),
//                             TextSpan(
//                               text: ' and ',
//                               style: GoogleFonts.poppins(
//                                 color: appSecondaryColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: SizeConfig.fontSize * 2.2
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'Privacy Policy',
//                               style: GoogleFonts.poppins(
//                                 color: appSecondaryColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: SizeConfig.fontSize * 2.2
//                               ),
//                               recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                   launch('http://wyngslogistics.com/#/policy');
//                                 }
//                             )
//                           ]
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
              
//                 GestureDetector(
//                   onTap: signUpPressed,
//                   child: Container(
//                     margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),
//                     height: SizeConfig.blockSizeVertical * 7.5,
//                     decoration: BoxDecoration(
//                       color: appSecondaryColor,
//                       borderRadius: BorderRadius.circular(5)
//                     ),
//                     child : Center(
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           fontSize: SizeConfig.fontSize * 2.5,
//                           color: Constants.appThemeColor,
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
              
                
              
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: SizeConfig.safeBlockVertical * 5,
//         margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical*2, SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical* 2),
//         child: Center(
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               text: 'Already have an account ?',
//               style: GoogleFonts.poppins(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: ' Login',
//                   style: GoogleFonts.poppins(
//                     color: appSecondaryColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: SizeConfig.fontSize * 2.2
//                   ),
//                   recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                       Get.back();
//                     }
//                   )
//                 ]
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }