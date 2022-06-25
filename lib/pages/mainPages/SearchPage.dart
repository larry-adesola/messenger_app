import 'dart:io';
import 'package:messenger_app/pages/mainPages/ConversationPage.dart';
import 'package:messenger_app/widget/User.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/services/FirebaseAuth.dart';
import 'package:messenger_app/widget/DelayedAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchLayout extends StatefulWidget {
  UserInformation userInformation;
  SearchLayout(this.userInformation);
  @override
  _SearchLayoutState createState() => _SearchLayoutState();
}

class _SearchLayoutState extends State<SearchLayout> {
  TextEditingController searchController = TextEditingController();
  File image;
  QuerySnapshot userSearch;
  bool imageExists = true;
  FireAuth fireAuth = FireAuth();

  getSearchItems(String username) async{
    print("Is it working?");
    userSearch =  await database.collection("Users").where("username", isEqualTo: username).get();
  }


  Future _getImage(BuildContext context) async {
    Image m;
    String link = await storage.ref().child("profile_picture/${userSearch.docs[0].get("username")}").getDownloadURL();
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



  createConvoScreen(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String ID = getChatRoomId(pref.getString("username"), userSearch.docs[0].get("username"));
    await database.collection("ConvoRoom").where("convoId", isEqualTo: ID).get().then((value){
      if(value.docs.isEmpty){
        List users = [pref.getString("username"), userSearch.docs[0].get("username")];
        Map<String, dynamic> convoMap = {
          "users" : users,
          "convoId" : ID
        };
        fireAuth.createChatRoom(ID, convoMap);
      }
    } );


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
          return ConversationScreen(ID, userSearch.docs[0].get("username"), widget.userInformation);
        }
    ));

  }

  String getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0) ){
      return "$b\_$a";
    }
    else{
      return "$a\_$b";
    }
  }


  @override
  Widget build(BuildContext context) {

    Widget searchTile(BuildContext context){
      if(userSearch == null){
        return Align(
          alignment: Alignment.centerRight,
          child: DelayedAnimation(
            child: Container(
              child: Text("Who are you looking for?", textAlign: TextAlign.center, style: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500
              ),),
            ),
            delay: 200,
          ),
        );
      }
      else{
        if(userSearch.docs.isEmpty){
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: DelayedAnimation(
                child: Text("Did you spell it right?", textAlign: TextAlign.center, style: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w500
                ),),
                delay: 500,
              ),
            ),
          );
        }
        else{
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width*0.65,
              height: MediaQuery.of(context).size.height * 0.1,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black, offset: Offset(-1, 1),),
                    BoxShadow(color: Colors.white, offset: Offset(1, -1))
                  ],
                  color: Colors.red
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.height * 0.1,
                      height: MediaQuery.of(context).size.height*0.1,
                      child: FutureBuilder(
                        future: _getImage(context),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }
                          else if(snapshot.data == null){
                            return Icon(Icons.account_circle, size: 50, color: Colors.white,);
                          }
                          else{
                            return ClipOval(
                              child: snapshot.data,
                            );
                          }
                        },
                      )
                  ),
                  SizedBox(width: 1,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(userSearch.docs[0].get("username"), style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.bold
                      ),),
                      Text(userSearch.docs[0].get("email"), style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.5),
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w600),
                      )],
                  ),
                ],
              ),
            ),
          );
        }
      }


    }


    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(vertical: height*0.03, horizontal: width*0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            width: width*0.8,
            height: height*0.05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black, offset: Offset(-1, 1),),
                  BoxShadow(color: Colors.white, offset: Offset(1, -1))
                ],
                color: Colors.red
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white
                    ),
                    controller: searchController,
                    onChanged: (value) async{
                      await getSearchItems(value);
                    },
                    onSubmitted: (value) async{
                      await getSearchItems(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white,),
                      hintText: "Search",
                      enabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 18
                      ),
                      focusedBorder: InputBorder.none,
                      focusColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height*0.4,),
          GestureDetector(
            onTap: () async{
              SharedPreferences pref= await SharedPreferences.getInstance();
              String myName = pref.getString("username");
              print(myName);
              if(myName == userSearch.docs[0].get("username")){
                Toast.show("Cannot add YOURSELF!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
              }
              else{
                List<String> data = [userSearch.docs[0].get("username")];
                database.collection("Users").doc(myName).update({"Friends": FieldValue.arrayUnion(data)});
                createConvoScreen(context);
              }

            },
            child: Container(
                child: Expanded(child: searchTile(context))),
          )

        ],
      ),
    );
  }
}



