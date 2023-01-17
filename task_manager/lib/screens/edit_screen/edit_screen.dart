// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({ Key? key }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController name = TextEditingController(text: Constants.appUser.name);
  TextEditingController email = TextEditingController(text: Constants.appUser.email);

  @override
  void initState() {
    super.initState();
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
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_sharp,
            size: SizeConfig.blockSizeVertical*2.9,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: SizeConfig.fontSize *2.1,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Center(
              child: Container(
                height: SizeConfig.blockSizeVertical*18,
                width: SizeConfig.blockSizeVertical*18,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*0.5),
                      height: SizeConfig.blockSizeVertical *4,
                      width: SizeConfig.blockSizeVertical *4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constants.appThemeColor,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: SizeConfig.blockSizeVertical *2.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Username
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
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
              padding: EdgeInsets.only(left: 20),
              //height: SizeConfig.blockSizeVertical*6,
              decoration: BoxDecoration(
                color: (name.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: (name.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                  width: 1
                )
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                  controller: name,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (val){
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your username',
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

            //Current Password
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
              padding: EdgeInsets.only(left: 20),
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
                  style: TextStyle(fontSize: SizeConfig.fontSize*1.6, color: Colors.grey),
                  controller: email,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (val){
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
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
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          Get.back();
        },
        child: Container(
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *2, left: SizeConfig.blockSizeHorizontal *7, right: SizeConfig.blockSizeHorizontal *7, bottom: SizeConfig.blockSizeVertical *5),
          height: SizeConfig.blockSizeVertical*6,
          decoration: BoxDecoration(
            color: Constants.appThemeColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.fontSize*1.7,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ),
      ),
    );
  }
}
  // TextEditingController name = TextEditingController(text: Constants.appUser.name);
  // TextEditingController email = TextEditingController(text: Constants.appUser.email);

  // @override
  // void initState() {
  //   super.initState();
  //   //AdsController().showInterstitialAd();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: appPrimaryColor,
  //     appBar: PreferredSize(
  //       preferredSize: Size(0, SizeConfig.blockSizeVertical * 15),
  //       child: Container(
  //         margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7, left: SizeConfig.blockSizeHorizontal*4),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //               },
  //               child: Icon(Icons.arrow_back, color: appSecondaryColor, size: SizeConfig.blockSizeVertical * 4)
  //             ),
  //             SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),
  //             Text(
  //               'Edit Profile',
  //               style: TextStyle(
  //                 fontSize: SizeConfig.fontSize * 3.2,
  //                 color: appSecondaryColor,
  //                 fontWeight: FontWeight.bold
  //               ),
  //             ),
  //           ],
  //         )
  //       )
  //     ),
  //     body: Stack(
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),
  //           padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal* 8, vertical: SizeConfig.blockSizeVertical * 0),
  //           color: Colors.white,
  //           height: SizeConfig.blockSizeVertical* 75,
  //           width: SizeConfig.blockSizeHorizontal* 100,
  //           child: Column( 
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [

  //               Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 10),
  //                 child: Text(
  //                   Constants.appUser.name,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: SizeConfig.fontSize * 3.2,
  //                     color: appPrimaryColor,
  //                     fontWeight: FontWeight.bold
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 5),
  //                 child: Text(
  //                   'Name',
  //                   style: TextStyle(
  //                     fontSize: SizeConfig.fontSize * 2,
  //                     color: appSecondaryColor,
  //                     fontWeight: FontWeight.w500
  //                   ),
  //                 ),
  //               ),

  //               Container(
  //                 height: SizeConfig.blockSizeVertical * 5,
  //                 padding: const EdgeInsets.only(bottom: 5),
  //                 decoration: BoxDecoration(
  //                   border: Border(
  //                     bottom: BorderSide(
  //                       width: 1,
  //                       color: appPrimaryColor
  //                     )
  //                   )
  //                 ),
  //                 child: TextField(
  //                   controller: name,
  //                   readOnly: true,
  //                   enabled: false,
  //                   style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: appPrimaryColor, fontWeight: FontWeight.bold),
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                     hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
  //                     border: InputBorder.none
  //                   ),
  //                 ),
  //               ),

  //               Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
  //                 child: Text(
  //                   'Email',
  //                   style: TextStyle(
  //                     fontSize: SizeConfig.fontSize * 2,
  //                      color: appSecondaryColor,
  //                     fontWeight: FontWeight.w500
  //                   ),
  //                 ),
  //               ),

  //               Container(
  //                 height: SizeConfig.blockSizeVertical * 5,
  //                 padding: const EdgeInsets.only(bottom: 5),
  //                 decoration: BoxDecoration(
  //                   border: Border(
  //                     bottom: BorderSide(
  //                       width: 1,
  //                       color: appPrimaryColor
  //                     )
  //                   )
  //                 ),
  //                 child: TextField(
  //                   style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: appPrimaryColor, fontWeight: FontWeight.bold),
  //                   controller: email,
  //                   readOnly: true,
  //                   enabled: false,
  //                   decoration: InputDecoration(
  //                     hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
  //                     border: InputBorder.none
  //                   ),
  //                 ),
  //               ),
  //             ]
  //           )
  //         )
  //       ],
  //     )
  //   );
  // }
//}