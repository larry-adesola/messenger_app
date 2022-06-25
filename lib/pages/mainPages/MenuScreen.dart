import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/pages/welcomepages/WelcomeScreen.dart';
import 'package:messenger_app/services/FirebaseAuth.dart';
import 'package:messenger_app/widget/User.dart';
import 'package:ripple_effect/ripple_effect.dart';

class MenuLayout extends StatefulWidget {
  UserInformation userInfo;

  MenuLayout({this.userInfo});
  @override
  _MenuLayoutState createState() => _MenuLayoutState();
}

class _MenuLayoutState extends State<MenuLayout> {
  FireAuth auth = FireAuth();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(vertical: height*0.03, horizontal: width*0.1),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: database.collection("Users").doc(widget.userInfo.username).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              else{
                return Text(snapshot.data.get("username"), style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Open Sans",
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                ),);
              }
            },
          ),
          SizedBox(height: height*0.2,),
          GestureDetector(
            onTap: (){
              setState(() {
                auth.signOut();
                Navigator.pushReplacement(context, FadeRouteBuilder(page: WelcomeScreen()));
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, size: 40,),
            ),
          ),
          SizedBox(height: height*0.01,),
          Text("LogOut", style: TextStyle(
            color: Colors.black,
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w400,
            fontSize: 15
          ),)
        ],
      ),
    );
  }
}
