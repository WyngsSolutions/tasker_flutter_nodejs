// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/app_user.dart';
import 'package:task_manager/screens/calendar_view/calendar_screen.dart';
import 'package:task_manager/screens/chat_screen/chat_screen.dart';
import 'package:task_manager/screens/discussion_board/discussion_detail.dart';
import 'package:task_manager/screens/edit_screen/edit_screen.dart';
import 'package:task_manager/screens/edit_task_screen/edit_task_screen.dart';
import 'package:task_manager/screens/login_screen/login_screen.dart';
import 'package:task_manager/screens/signup_screen/signup_screen.dart';
import 'package:task_manager/screens/team_members/team_members.dart';
import '../../controllers/app_controller.dart';
import '../../utils/color.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../add_task_screen/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key.
  List allTasks = [];
  // late BannerAd bannerAd;
  // bool bannerAdIsLoaded = false;
  // late NativeAd nativeAd;
  // bool nativeAdIsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
    getAllTasks();
  }

  void loadBannerAd(){
    // bannerAd = BannerAd(
    //   size: AdSize.banner,
    //   adUnitId: Platform.isAndroid
    //       ? 'ca-app-pub-3940256099942544/6300978111'
    //       : 'ca-app-pub-3940256099942544/2934735716',
    //   listener: BannerAdListener(
    //     onAdLoaded: (Ad ad) {
    //       print('$BannerAd loaded.');
    //       setState(() {
    //         bannerAdIsLoaded = true;            
    //       });
    //     },
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       print('$BannerAd failedToLoad: $error');
    //       ad.dispose();
    //     },
    //     onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
    //     onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
    //   ),
    //   request: AdRequest())
    // ..load();

    // nativeAd = NativeAd(
    //   adUnitId: Platform.isAndroid
    //     ? 'ca-app-pub-3940256099942544/2247696110'
    //     : 'ca-app-pub-3940256099942544/3986624511',
    //   request: AdRequest(),
    //   factoryId: 'listTile',
    //   listener: NativeAdListener(
    //     onAdLoaded: (Ad ad) {
    //       print('$NativeAd loaded.');
    //       setState(() {
    //         nativeAdIsLoaded = true;
    //       });
    //     },
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       print('$NativeAd failedToLoad: $error');
    //       ad.dispose();
    //     },
    //     onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
    //     onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
    //   ),
    // )..load();
  }

  @override
  void dispose() {
    super.dispose();;
  }

  void getAllTasks()async{
    allTasks.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().getAllUserTasks(allTasks);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       print(allTasks.length);
     });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  void deleteTasks(Map taskDetail, int index)async{
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().deleteTask(taskDetail);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       allTasks.removeAt(index);
     });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isMobile = shortestSide < 600;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      //drawer: homeDrawer(),
      appBar: AppBar(
        toolbarHeight: (isMobile) ? kToolbarHeight : 80,
        backgroundColor: Constants.appThemeColor,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: SizeConfig.fontSize * 2,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [

          GestureDetector(
            onTap: (){
              Get.to(CalendarScreen(allTasks: allTasks));
            },
            child: Icon(Icons.calendar_month, color: Colors.white, size: SizeConfig.blockSizeVertical * 3)
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
        ],
      ),
      // appBar: PreferredSize(
      //   preferredSize: Size(0, SizeConfig.blockSizeVertical * 15),
      //   child: Container(
      //     margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7, left: SizeConfig.blockSizeHorizontal*3, right: SizeConfig.blockSizeHorizontal*4),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           children: [
      //             // GestureDetector(
      //             //   onTap: (){
      //             //     _key.currentState!.openDrawer();
      //             //   },
      //             //   child: Icon(Icons.menu, color: appPrimaryColor, size: SizeConfig.blockSizeVertical * 4)
      //             // ),
      //             Container(
      //               margin: EdgeInsets.only(left: 15),
      //               child: Text(
      //                 'All Tasks',
      //                 style: TextStyle(
      //                   fontSize: SizeConfig.fontSize * 3.2,
      //                   color: Constants.appThemeColor,
      //                   fontWeight: FontWeight.bold
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         Row(
      //           children: [
      //             GestureDetector(
      //               onTap: (){
      //                 Get.to(CalendarScreen(allTasks: allTasks));
      //               },
      //               child: Icon(Icons.calendar_month, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical * 4)
      //             ),
      //             SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
      //             GestureDetector(
      //               onTap: (){
      //                 Get.to(EditProfile());
      //               },
      //               child: Icon(Icons.account_circle_rounded, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical * 4)
      //             ),
      //           ],
      //         )
      //       ],
      //     )
      //   )
      // ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3, 0, SizeConfig.blockSizeHorizontal*3, 10),
        child: (allTasks.isEmpty) ? Container(
          child: Center(
            child: Text(
              'No Tasks Found',
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 2.4,
                color: Colors.grey[400],
              ),
            ),
          ),
        ) : ListView.builder(
          itemCount: allTasks.length,
          itemBuilder: (_, i) {
            // if(i == allTasks.length && nativeAdIsLoaded)
            //   return Container(
            //       margin: EdgeInsets.symmetric(vertical: 20),
            //       width: 250, 
            //       height: (Platform.isIOS) ? 350 : 80, 
            //       child: AdWidget(ad: nativeAd
            //     )
            //   );
            // else if(i == allTasks.length && !nativeAdIsLoaded)
            //   return Container();
            // else 
              return taskCell(allTasks[i], i);
          },
          shrinkWrap: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: const Icon(Icons.add),
        backgroundColor: Constants.appThemeColor,
        onPressed: () async {
          dynamic result = await Get.to(const AddTask());
          if(result != null)
            getAllTasks();
        }
      ),
      // bottomNavigationBar: Container(
      //   height: (!bannerAdIsLoaded) ? 0 : bannerAd.size.height.toDouble(),
      //   width: double.infinity,
      //   child: AdWidget(ad: bannerAd)
      // )
    );
  }

  Widget taskCell(Map taskDetail, int index){
    DateTime taskDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskDetail['taskDate'].toString());
    String timeOnly = DateFormat("HH:mm aa").format(taskDate);
    String dateOnly = DateFormat("dd MMM, yyyy").format(taskDate);
    Map member = (taskDetail['member'] == null) ? {} : taskDetail['member'];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: SizeConfig.blockSizeVertical*6,
                        width: SizeConfig.blockSizeVertical*6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: (member['memberPhoto'] == "") ? AssetImage('assets/user.png') : CachedNetworkImageProvider(member['memberPhoto']) as ImageProvider,
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2),
                    child: Text(
                      '${taskDetail['taskTitle']}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: appPrimaryColor,
                        fontWeight: FontWeight.w700
                      ),
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
                      title: Text("Discussion room", style: TextStyle(color: appPrimaryColor),),
                      trailingIcon: Icon(Icons.chat_rounded, color: appPrimaryColor),
                      onPressed: (){
                        gotoDiscussionRoom(taskDetail);
                      }
                    ),

                    FocusedMenuItem(
                      backgroundColor: Colors.white,
                      title: Text("Edit", style: TextStyle(color: appPrimaryColor),),
                      trailingIcon: Icon(Icons.edit, color: appPrimaryColor),
                      onPressed: () async {
                        dynamic result = await Get.to(EditTask(taskDetail: taskDetail,));
                        if(result != null)
                          getAllTasks();
                      }
                    ),

                    FocusedMenuItem(
                      backgroundColor: Colors.white,
                      title: Text("Delete", style: TextStyle(color: appPrimaryColor),),
                      trailingIcon: Icon(Icons.delete, color: appPrimaryColor),
                      onPressed: (){
                        deleteTasks(taskDetail, index);
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
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
            child: Text(
              '${taskDetail['taskDescription']}',
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 1.7,
                color: Colors.grey[500],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.alarm, color: Colors.grey[400], size: SizeConfig.blockSizeVertical * 2.5,),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                    Text(
                      '$timeOnly',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 7,),
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.grey[400], size: SizeConfig.blockSizeVertical * 2.5,),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                    Text(
                      '$dateOnly',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //if(member.isNotEmpty)
          
        ],
      ),
    );
  }

  // Future<void> gotoChatRoom(Map taskDetail) async {
  //   String taskId = taskDetail['taskId'];
  //   String taskName = taskDetail['taskTitle'];
  //   String taskOwnerId = taskDetail['userId'];
  //   print(taskName);
  //   List taskMembers = [taskDetail['member']];
  //   AppUser taskOwner = await AppUser.getUserDetailByUserId(taskOwnerId);
  //   Get.to(ChatScreen(taskOwner: taskOwner, taskId: taskId, taskName: taskName, taskOwnerId : taskOwnerId, taskMembers: taskMembers,));
  // }

  Future<void> gotoDiscussionRoom(Map taskDetail) async {
    Get.to(DiscussionDetail(task: taskDetail));
  }
}