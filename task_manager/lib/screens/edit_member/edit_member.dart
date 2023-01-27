import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/controllers/my_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class EditMemberScreen extends StatefulWidget {

  final Map memberSelected;
  const EditMemberScreen({ Key? key, required this.memberSelected }) : super(key: key);

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  //PHOTO
  XFile? image;
  String imagePath = "";
  final ImagePicker picker = ImagePicker();
  String memberImageUrl = "";

  @override
  void initState() {
    super.initState();
    name.text = widget.memberSelected['name'];
    email.text = widget.memberSelected['email'];
    memberImageUrl = widget.memberSelected['avatar'];
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    if(pickedFile!.path != null)
    {
      setState(() {
        image = pickedFile;
        imagePath = pickedFile.path;
      });
    }
  }
  
  void editMember()async{
    if(name.text.isEmpty)
      Constants.showDialog('Please enter member name');
    else if(email.text.isEmpty)
      Constants.showDialog('Please enter member email');
    else
    { 
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      dynamic result = await MyController().editTeamMember(widget.memberSelected, name.text, email.text, (image == null) ? null : File(image!.path));
      EasyLoading.dismiss();
      if(result['Status'] == 'Success')
      {
        Get.back(result: true);
        Constants.showDialog('Member has been edited successfully');
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  void deleteMember()async{
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await MyController().deleteMember(widget.memberSelected);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
      Get.back(result: true);
      Constants.showDialog('Member has been deleted successfully');
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
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
          'Edit Member',
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
              child: GestureDetector(
                onTap: getImage,
                child: Container(
                  height: SizeConfig.blockSizeVertical*18,
                  width: SizeConfig.blockSizeVertical*18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 5
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: (image != null) ? FileImage(File(imagePath)) : (memberImageUrl.isEmpty) ? AssetImage('assets/user.png') : CachedNetworkImageProvider(memberImageUrl) as ImageProvider,
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical *2, left: SizeConfig.blockSizeHorizontal *7, right: SizeConfig.blockSizeHorizontal *7, bottom: SizeConfig.blockSizeVertical *5),
        height: SizeConfig.blockSizeVertical*6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: editMember,
              child: Container(
                height: SizeConfig.blockSizeVertical * 6,
                width: SizeConfig.blockSizeHorizontal*40,
                decoration: BoxDecoration(
                  color: Constants.appThemeColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child : Center(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 1.7,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
      
            GestureDetector(
              onTap: deleteMember,
              child: Container(
                height: SizeConfig.blockSizeVertical * 6,
                width: SizeConfig.blockSizeHorizontal*40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Constants.appThemeColor,
                  )
                ),
                child : Center(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 1.7,
                      color: Constants.appThemeColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}