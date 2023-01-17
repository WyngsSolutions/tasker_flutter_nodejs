// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sized_box_for_whitespace, avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/login_screen/login_screen.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({ Key? key }) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  
  TextEditingController currentPassword = TextEditingController();   
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteAccount() async {
    if(currentPassword.text.isEmpty)
      Constants.showDialog('Enter your current password');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      await deleteUser();
      EasyLoading.dismiss();
    }
  }

  Future deleteUser() async {
    try {
      User user = _auth.currentUser!;
      AuthCredential credentials = EmailAuthProvider.credential(email: Constants.appUser.email, password: currentPassword.text);
      print(user);
      UserCredential result = await user.reauthenticateWithCredential(credentials);
      await deleteuser(result.user!.uid);
      await result.user!.delete();
      Get.offAll(LoginScreen());
      Constants.showDialog("Your account has been deleted");
      return true;
    } 
    on FirebaseAuthException catch (e) {
      if(e.code.toString() == "wrong-password")
        Constants.showDialog('Your entered password is wrong');
    }
    catch(e){
      print(e.toString());
    }
  }
 
  Future deleteuser(String userId) {
    return userCollection.doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isMobile = shortestSide < 600;
    return Scaffold(
      backgroundColor: Colors.white,
      //drawer: homeDrawer(),
      appBar: AppBar(
        toolbarHeight: (isMobile) ? kToolbarHeight : 80,
        backgroundColor: Constants.appThemeColor,
        title: Text('Delete Acount', style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize*2.2),),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*4, left: SizeConfig.blockSizeHorizontal*5, right: SizeConfig.blockSizeHorizontal*5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Container(
              height: SizeConfig.blockSizeVertical * 8,
              child: Center(
                child: Text(
                  'Enter your current password\nto delete account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize*1.9,
                    fontWeight: FontWeight.bold,
                    color: Constants.appThemeColor
                  ),
                ),
              ),
            ),

            
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
              padding: EdgeInsets.only(left: 20),
              //height: SizeConfig.blockSizeVertical*6,
              decoration: BoxDecoration(
                color: (currentPassword.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: (currentPassword.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                  width: 1
                )
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                  controller: currentPassword,
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
              onTap: deleteAccount,
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *4),
                height: SizeConfig.blockSizeVertical*6.3,
                decoration: BoxDecoration(
                  color: Constants.appThemeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Delete',
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
    );
  }
}