// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors_in_immutables
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/controllers/app_controller.dart';
import 'package:task_manager/screens/my_categories/my_categories.dart';
import 'package:task_manager/utils/constants.dart';
import '../../utils/color.dart';
import '../../utils/size_config.dart';
import '../add_member/add_members.dart';

class EditTask extends StatefulWidget {
  
  final Map taskDetail;
  EditTask({Key? key, required this.taskDetail}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  
  final format = DateFormat("dd-MM-yyyy HH:mm");
  bool setReminder = true;
  String? selectedCategories;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController reminder = TextEditingController();
  List categories = [];
  //
  List allMembers = [];
  Map? selectedMember;

  @override
  void initState() {
    super.initState();
    title.text = widget.taskDetail['taskTitle'];
    description.text = widget.taskDetail['taskDescription'];
    date.text = widget.taskDetail['taskDate'];
    reminder.text = widget.taskDetail['taskReminder'];
    categories = List.from(Constants.appUser.myCategories);
    selectedCategories = categories.firstWhere((element) => element == widget.taskDetail['taskCategory'], orElse: () => null,);
    categories.add("Other");
    getAllMembers();
  }
  
  void getAllMembers()async{
    allMembers.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().getAllMembers(allMembers);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
        print(allMembers.length);
        Map member = (widget.taskDetail['member'] == null) ? {} : widget.taskDetail['member'];
        if(member.isNotEmpty)
          selectedMember = allMembers.firstWhere((element) => element['memberId'] == member['memberId'], orElse: () => null,);
     });
    }
  }

  void editTask()async{
    if(title.text.isEmpty)
      Constants.showDialog('Please enter task title');
    else if(description.text.isEmpty)
      Constants.showDialog('Please enter task description');
    else if(selectedCategories == null)
      Constants.showDialog('Please enter task category');
    else if(date.text.isEmpty)
      Constants.showDialog('Please enter task date');
    else if(setReminder && reminder.text.isEmpty)
      Constants.showDialog('Please enter task reminder time');
    else
    { 
      if(!setReminder)
        reminder.text = "";
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      dynamic result = await AppController().editTask(widget.taskDetail, title.text, description.text, selectedCategories!, date.text, selectedMember, reminder.text);
      EasyLoading.dismiss();
      if(result['Status'] == 'Success')
      {
        Get.back(result: true);
        Constants.showDialog('Task has been edited successfully');
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  void deleteTasks()async{
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().deleteTask(widget.taskDetail);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
      Get.back(result: true);
      Constants.showDialog('Your task has been deleted successfully');
    }
    else
      Constants.showDialog(result['ErrorMessage']);
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
          'Edit Task',
          style: TextStyle(
            fontSize: SizeConfig.fontSize * 2,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            print('close');
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus)
              currentFocus.unfocus();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*6, SizeConfig.blockSizeVertical*5, SizeConfig.blockSizeHorizontal*6, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  //height: SizeConfig.blockSizeVertical*6,
                  decoration: BoxDecoration(
                    color: (title.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (title.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                      controller: title,
                      onChanged: (val){
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Task title',
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  decoration: BoxDecoration(
                    color: (description.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (description.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                      controller: description,
                      minLines: 3,
                      maxLines: 3,
                      onChanged: (val){
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Task description',
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize*1.6),
                      ),
                    ),
                  ),
                ),
              
                (Constants.appUser.myCategories.isEmpty) ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  decoration: BoxDecoration(
                    color: (description.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (description.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Add category',
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize * 2,
                          color: Colors.black,
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: () async {
                          dynamic result = await Get.to(const TaskCategories());
                          if(result != null)
                          {
                            setState(() {
                              selectedCategories = result;
                              categories = List.from(Constants.appUser.myCategories);
                              categories.add("Other");
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.add_circle, color: appSecondaryColor, size: SizeConfig.blockSizeVertical *3.5,)
                        ),
                      ),
                    ]
                  ),
                )
                : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  decoration: BoxDecoration(
                    color: (selectedCategories != null) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (selectedCategories != null) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Center(
                    child: DropdownButton<dynamic>(
                      isExpanded: true,
                      underline: Container(),
                      value: selectedCategories,
                      hint: Text('Task category', style: TextStyle(fontSize: SizeConfig.fontSize * 1.6),),
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white,),
                      items: categories.map((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: SizeConfig.fontSize * 1.6, color: Colors.black,),
                          ),
                        );
                      }).toList(),
                      onChanged: (_) async {
                        if(_ != "Other")
                        {
                          setState(() {
                            selectedCategories = _;                          
                          });
                        }
                        else
                        {
                          dynamic result = await Get.to(const TaskCategories());
                          if(result != null)
                          {
                            setState(() {
                              selectedCategories = result;
                              categories = List.from(Constants.appUser.myCategories);
                              categories.add("Other");
                            });
                          }
                        }
                      },
                    )
                  ),
                ),
              
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  decoration: BoxDecoration(
                    color: (date.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (date.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Center(
                    child: DateTimeField(
                      format: format,
                      controller: date,
                      resetIcon: const Icon(Icons.close, color: Colors.transparent,),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 1.6,),
                        border: InputBorder.none,
                        hintText: 'Task date',
                      ),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100)
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                ),

                (allMembers.isEmpty) ? Container(
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  //height: SizeConfig.blockSizeVertical * 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Task Members',
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize * 2,
                          color: Colors.black,
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: () async {
                          dynamic result = await Get.to(const AddMemberScreen());
                          if(result != null)
                            getAllMembers();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.add_circle, color: appSecondaryColor, size: SizeConfig.blockSizeVertical *3.5,)
                        ),
                      ),
                    ]
                  ),
                )
                : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  decoration: BoxDecoration(
                    color: (selectedMember != null) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (selectedMember != null) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Center(
                    child: DropdownButton<Map>(
                      isExpanded: true,
                      underline: Container(),
                      value: selectedMember,
                      hint: Text('Task member', style: TextStyle(fontSize: SizeConfig.fontSize * 1.6),),
                      style: TextStyle(fontSize: SizeConfig.fontSize * 1.6, color: Colors.white,),
                      items: allMembers.map((dynamic value) {
                        return DropdownMenuItem<Map>(
                          value: value,
                          child: Text(
                            value['memberName'],
                            style: TextStyle(fontSize: SizeConfig.fontSize * 1.6, color: Colors.black,),
                          ),
                        );
                      }).toList(),
                      onChanged: (member) async {
                        setState(() {
                          selectedMember = member!;                          
                        });
                      },
                    )
                  ),
                ),
              
                Container(
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Want to set a reminder?',
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize * 1.6,
                          color: Colors.black,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                      
                      Container(
                        child: FlutterSwitch(
                          width: SizeConfig.blockSizeHorizontal* 15,
                          height: SizeConfig.blockSizeVertical* 3,
                          valueFontSize: 0.0,
                          toggleSize: SizeConfig.blockSizeVertical* 3,
                          value: setReminder,
                          borderRadius: SizeConfig.blockSizeVertical* 3,
                          padding: 0.0,
                          showOnOff: true,
                          activeColor: appPrimaryColor,
                          activeToggleColor: appSecondaryColor,
                          onToggle: (val) {
                            setState(() {
                              setReminder = val;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ),
              
                if(setReminder)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top : SizeConfig.blockSizeVertical*3),
                  decoration: BoxDecoration(
                    color: (reminder.text.isNotEmpty) ? Colors.transparent :Color(0XFFF4F4F6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (reminder.text.isNotEmpty) ? Constants.appThemeColor : Color(0xffEDEDFB),
                      width: 1
                    )
                  ),
                  child: Center(
                    child: DateTimeField(
                      format: format,
                      controller: reminder,
                      resetIcon: const Icon(Icons.close, color: Colors.transparent,),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 1.6,),
                        border: InputBorder.none,
                        hintText: 'Task reminder',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
                      ),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100)
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                ),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: editTask,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal*40,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child : Center(
                          child: Text(
                            'Update Task',
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
                      onTap: deleteTasks,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
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
                            'Delete Task',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}