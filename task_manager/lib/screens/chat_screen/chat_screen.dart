// // ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, curly_braces_in_flow_control_structures, avoid_print, unnecessary_string_interpolations, unnecessary_string_escapes, use_full_hex_values_for_flutter_colors
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../controllers/chat_helper.dart';
// import '../../models/app_user.dart';
// import '../../utils/constants.dart';
// import '../../utils/size_config.dart';

// class ChatScreen extends StatefulWidget {
  
//   final String taskId;
//   final String taskName;
//   final String taskOwnerId;
//   final List taskMembers;
//   final AppUser taskOwner;
//   const ChatScreen({ Key? key, required this.taskOwner, required this.taskId, required this.taskName, required this.taskOwnerId, required this.taskMembers }) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {

//   TextEditingController messageController = TextEditingController();
//   late String chatRoomId;
//   Stream<QuerySnapshot>? chatMessageStream;
//   final _controller = ScrollController();
//   int groupMessages = 0;
  
//   @override
//   void initState() {
//     super.initState();
    
//     generateChatRoomId();
//     ChatDatabaseModel().getConversationMessages(chatRoomId).then((value){
//       setState(() {
//         chatMessageStream = value;
//       });
//     });
//   }

//   void generateChatRoomId(){
//     chatRoomId = getChatRoomID(widget.taskId);
//   }

//   List<String> getAllTaskMemberIds(){
//     List<String> memberIds = [widget.taskOwnerId];
//     for(int i=0; i< widget.taskMembers.length; i++)
//     {
//       memberIds.add(widget.taskMembers[i]['memberId']);
//     }
//     return memberIds;
//   }

//   void createChatRoom(){
//     chatRoomId = getChatRoomID(widget.taskId);
//     List<String> users = getAllTaskMemberIds();
//     Map<String, dynamic> chatRoomMap = {
//       "users" : users,
//       "group_owner_id" : widget.taskOwnerId,
//       "chatRoomId" : chatRoomId,
//       "taskName" : widget.taskName,
//       'lastMessageTimeStamp' : FieldValue.serverTimestamp(),
//       'taskOwner_name' : '${widget.taskOwner.name}',
//       'taskOwner_token' : '${widget.taskOwner.oneSignalUserId}',
//       'taskOwner_picture' : '${widget.taskOwner.userProfilePicture}',
//     };

//     FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).
//       set(chatRoomMap).then((_) async {
//         print("success!");
//       }).catchError((error) {
//         print("Failed to update: $error");
//     });
//   }

//   String getChatRoomID(String a){
//     return a;
//   }

//   void sendMessagePressed(){
//     if(messageController.text.trim().isEmpty)
//       Constants.showDialog('Please enter message');
//     else
//     {
//       if(groupMessages ==0)
//       {
//         createChatRoom();
//         groupMessages = 1;
//       }

//       Map<String, dynamic> messageMap = {
//         'message' : messageController.text,
//         'sendBy' : Constants.appUser.userId,
//         'timestamp' : FieldValue.serverTimestamp(),
//         'sentByDetails' : '{ "name" : ${Constants.appUser.name}, "photoUrl" : ${Constants.appUser.userProfilePicture}}'
//       };
//       ChatDatabaseModel().sendConversationMessage(chatRoomId, messageMap,);
//       //AppController().sendChatNotificationToUser(widget.chatUser);
//       messageController.text = '';
//       _controller.animateTo(
//         _controller.position.maxScrollExtent,
//         duration: Duration(seconds: 1),
//         curve: Curves.fastOutSlowIn,
//       );
//     }
//   } 
  
//   @override
//   Widget build(BuildContext context) {
//     var shortestSide = MediaQuery.of(context).size.shortestSide;
//     bool isMobile = shortestSide < 600;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       //drawer: homeDrawer(),
//       appBar: AppBar(
//         toolbarHeight: (isMobile) ? kToolbarHeight : 80,
//         backgroundColor: Constants.appThemeColor,
//         centerTitle: true,
//         title: Text(
//           widget.taskName,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: SizeConfig.fontSize*2.2
//           ),
//         ),
//       ),
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
            
//             // Expanded(
//             //   child: Container(
//             //     margin: EdgeInsets.only(top: 10, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
//             //     child: MediaQuery.removePadding(
//             //       context: context,
//             //       removeTop: true,
//             //       child: ListView.builder(
//             //         shrinkWrap: true,
//             //         itemCount: 3,
//             //         itemBuilder: (context, index){  
//             //            return messageCell(index);
//             //         }
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(top: 10, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
//                 child: chatMessageList(),
//               ),
//             ),

//             Container(
//               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical* 2, right: SizeConfig.blockSizeHorizontal*6, left: SizeConfig.blockSizeHorizontal*6, bottom: SizeConfig.blockSizeVertical* 3),
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               height: SizeConfig.blockSizeVertical * 7,
//               decoration: BoxDecoration(
//                 color:Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 2,
//                     offset: Offset(1, 1), // Shadow position
//                   ),
//                 ],
//                 border: Border.all(
//                   color: Constants.appThemeColor
//                 )
//               ),
//               child: Center(
//                 child: TextField(
//                   controller: messageController,
//                   textAlignVertical: TextAlignVertical.center,
//                   style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.7),
//                   decoration:  InputDecoration(
//                     hintText: 'Type a message....',
//                     hintStyle: TextStyle(color: Colors.grey[700], fontSize: SizeConfig.fontSize * 1.7),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//                     suffixIcon: GestureDetector(
//                       onTap: sendMessagePressed,
//                       child: Icon(Icons.send, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical*3,)
//                     )
//                   ),
//                 ),
//               ),
//             ),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget chatMessageList(){
//     return StreamBuilder<QuerySnapshot>(
//       stream: chatMessageStream,
//       builder: (context, snapshot){
//         return snapshot.hasData ? MediaQuery.removePadding(
//           context: context,
//           removeTop: true,
//           child: ListView.builder(
//             controller: _controller,
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index){
//               groupMessages = snapshot.data!.docs.length;
//               return MessageTitle(messageDetail: snapshot.data!.docs[index].data() as Map<dynamic, dynamic>, taskOwner: widget.taskOwner,);
//             }
//           ),
//         ): Container();
//       }
//     );
//   }
// }

// class MessageTitle extends StatefulWidget {
  
//   final AppUser taskOwner;
//   final Map messageDetail;
//   const MessageTitle({required this.messageDetail, required this.taskOwner});

//   @override
//   _MessageTitleState createState() => _MessageTitleState();
// }

// class _MessageTitleState extends State<MessageTitle> {

//   bool isSendByMe = true;
  
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     isSendByMe = (widget.messageDetail['sendBy'] == Constants.appUser.userId) ? true : false; 
//     String formattedDate = '';
//     if(widget.messageDetail['timestamp'] != null)
//     {
//       var dateTime = widget.messageDetail['timestamp'].toDate();
//       formattedDate = DateFormat('hh:mm a').format(dateTime);
//     }
    
//     return Align(
//       alignment: (isSendByMe) ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(top: 10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: (!isSendByMe) ? MainAxisAlignment.start : MainAxisAlignment.end,
//           children: [

//             if(!isSendByMe)
//              CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100.0),
//                 child: (widget.taskOwner.userProfilePicture.isEmpty) ? Image.asset(
//                   'assets/user_bg.png',
//                   fit: BoxFit.cover,
//                   height: SizeConfig.blockSizeVertical * 5,
//                   width: SizeConfig.blockSizeVertical * 5,
//                 ) : CachedNetworkImage(
//                   imageUrl: widget.taskOwner.userProfilePicture,
//                   fit: BoxFit.cover,
//                   height: SizeConfig.blockSizeVertical * 5,
//                   width: SizeConfig.blockSizeVertical * 5,
//                 ),
//               ),
//             ),
    
//             Flexible(
//               child: Container(
//                 margin: EdgeInsets.only(top: 0, bottom: 10, left: (isSendByMe) ? 100 : 10, right: (isSendByMe) ? 10 : 100),
//                 child: Column(
//                     crossAxisAlignment: (isSendByMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                         decoration: BoxDecoration(
//                           color:  (!isSendByMe) ? const Color(0XFFFEFEEF4) : Constants.appThemeColor,
//                           borderRadius: (isSendByMe) ? BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             //topRight: Radius.circular(20),
//                             bottomLeft: Radius.circular(20),
//                             bottomRight: Radius.circular(20),
//                           ): BorderRadius.only(
//                             //topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                             bottomRight: Radius.circular(20),
//                             bottomLeft: Radius.circular(20)
//                           )
//                         ),
//                         child: Text(
//                           (widget.messageDetail['message'].toString().length <6) ? '${widget.messageDetail['message']}          ' : widget.messageDetail['message'],
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             color: (!isSendByMe) ? Color(0XFF77838F) : Colors.white,
//                             fontSize: SizeConfig.fontSize * 1.8
//                           ),
//                         ),
//                       ),  
//                       Container(
//                         margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
//                         child: Text(
//                           '$formattedDate',
//                           style: TextStyle(
//                             color: Color(0XFFB0B6C3),
//                             fontSize: SizeConfig.fontSize * 1.2
//                           ),
//                         ),
//                       ),   
//                     ],
//                   ),
//                 ),    
//               ),   
 
//             if(isSendByMe)
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey,
//               child:  ClipRRect(
//                 borderRadius: BorderRadius.circular(100.0),
//                 child: (Constants.appUser.userProfilePicture.isEmpty) ? Image.asset(
//                   'assets/user_bg.png',
//                   fit: BoxFit.cover,
//                   height: SizeConfig.blockSizeVertical * 5,
//                   width: SizeConfig.blockSizeVertical * 5,
//                 ) : CachedNetworkImage(
//                   imageUrl: Constants.appUser.userProfilePicture,
//                   fit: BoxFit.cover,
//                   height: SizeConfig.blockSizeVertical * 5,
//                   width: SizeConfig.blockSizeVertical * 5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }