import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/pages/mainPages/MainScreen.dart';
import 'package:messenger_app/pages/mainPages/SearchPage.dart';
import 'package:messenger_app/services/FirebaseAuth.dart';
import 'package:messenger_app/widget/DelayedAnimation.dart';
import 'package:messenger_app/widget/User.dart';

class ConversationScreen extends StatefulWidget {
  String convoId;
  String friendName;
  UserInformation userInfo;
  ConversationScreen(this.convoId, this.friendName, this.userInfo);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream<QuerySnapshot> chatMessages;
  final messageFormKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  Future _getImage(BuildContext context) async {
    Image m;
    String link = await storage.ref().child("profile_picture/${widget.friendName}").getDownloadURL();
    if(link == null){
      print("wassup");
      return null;
    }
    else{
      m = Image.network(
        link,
        fit: BoxFit.fill,
      );
      return m;
    }
  }
  
  addConversation(){
    if(messageFormKey.currentState.validate()){
      Map<String, dynamic> messages = {"message": messageController.text,
        "sent by" : widget.userInfo.username,
      "time" : DateTime.now().millisecondsSinceEpoch};
      database.collection("ConvoRoom").doc(widget.convoId).collection("Chats").add(messages);
      messageController.text = "";
    }
  }

  getConversation() {
    setState(() {
      print("yhyh");
      chatMessages = database.collection("ConvoRoom").doc(widget.convoId).collection("Chats").orderBy("time", descending: false).snapshots();
    });
  }

  @override
  void initState() {
    getConversation();
    // TODO: implement initState
    super.initState();
  }

  Widget listOfMessages(){
    return StreamBuilder(
      stream: chatMessages,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data.docs.isEmpty || snapshot.data == null || snapshot == null || !snapshot.hasData){
          return DelayedAnimation(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
              child: Center(
                child: Text(
                    "Start talking now!",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Open Sans",
                  fontSize: 20
                ),),
              ),
            ),
            delay: 100,
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else{
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                return MessageWidget(messageSnapshot: snapshot.data.docs[index], sentByMe: snapshot.data.docs[index].get("sent by") == widget.userInfo.username,);
              },
            ),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.15),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 2))
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 400),
                      transitionsBuilder: (context, animation, animationTime, child){
                        final curve = CurvedAnimation(parent: animation, curve: Curves.decelerate);
                        Animation<Offset> _animOffset = Tween<Offset>(begin: Offset(-5, 0.0), end: Offset.zero).animate(curve);
                        return SlideTransition(
                          position: _animOffset,
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, animationTime){
                        return HomeScreen(userInfo: widget.userInfo,);
                      }
                  ));
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              Text(
                widget.friendName,
                style: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.height * 0.08,
                  height: MediaQuery.of(context).size.height*0.08,
                  child: FutureBuilder(
                    future: _getImage(context),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      else if(snapshot.data == null){
                        return Icon(Icons.account_circle, size: 50, color: Colors.grey,);
                      }
                      else{
                        return ClipOval(
                          child: snapshot.data,
                        );
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: listOfMessages(),
          ),
          Container(
            width: width,
            height: height*0.1,
            padding: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.05),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, -2))
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width *0.7,
                  child: Form(
                    key: messageFormKey,
                    child: TextFormField(
                      onFieldSubmitted: (value){
                        addConversation();
                        getConversation();
                      },
                      controller: messageController,
                      validator: (value){
                        if(value.isEmpty){
                          return "";
                        }
                        else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusColor: Colors.white,
                        hintText: "Enter Message",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: "Open Sans",
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.6)
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    addConversation();
                    getConversation();
                  },
                    child: Icon(Icons.send, color: Colors.blue, size: 30,))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  QueryDocumentSnapshot messageSnapshot;
  bool sentByMe;
  MessageWidget({this.messageSnapshot, this.sentByMe});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: sentByMe ? 0 : 24, right: sentByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: width,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: sentByMe ?
            BorderRadius.only(
              topLeft: Radius.circular(23),
              bottomLeft: Radius.circular(23),
              topRight: Radius.circular(23)
            ) :
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
            ),
          color: sentByMe ? Colors.blue : Colors.grey[350]
        ),
          child: Text(
          messageSnapshot.get("message"),
            style: TextStyle(fontSize: 17,
            color: sentByMe ? Colors.white: Colors.black,
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w100),
        ),
      ),
    );
  }
}

