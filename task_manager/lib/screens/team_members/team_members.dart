// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, curly_braces_in_flow_control_structures
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/my_controller.dart';
import '../../utils/color.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../add_member/add_members.dart';
import '../edit_member/edit_member.dart';

class TeamMembers extends StatefulWidget {

  @override
  State<TeamMembers> createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
 
  List allMembers = [];
 
  @override
  void initState() {
    super.initState();
    getAllMembers();
  }

  void getAllMembers()async{
    allMembers.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await MyController().getMembers();
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
        allMembers = result['Members'];
        print(allMembers.length);
     });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  void deleteMember(Map memberDetail, int index)async{
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await MyController().deleteMember(memberDetail);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       allMembers.removeAt(index);
     });
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
          'All Members',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: SizeConfig.fontSize *2.1,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3, 0, SizeConfig.blockSizeHorizontal*3, 10),
        child: (allMembers.isEmpty) ? Container(
          child: Center(
            child: Text(
              'No Members Found',
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 2.4,
                color: Colors.grey[400],
              ),
            ),
          ),
        ) : ListView.builder(
          itemCount: allMembers.length,
          itemBuilder: (_, i) {
            return memberCell(allMembers[i], i);
          },
          shrinkWrap: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: const Icon(Icons.add),
        backgroundColor: Constants.appThemeColor,
        onPressed: () async {
          dynamic result = await Get.to(AddMemberScreen());
          if(result != null)
            getAllMembers();
        }
      ),
    );
  }

  Widget memberCell(Map memberDetail, int index){
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, left: 5, right: 5),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 3, vertical: SizeConfig.blockSizeVertical *1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[100]!
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical*7,
            width: SizeConfig.blockSizeVertical*7,
            margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (memberDetail['avatar'] =="") ? AssetImage('assets/user.png') : CachedNetworkImageProvider(memberDetail['avatar']) as ImageProvider,
                fit: BoxFit.cover
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.blockSizeVertical * 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${memberDetail['name']}',
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize * 1.8,
                            color: Constants.appThemeColor,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width*0.50,
                        blurSize: 5.0,
                        menuItemExtent: 45,
                        menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        duration: Duration(milliseconds: 100),
                        animateMenuItems: true,
                        blurBackgroundColor: Colors.black54,
                        bottomOffsetHeight: 100,
                        openWithTap: true,
                        menuItems: [
                          
                          FocusedMenuItem(
                            backgroundColor: Colors.white,
                            title: Text("Edit", style: TextStyle(color: appPrimaryColor),),
                            trailingIcon: Icon(Icons.edit, color: Constants.appThemeColor),
                            onPressed: () async {
                              dynamic result = await Get.to(EditMemberScreen( memberSelected: memberDetail,));
                              if(result != null)
                                getAllMembers();
                            }
                          ),
          
                          FocusedMenuItem(
                            backgroundColor: Colors.white,
                            title: Text("Delete", style: TextStyle(color: appPrimaryColor),),
                            trailingIcon: Icon(Icons.delete, color: appPrimaryColor),
                            onPressed: (){
                              deleteMember(memberDetail, index);
                            }
                          ),
                        ],
                        onPressed: (){},
                        child: Container(
                          child: Icon(Icons.more_vert_outlined,color:  Colors.grey[400], size: SizeConfig.blockSizeHorizontal * 5,)
                        ),
                      ),
                    ],
                  ),
                ),
          
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0),
                  child: Text(
                    '${memberDetail['email']}',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 1.6,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      )
    );
  }
}