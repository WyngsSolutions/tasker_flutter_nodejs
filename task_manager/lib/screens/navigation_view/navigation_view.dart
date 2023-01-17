
// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps, avoid_print, use_key_in_widget_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/discussion_board/discussion_board.dart';
import 'package:task_manager/screens/home_screen/home_screen.dart';
import 'package:task_manager/screens/team_members/team_members.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../chatlist_screen/chatlist_screen.dart';
import '../settings_screen/settings_screen.dart';

class NavigationView extends StatefulWidget {

  final int defaultPage;
  const NavigationView({required this.defaultPage});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  
  int _pageIndex = 0;
  late PageController _pageController;
  bool isUserSignedIn = false;
  List<Widget> tabPages =[];
  //
  //*******ONE SIGNAL*******\\
  bool requireConsent = false;
  static String userId = "";

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.defaultPage;
    tabPages = [
      const HomeScreen(),
      TeamMembers(),
      DiscussionsList(),
      //ChatListScreen(),
      SettingsScreen(),
    ];
    _pageController = PageController(initialPage: _pageIndex);
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });

    _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: tabPages[_pageIndex],
      bottomNavigationBar: Container(
        height: (Platform.isIOS) ? SizeConfig.blockSizeVertical * 12 : SizeConfig.blockSizeVertical * 8,
        color: Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _pageIndex,
          selectedItemColor: Constants.appThemeColor,
          unselectedItemColor: Colors.grey[300],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: SizeConfig.fontSize*1.6,
          selectedFontSize: SizeConfig.fontSize*1.6,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 0.7),
                child: Icon(Icons.home, size: SizeConfig.blockSizeVertical*3,)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 0.7),
                child: Icon(Icons.person, size: SizeConfig.blockSizeVertical*3,)
              ),
              label: 'Team'
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 0.7),
                child: Icon(Icons.chat, size: SizeConfig.blockSizeVertical*3,)
              ),
              label: 'Discussions'
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 0.7),
                child: Icon(Icons.settings, size: SizeConfig.blockSizeVertical*3,)
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}