import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/mainPages/MainScreen.dart';
import 'package:messenger_app/pages/welcomepages/SignUpScreen.dart';
import 'package:messenger_app/pages/welcomepages/WelcomeScreen.dart';
import 'package:messenger_app/widget/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  Future<bool> getBool() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isLoggedIn");
  }

  Future<UserInformation> userInfo() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserInformation userInformation = UserInformation(uid: pref.getString("uid"), username: pref.getString("username"),
    email: pref.getString("email"));
    return userInformation;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
        future: getBool(),
        builder: (context, AsyncSnapshot<bool> snapshot){

          if(snapshot.data == false){
            print("hello");
            return WelcomeScreen();
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else{

            return FutureBuilder(
              future: userInfo(),
              builder: (context, AsyncSnapshot<UserInformation> snap){
                if(snap.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                else{
                  return HomeScreen(userInfo: snap.data);
                }
              },
            );
          }
        },
      ),

    );
  }
}

