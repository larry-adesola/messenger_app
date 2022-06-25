import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/pages/mainPages/ConversationPage.dart';
import 'package:messenger_app/pages/mainPages/MenuScreen.dart';
import 'package:messenger_app/pages/mainPages/SearchPage.dart';
import 'package:messenger_app/services/FirebaseAuth.dart';
import 'package:messenger_app/widget/User.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  UserInformation userInfo;

  HomeScreen({this.userInfo});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FireAuth fireAuth = FireAuth();
  bool onSearchTapped = false;
  bool onMenuTapped = false;
  String layerPosition = "search";
  double xOffset = 0.0;
  double yOffset = 0.0;
  double opacityChange = 1;
  double scaleFactor = 1.0;
  double borderChange = 0.0;
  Stream<QuerySnapshot> convoList;
  List listOfFriends = [];

  getConvoList() {
    convoList = database
        .collection("ConvoRoom")
        .where("users", arrayContains: widget.userInfo.username)
        .snapshots();
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: convoList,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData ||
            snapshot == null ||
            snapshot.data.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01),
            child: Center(
              child: Text(
                "Find your friends",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Open Sans",
                    fontSize: 20),
              ),
            ),
          );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();}
        else {
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
            return ConvoTile(
                userInformation: widget.userInfo,
                otherUser: cutExtras(snapshot.data.docs[index].get("convoId"),
                    widget.userInfo.username),
            convoId: snapshot.data.docs[index].get("convoId"),);
              },
            ),
          );
        }
      },
    );
  }

  String cutExtras(String iD, String myName) {
    iD = iD.replaceAll(myName, "");
    if (iD.substring(0, 1) == "_") {
      iD = iD.replaceRange(0, 1, "");
    } else if (iD.substring(iD.length -1, iD.length) == "_") {
      iD = iD.replaceRange(iD.length, iD.length, "");
    }
    return iD;
  }

  @override
  void initState() {
    getConvoList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget chooseLayout(bool searchTapped, bool menuTapped, String position) {
      if (searchTapped == true) {
        return SearchLayout(widget.userInfo);
      } else if (searchTapped == false && position == "search") {
        return Container(
          color: Colors.red,
        );
      } else if (menuTapped == true) {
        return MenuLayout(userInfo: widget.userInfo);
      } else {
        return Container(
          color: Colors.blue,
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          chooseLayout(onSearchTapped, onMenuTapped, layerPosition),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOutExpo,
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderChange)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderChange),
              child: Scaffold(
                backgroundColor: Colors.white.withOpacity(opacityChange),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(height * 0.15),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.03, horizontal: width * 0.01),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(opacityChange),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 6))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        onMenuTapped
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    onMenuTapped = false;
                                    opacityChange = 1;
                                    borderChange = 0;
                                    scaleFactor = 1;
                                    xOffset = 0;
                                    yOffset = 0;
                                    layerPosition = "menu";
                                  });
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 40,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    onMenuTapped = true;
                                    opacityChange = 0.5;
                                    borderChange = 50;
                                    scaleFactor = 0.8;
                                    xOffset = 250;
                                    yOffset = 80;
                                    layerPosition = "menu";
                                  });
                                },
                                child: Icon(
                                  Icons.menu,
                                  size: 40,
                                ),
                              ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          "Messagely",
                          style: TextStyle(
                            fontFamily: "Open Sans",
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        onSearchTapped
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    onSearchTapped = false;
                                    opacityChange = 1;
                                    borderChange = 0;
                                    scaleFactor = 1;
                                    xOffset = 0;
                                    yOffset = 0;
                                    layerPosition = "search";
                                  });
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 40,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    onSearchTapped = true;
                                    opacityChange = 0.5;
                                    borderChange = 50;
                                    scaleFactor = 0.8;
                                    xOffset = -250;
                                    yOffset = 80;
                                    layerPosition = "search";
                                  });
                                },
                                child: Icon(
                                  Icons.search,
                                  size: 40,
                                )),
                      ],
                    ),
                  ),
                ),
                body: Container(
                  child: chatRoomList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConvoTile extends StatelessWidget {
  UserInformation userInformation;
  String otherUser;
  String convoId;

  ConvoTile({this.userInformation, this.otherUser, this.convoId});

  Future _getImage(BuildContext context) async {
    Image m;
    String link = await storage
        .ref()
        .child("profile_picture/${otherUser}")
        .getDownloadURL();
    if (link == null) {
      print("wassup");
      return null;
    } else {
      m = Image.network(
        link,
        fit: BoxFit.fill,
      );
      return m;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, animationTime, child){
              final curve = CurvedAnimation(parent: animation, curve: Curves.decelerate);
              Animation<Offset> _animOffset = Tween<Offset>(begin: Offset(5, 0.0), end: Offset.zero).animate(curve);
              return SlideTransition(
                position: _animOffset,
                child: child,
              );
            },
            pageBuilder: (context, animation, animationTime){
              return ConversationScreen(convoId, otherUser, userInformation);
            }
        ));
      },
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        child: Row(
          children: [
            Container(
              width: height * 0.09,
              height: height * 0.09,
              child: FutureBuilder(
                future: _getImage(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.data == null) {
                    return Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.grey,
                    );
                  } else {
                    return ClipOval(
                      child: snapshot.data,
                    );
                  }
                },
              ),
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Text(
              otherUser,
              style: TextStyle(
                fontFamily: "Open Sans",
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
