import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/color.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class CalendarScreen extends StatefulWidget {

  final List allTasks;
  const CalendarScreen({required this.allTasks});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List filteredTasks = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    filterTasksOnDate();
  }

  void filterTasksOnDate(){
    filteredTasks.clear();
    for(int i=0; i< widget.allTasks.length; i++)
    {
      DateTime taskDate = DateFormat("dd-MM-yyyy HH:mm").parse(widget.allTasks[i]['taskDate'].toString());
      if(taskDate.day == _selectedDay.day && taskDate.month == _selectedDay.month && taskDate.year == _selectedDay.year) {
        setState(() {
          filteredTasks.add(widget.allTasks[i]);          
        });
      }
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
          'Filter Tasks',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: SizeConfig.fontSize *2.1,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                titleCentered: true,
               //formatButtonVisible: false
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration : BoxDecoration(
                  color: Constants.appThemeColor,
                  shape: BoxShape.circle
                )
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  filterTasksOnDate();
                });
              },
            ),

            Expanded(
              child: (filteredTasks.isEmpty) ? Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
                child: Text(
                  'No Tasks Found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: SizeConfig.fontSize * 2.2
                  ),
                ),
              ) : Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3, 0, SizeConfig.blockSizeHorizontal*3, 10),
                child: ListView.builder(
                  itemBuilder: (_, i) {
                    return taskCell(filteredTasks[i], i);
                  },
                  shrinkWrap: true,
                  itemCount: filteredTasks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskCell(Map taskDetail, int index){
    DateTime taskDate = DateFormat("dd-MM-yyyy HH:mm").parse(taskDetail['taskDate'].toString());
    String timeOnly = DateFormat("HH:mm aa").format(taskDate);
    String dateOnly = DateFormat("dd MMM, yyyy").format(taskDate);
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
                Flexible(
                  child: Text(
                    '${taskDetail['taskTitle']}',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 2,
                      color: appPrimaryColor,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                // FocusedMenuHolder(
                //   menuWidth: MediaQuery.of(context).size.width*0.50,
                //   blurSize: 5.0,
                //   menuItemExtent: 45,
                //   menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                //   duration: Duration(milliseconds: 100),
                //   animateMenuItems: true,
                //   blurBackgroundColor: Colors.black54,
                //   bottomOffsetHeight: 100,
                //   openWithTap: true,
                //   menuItems: [
                    
                //      FocusedMenuItem(
                //       backgroundColor: Colors.white,
                //       title: Text("Edit", style: TextStyle(color: appPrimaryColor),),
                //       trailingIcon: Icon(Icons.edit, color: appPrimaryColor),
                //       onPressed: () async {
                //         dynamic result = await Get.to(EditTask(taskDetail: taskDetail,));
                //         if(result != null)
                //           getAllTasks();
                //       }
                //     ),

                //     FocusedMenuItem(
                //       backgroundColor: Colors.white,
                //       title: Text("Delete", style: TextStyle(color: appPrimaryColor),),
                //       trailingIcon: Icon(Icons.delete, color: appPrimaryColor),
                //       onPressed: (){
                //         deleteTasks(taskDetail, index);
                //       }
                //     ),
                //   ],
                //   onPressed: (){},
                //   child: Container(
                //     child: Icon(Icons.more_vert_outlined,color:  Colors.grey[400], size: SizeConfig.blockSizeHorizontal * 5,)
                //   ),
                // ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0),
            child: Text(
              '${taskDetail['taskDescription']}',
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 1.6,
                color: Colors.grey[500],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}