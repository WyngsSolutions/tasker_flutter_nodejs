// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/my_controller.dart';
import 'package:task_manager/utils/constants.dart';
import '../../utils/size_config.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({ Key? key }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void submitPressed() async
  {
    if(email.text.isEmpty)
      Constants.showDialog("Please enter email");
    else if(!GetUtils.isEmail(email.text))
      Constants.showDialog("Please enter valid email");
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      dynamic result =  await MyController().forgotPassword(email.text);
      EasyLoading.dismiss();
      if(result['Status'] == 'Success'){
        Get.back();
        Constants.showDialog('An email with instructions to reset your password is sent on your email address');
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
                              'Forgot Password',
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
                    
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, left: 20, right: 20),
                      child: Text(
                        'Please enter the email address registered to your aaccount so we can send you password reset instructions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize * 1.7,
                          color: Constants.appThemeColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    //Email
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
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

                    GestureDetector(
                      onTap: submitPressed,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *4),
                        height: SizeConfig.blockSizeVertical*6.3,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize*1.6,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ),
                    ),

                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

  