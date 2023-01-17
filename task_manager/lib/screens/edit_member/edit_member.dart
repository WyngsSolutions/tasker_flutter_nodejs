import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../controllers/ads_controllder.dart';
import '../../controllers/app_controller.dart';
import '../../utils/color.dart';
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
    //AdsController().showInterstitialAd();
    name.text = widget.memberSelected['memberName'];
    email.text = widget.memberSelected['memberEmail'];
    memberImageUrl = widget.memberSelected['memberPhoto'];
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

   Future<String> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(image!.path);
    final _firebaseStorage = FirebaseStorage.instance;
    //Upload to Firebase
    var snapshot = await _firebaseStorage.ref().child("member_pictures").child(fileName).putFile(File(image!.path));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  
  void editMember()async{
    if(name.text.isEmpty)
      Constants.showDialog('Please enter member name');
    else if(email.text.isEmpty)
      Constants.showDialog('Please enter member email');
    else
    { 
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      if(image != null)
        memberImageUrl = await uploadFile();
      dynamic result = await AppController().editMember(widget.memberSelected, name.text, email.text, memberImageUrl);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size(0, SizeConfig.blockSizeVertical * 15),
        child: Container(
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7, left: SizeConfig.blockSizeHorizontal*4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: appSecondaryColor, size: SizeConfig.blockSizeVertical * 4)
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),
              Text(
                'Edit Member',
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 3.2,
                  color: appSecondaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
        )
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal* 8, vertical: SizeConfig.blockSizeVertical * 0),
              color: Colors.white,
              height: SizeConfig.blockSizeVertical* 75,
              width: SizeConfig.blockSizeHorizontal* 100,
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
      
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 15),
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: appSecondaryColor,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
      
                  Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: appPrimaryColor
                        )
                      )
                    ),
                    child: TextField(
                      controller: name,
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: appPrimaryColor, fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
                        border: InputBorder.none
                      ),
                    ),
                  ),
      
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                         color: appSecondaryColor,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
      
                  Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: appPrimaryColor
                        )
                      )
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: appPrimaryColor, fontWeight: FontWeight.bold),
                      controller: email,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.grey[200],),
                        border: InputBorder.none
                      ),
                    ),
                  ),
      
                  GestureDetector(
                    onTap: editMember,
                    child: Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*8),
                      height: SizeConfig.blockSizeVertical * 7.5,
                      width: SizeConfig.blockSizeHorizontal*40,
                      decoration: BoxDecoration(
                        color: appSecondaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child : Center(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize * 2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
      
                ],
              ),
            ),
      
            GestureDetector(
              onTap: getImage,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10, left: ((SizeConfig.blockSizeHorizontal *100 - SizeConfig.blockSizeVertical * 20)/2)),
                height: SizeConfig.blockSizeVertical * 20,
                width: SizeConfig.blockSizeVertical * 20,
                decoration: BoxDecoration(
                  color: appSecondaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Colors.white
                  ),
                  image: DecorationImage(
                    image: (image != null) ? FileImage(File(imagePath)) : (memberImageUrl.isEmpty) ? AssetImage('assets/user.png') : CachedNetworkImageProvider(memberImageUrl) as ImageProvider,
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
      
          ],
        ),
      )
    );
  }
}