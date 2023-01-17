// ignore_for_file: unused_local_variable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/delete_account/delete_account.dart';
import 'package:task_manager/screens/login_screen/login_screen.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../edit_screen/edit_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isMobile = shortestSide < 600;
    return Scaffold(
      backgroundColor: Colors.white,
      //drawer: homeDrawer(),
      appBar: AppBar(
        toolbarHeight: (isMobile) ? kToolbarHeight : 80,
        centerTitle: true,
        backgroundColor: Constants.appThemeColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: SizeConfig.fontSize * 2,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical*20,
              width: SizeConfig.blockSizeHorizontal*100,
              color: Constants.appThemeColor,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2,),
                    height: SizeConfig.blockSizeVertical*16,
                    width: SizeConfig.blockSizeVertical*16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 5
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: (Constants.appUser.userProfilePicture.isEmpty) ? AssetImage('assets/user.png') : CachedNetworkImageProvider(Constants.appUser.userProfilePicture) as ImageProvider,
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*15),
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3.5, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6, bottom: SizeConfig.blockSizeVertical*2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: SizeConfig.blockSizeVertical*3,),
                    optionCell(1 ,'Edit Profile', 'assets/edit_profile.png', true, true),
                    optionCell(2 ,'Contact Support', 'assets/change_password.png', true, true),
                    optionCell(3 ,'Share App', 'assets/notification2.png', true, true),
                    optionCell(4 ,'Delete account', 'assets/notification2.png', true, true),
                    optionCell(5 ,'Log out', 'assets/logout.png', false, false),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget optionCell(int optionId, String title, String image, bool showArrow, bool showDivider,){
    return GestureDetector(
      onTap: (){
        if(optionId == 1)
          Get.to(EditProfile());
        else if(optionId == 2)
          Get.to(EditProfile());
        else if(optionId == 3)
          Get.to(EditProfile());
        else if(optionId == 4)
          Get.to(DeleteAccount());
        else 
          showLogoutView();
      },
      child: Container(
        height: SizeConfig.blockSizeVertical*7.5,
        //color: Colors.white,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: (showDivider) ? Color(0XFFE1E0E6) : Colors.transparent
            )
          )
        ),
        child: Row(
          children: [
            // Container(
            //   height: SizeConfig.blockSizeVertical*2.8,
            //   width: SizeConfig.blockSizeVertical*2.8,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(image),
            //       fit: BoxFit.contain
            //     )
            //   ),
            // ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4),
                child: Text(
                  '$title',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: (showArrow) ?Color(0XFF171B2E) : Color(0XFFF65353),
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.fontSize*1.8
                  ),
                ),
              ),
            ),
    
            if(showArrow)
            Container(
              height: SizeConfig.blockSizeVertical*1.8,
              width: SizeConfig.blockSizeVertical*1.8,
              child: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: SizeConfig.blockSizeVertical*2.0),
            ),
          ],
        )
      ),
    );
  }


  void showLogoutView() async
  {
    dynamic result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (BuildContext bc){
        return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4, vertical: SizeConfig.blockSizeVertical*3),
            height: SizeConfig.blockSizeVertical*34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 2.0,
                      color: Color(0XFFF65353),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2),
                  color: Color(0XFFE1E0E6),
                ),

                Center(
                  child: Text(
                    'Are you sure you want to log out?',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 2.0,
                      color: Color(0XFF424242),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    await AppUser.deleteUserAndOtherPreferences();
                    Get.offAll(LoginScreen());
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *2, left: SizeConfig.blockSizeHorizontal *3, right: SizeConfig.blockSizeHorizontal *3),
                    height: SizeConfig.blockSizeVertical*6,
                    decoration: BoxDecoration(
                      color: Constants.appThemeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Yes, Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.fontSize*1.7,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *1.5, left: SizeConfig.blockSizeHorizontal *3, right: SizeConfig.blockSizeHorizontal *3),
                    height: SizeConfig.blockSizeVertical*6,
                    decoration: BoxDecoration(
                      color: Color(0XFFF0EFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Constants.appThemeColor,
                          fontSize: SizeConfig.fontSize*1.7,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          );
        });
      }
    );
  }
}
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Constants.appThemeColor,
//         title: Text('Settings', style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize*2.2),),
//         elevation: 0,
//       ),
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5, vertical: SizeConfig.blockSizeVertical*1),
//         child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(
//             height: SizeConfig.blockSizeVertical * 20,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: AssetImage('assets/logo.jpeg'),
//                 fit: BoxFit.contain
//               )
//             ),
//           ),

//           GestureDetector(
//             onTap: (){
//               Get.to(EditProfile());
//             },
//             child: Icon(Icons.account_circle_rounded, color: Colors.white, size: SizeConfig.blockSizeVertical * 4)
//           ),

//           GestureDetector(
//             onTap: () async {
//             },
//             child: Container(
//              // color: Colors.red,
//               height: SizeConfig.blockSizeVertical * 7,
//               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
//               child: Row(
//                 children: [
//                 Container(
//                   child: Icon(Icons.share, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical * 3,)
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *4),
//                   child: Text(
//                     'Share App',
//                     style: TextStyle(
//                       color: Constants.appThemeColor,
//                       fontSize: SizeConfig.fontSize * 1.8,
//                       fontWeight: FontWeight.bold
//                     ),
//                   ),
//                 ),
//                 ],
//               )
//             ),
//           ),

//           GestureDetector(
//             onTap: () async {
//             },
//             child: Container(
//               //color: Colors.red,
//               height: SizeConfig.blockSizeVertical * 7,
//               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
//               child: Row(
//                 children: [
//                 Container(
//                   child: Icon(Icons.email, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical * 3,)
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *4),
//                   child: Text(
//                     'Contact Support',
//                     style: TextStyle(
//                       color: Constants.appThemeColor,
//                       fontSize: SizeConfig.fontSize * 1.8,
//                       fontWeight: FontWeight.bold
//                     ),
//                   ),
//                 ),
//                 ],
//               )
//             ),
//           ),

//           GestureDetector(
//             onTap: () async {
//             },
//             child: Container(
//               //color: Colors.red,
//               height: SizeConfig.blockSizeVertical * 7,
//               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
//               child: Row(
//                 children: [
//                 Container(
//                   child: Icon(Icons.logout, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical * 3,)
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *4),
//                   child: Text(
//                     'Logout',
//                     style: TextStyle(
//                       color: Constants.appThemeColor,
//                       fontSize: SizeConfig.fontSize * 1.8,
//                       fontWeight: FontWeight.bold
//                     ),
//                   ),
//                 ),
//                 ],
//               )
//             ),
//           ),
          
//           ],
//         ) ,
//       ),
//     );
//   }
// }