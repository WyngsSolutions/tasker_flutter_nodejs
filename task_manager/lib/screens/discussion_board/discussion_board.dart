// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_is_empty
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/discussion_board/discussion_detail.dart';
import '../../controllers/discussion_helper.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscussionsList extends StatefulWidget {
  const DiscussionsList({Key? key}) : super(key: key);

  @override
  State<DiscussionsList> createState() => _DiscussionsListState();
}

class _DiscussionsListState extends State<DiscussionsList> {
    
  Stream<QuerySnapshot>? chatRoomsStream;
  
  @override
  void initState() {  
    super.initState();
    DiscussionModel().getUserChatRooms(Constants.appUser.userId).then((value){
      setState(() {
        chatRoomsStream = value;        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Discussion Board',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*5, SizeConfig.blockSizeVertical*0, SizeConfig.blockSizeHorizontal*5, 0),
        child: chatMessageList(),
      ),
    );
  }

   Widget chatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? (snapshot.data!.docs.length > 0) ? MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              dynamic tskData = snapshot.data!.docs[index].data()!;
              tskData['taskId'] = snapshot.data!.docs[index].id;
              return MessageCell(messageData:tskData);
            }
          ),
        ) : Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Center(
            child: Text(
              'No Discussions',
              style: TextStyle(
                color : Colors.grey[500],
                fontSize : SizeConfig.fontSize * 2.0,
              ),
            ),
          ),
        )
        : Container();
      }
    );
  }
}

class MessageCell extends StatefulWidget {

  final Map messageData;
  const MessageCell({required this.messageData});

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {

  Map member = {};

  @override
  void initState() {
    super.initState();
    member = widget.messageData['member'];
  }

  @override
  Widget build(BuildContext context) {
    final lastMsgTime = widget.messageData['lastMessageTimeStamp'].toDate();
    String dateText = timeago.format(lastMsgTime, locale: 'en'); 
    return GestureDetector(
      onTap: (){
        Map task ={
          'taskId' : widget.messageData['taskId'],
          'taskTitle' : widget.messageData['task_name'],
          'member' : member,
        };
        Get.to(DiscussionDetail(task: task));
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: 15),
        height: SizeConfig.blockSizeVertical * 8,
        child: Row(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeVertical * 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: (member.isEmpty) ? AssetImage('assets/user.png') : CachedNetworkImageProvider(member['memberPhoto']) as ImageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
          
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${widget.messageData['task_name']}',
                              style: TextStyle(
                                color: Constants.appThemeColor,
                                fontSize:  SizeConfig.fontSize * 1.8,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                           Text(
                            '$dateText',
                            style: TextStyle(
                              color: Colors.grey[500], fontSize:  SizeConfig.fontSize * 1.5, fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.8),
                      child: Text(
                        '${widget.messageData['last_msg']}',
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey[500], fontSize:  SizeConfig.fontSize * 1.6, fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}