// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, curly_braces_in_flow_control_structures, avoid_print, unnecessary_string_interpolations, unnecessary_string_escapes, use_full_hex_values_for_flutter_colors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/discussion_helper.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class DiscussionDetail extends StatefulWidget {
  
  final Map task;
  const DiscussionDetail({ Key? key, required this.task }) : super(key: key);

  @override
  State<DiscussionDetail> createState() => _DiscussionDetailState();
}

class _DiscussionDetailState extends State<DiscussionDetail> {

  TextEditingController messageController = TextEditingController();
  late String discussionRoomId;
  Stream<QuerySnapshot>? chatMessageStream;
  final _controller = ScrollController();
  int groupMessages = 0;
  
  @override
  void initState() {
    super.initState();
    discussionRoomId = widget.task['taskId'];
    DiscussionModel().getConversationMessages(discussionRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
  }

  void createChatRoom(){
    List<String> users = [Constants.appUser.userId];
    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "chatRoomId" : discussionRoomId,
      "task_name" : widget.task['taskTitle'],
      'lastMessageTimeStamp' : FieldValue.serverTimestamp(),
      'owner_name' : '${Constants.appUser.name}',
      'owner_picture' : '${Constants.appUser.userProfilePicture}',
      'member' : (widget.task['member'] == null) ? {} : widget.task['member'],
    };

    FirebaseFirestore.instance.collection("DiscussionRoom").doc(discussionRoomId).
      set(chatRoomMap).then((_) async {
        print("success!");
      }).catchError((error) {
        print("Failed to update: $error");
    });
  }

  void sendMessagePressed(){
    if(messageController.text.trim().isEmpty)
      Constants.showDialog('Please enter message');
    else
    {
      if(groupMessages ==0)
      {
        createChatRoom();
        groupMessages = 1;
      }

      Map<String, dynamic> messageMap = {
        'message' : messageController.text,
        'sendBy' : Constants.appUser.userId,
        'timestamp' : FieldValue.serverTimestamp()
      };
      DiscussionModel().sendConversationMessage(discussionRoomId, messageMap,);
      messageController.text = '';
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        centerTitle: true,
        title: Text(
          widget.task['taskTitle'],
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: chatMessageList(),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 2, right: SizeConfig.blockSizeHorizontal*6, left: SizeConfig.blockSizeHorizontal*6, bottom: SizeConfig.blockSizeVertical* 3),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: SizeConfig.blockSizeVertical * 7,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 2,
                    offset: Offset(1, 1), // Shadow position
                  ),
                ],
                border: Border.all(
                  color: Constants.appThemeColor
                )
              ),
              child: Center(
                child: TextField(
                  controller: messageController,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.7),
                  decoration:  InputDecoration(
                    hintText: 'Type a message....',
                    hintStyle: TextStyle(color: Colors.grey[700], fontSize: SizeConfig.fontSize * 1.7),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    suffixIcon: GestureDetector(
                      onTap: sendMessagePressed,
                      child: Icon(Icons.send, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical*3,)
                    )
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget chatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            controller: _controller,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              groupMessages = snapshot.data!.docs.length;
              return MessageTitle(messageDetail: snapshot.data!.docs[index].data() as Map<dynamic, dynamic>, selectedTask: widget.task,);
            }
          ),
        ): Container();
      }
    );
  }
}

class MessageTitle extends StatefulWidget {
  
  final Map selectedTask;
  final Map messageDetail;
  const MessageTitle({required this.messageDetail, required this.selectedTask});

  @override
  _MessageTitleState createState() => _MessageTitleState();
}

class _MessageTitleState extends State<MessageTitle> {

  bool isSendByMe = true;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSendByMe = true; 
    String formattedDate = '';
    if(widget.messageDetail['timestamp'] != null)
    {
      var dateTime = widget.messageDetail['timestamp'].toDate();
      formattedDate = DateFormat('hh:mm a').format(dateTime);
    }
    
    return Align(
      alignment: (isSendByMe) ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: (isSendByMe) ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [

            if(isSendByMe)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: (Constants.appUser.userProfilePicture.isEmpty) ? Image.asset(
                  'assets/user_bg.png',
                  fit: BoxFit.cover,
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeVertical * 5,
                ) : CachedNetworkImage(
                  imageUrl: Constants.appUser.userProfilePicture,
                  fit: BoxFit.cover,
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeVertical * 5,
                ),
              ),
            ),
    
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: 0, bottom: 10, left: (!isSendByMe) ? 100 : 10, right: (!isSendByMe) ? 10 : 100),
                child: Column(
                    crossAxisAlignment: (isSendByMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color:  (!isSendByMe) ? const Color(0XFFFEFEEF4) : Constants.appThemeColor,
                          borderRadius: (isSendByMe) ? BorderRadius.only(
                            topLeft: Radius.circular(20),
                            //topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ): BorderRadius.only(
                            //topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)
                          )
                        ),
                        child: Text(
                          (widget.messageDetail['message'].toString().length <6) ? '${widget.messageDetail['message']}          ' : widget.messageDetail['message'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: (!isSendByMe) ? Color(0XFF77838F) : Colors.white,
                            fontSize: SizeConfig.fontSize * 1.8
                          ),
                        ),
                      ),  
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
                        child: Text(
                          '$formattedDate',
                          style: TextStyle(
                            color: Color(0XFFB0B6C3),
                            fontSize: SizeConfig.fontSize * 1.2
                          ),
                        ),
                      ),   
                    ],
                  ),
                ),    
              ),   
 
            
          ],
        ),
      )
    );
  }
}