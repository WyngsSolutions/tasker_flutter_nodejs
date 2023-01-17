// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, avoid_print
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/models/app_user.dart';
import '../../utils/color.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class TaskCategories extends StatefulWidget {
  const TaskCategories({ Key? key }) : super(key: key);

  @override
  State<TaskCategories> createState() => _TaskCategoriesState();
}

class _TaskCategoriesState extends State<TaskCategories> {

  Color oddColor = Color(0XFFbddae6);
  Color evenColor = Color(0XFFcfe0b1);
  List allCategories = [];

  @override
  void initState() {
    super.initState();
    allCategories = List.from(Constants.appUser.myCategories);
  }

  void showAddCategoryView() {
    String categoryName = "";
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          'Add Category',
          style: TextStyle(
            color: appPrimaryColor,
            fontSize: SizeConfig.fontSize * 2.4,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          child: MediaQuery.removePadding(
            context: context,
            removeTop : true,
            child: ListView(
              shrinkWrap : true,
              children: [
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, left: 10),                   
                  child: Text(
                    'Category name',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: SizeConfig.fontSize * 1.6
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 8,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2),
                      onChanged: (val){
                        categoryName = val;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: 'Enter category name',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              if(categoryName.isNotEmpty)
              {
                Get.back();
                addCategory(categoryName);
              }
              else
                Constants.showDialog('Enter category name');
            },
            child: Text('Add')
          )
        ],
      )
    );
  }  

  void addCategory(String category)async{
    allCategories.add(category);
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppUser.updateUserProfile(Constants.appUser.name, Constants.appUser.userProfilePicture, allCategories);
    EasyLoading.dismiss();
    if(result)
    {
      print('Category Added');
      Constants.appUser.myCategories = List.from(allCategories);
    }
    else
    {
      allCategories.removeLast();
      Constants.showDialog(result['ErrorMessage']);
    }

    setState(() {});
  }

  void deleteCategory(int index)async{
    allCategories.removeAt(index);
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppUser.updateUserProfile(Constants.appUser.name, Constants.appUser.userProfilePicture, allCategories);
    EasyLoading.dismiss();
    if(result)
    {
      print('Category deleted');
      Constants.appUser.myCategories = List.from(allCategories);
    }
    else
    {
      allCategories.removeLast();
      Constants.showDialog(result['ErrorMessage']);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isMobile = shortestSide < 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: (isMobile) ? kToolbarHeight : 80,
        backgroundColor: Constants.appThemeColor,
        centerTitle: true,
        title: Text(
          'Task Categories',
          style: TextStyle(
            fontSize: SizeConfig.fontSize * 2,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*5, 0, SizeConfig.blockSizeHorizontal*5, 10),
                child: ListView.builder(
                  itemBuilder: (_, i) {
                    if(i < allCategories.length)
                      return categoryCell(i);
                    else
                      return categoryAddCell();
                  },
                  shrinkWrap: true,
                  itemCount: allCategories.length + 1,
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar:  GestureDetector(
      //   //onTap: signInPressed,
      //   child: Container(
      //     margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, left: SizeConfig.blockSizeHorizontal * 6, right: SizeConfig.blockSizeHorizontal * 6, bottom:  SizeConfig.blockSizeVertical*3),
      //     height: SizeConfig.blockSizeVertical * 7.5,
      //     decoration: BoxDecoration(
      //       color: appSecondaryColor,
      //       borderRadius: BorderRadius.circular(5)
      //     ),
      //     child : Center(
      //       child: Text(
      //         'Update List',
      //         style: TextStyle(
      //           fontSize: SizeConfig.fontSize * 2.0,
      //           color: Colors.white,
      //           fontWeight: FontWeight.w600
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget categoryCell(int index){
    return GestureDetector(
      onTap: (){
        Get.back(result: allCategories[index]);
      },
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),  
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Constants.appThemeColor,
            width: 0.5
          )
        ), 
        height: SizeConfig.blockSizeVertical* 7.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '${allCategories[index]}',
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 1.9,
                  color: appPrimaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            GestureDetector(
              onTap: (){
                deleteCategory(index);
              },
              child: Icon(Icons.delete_outline, color: appPrimaryColor, size: SizeConfig.blockSizeVertical*3,)
            ),
          ],
        )
      ),
    );
  }

  Widget categoryAddCell(){
    return GestureDetector(
      onTap: showAddCategoryView,
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),  
        child: DottedBorder(
          strokeWidth: 1,
          color: appPrimaryColor,
          dashPattern: const [10], 
          padding: EdgeInsets.all(5),
          child: Container(
            height: SizeConfig.blockSizeVertical*6,
            child: Center(
              child: Icon(Icons.add, color: appPrimaryColor, size: SizeConfig.blockSizeVertical*3,),
            ),
          ),
        ),
      ),
    );
  }
}