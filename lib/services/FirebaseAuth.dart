import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger_app/widget/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "gs://messenger-app-b417b.appspot.com");


class FireAuth{





  Future<UserInformation> signUpWithUserNameEmailAndPassword(String username, String email, String password )async{

    await auth.createUserWithEmailAndPassword(email: email, password: password);
    Map<String, String> details = {
      "username": username,
      "userID" : auth.currentUser.uid,
      "email" : email,
    };
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setBool("isLoggedIn", true);
    await pref.setString("username", username);
    await pref.setString("uid", auth.currentUser.uid);
    await pref.setString("email", email);
    await database.collection("Users").doc(username).set(details);
    UserInformation userInfo = UserInformation(uid: auth.currentUser.uid, username: username, email: email);
    return userInfo;


  }

  Future<UserInformation> signInWithUserNameAndPassword(String username, String password) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool exist = false;
    await database.collection("Users").doc(username).get().then((document) {
      if (document.exists) {
        exist = true;
      } else {
        exist = false;
      }
    });

    if(exist == true){
      String email = await database.collection("Users").doc(username).get().then((value) => value.get("email"));
      try{
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch(e){
        if(e.code.contains("wrong-password")){
          return null;
        }
        else if(e.code.contains("too-many-requests")){
          return null;
        }
        else{

        }
      }
      UserInformation userInfo = UserInformation(uid: auth.currentUser.uid, username: username, email: auth.currentUser.email);
      await pref.setBool("isLoggedIn", true);
      await pref.setString("username", username);
      await pref.setString("uid", auth.currentUser.uid);
      await pref.setString("email", auth.currentUser.email);
      print(pref.getString("username"));
      return userInfo;
    }
    else{
      return null;
    }


  }

  Future<UserInformation> signInWithEmailAndPassword(String email, String password) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool exist = false;
    await database.collection("Users").where("email", isEqualTo: email).get()
        .then((value){
      if(value.docs.isEmpty){
        exist = false;
      }
      else{
        exist = true;
      }
    });

    if(exist == true){
      try{
        try{
          await auth.signInWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch(e){
          if(e.code.contains("wrong-password")){
            return null;
          }
          else if(e.code.contains("too-many-requests")){
            return null;
          }
          else{

          }
        }      } on FirebaseAuthException catch(e){
        if(e.code.contains("wrong-password")){
          return null;
        }
        else if(e.code.contains("too-many-requests")){
          return null;
        }
        else{

        }
      }
      String username = await database.collection("Users").where("email", isEqualTo: email).get()
      .then((value) => value.docs[0].get("username"));
      UserInformation userInfo = UserInformation(uid: auth.currentUser.uid, username: username,
          email: auth.currentUser.email);

      await pref.setBool("isLoggedIn", true);
      await pref.setString("username", username);
      await pref.setString("uid", auth.currentUser.uid);
      await pref.setString("email", auth.currentUser.email);
      return userInfo;
    }
    else{
      return null;
    }
  }

  signOut() async{
    auth.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isLoggedIn", false);
  }


  createChatRoom(String convoRoomID, convoRoomMaps){
    database.collection("ConvoRoom").doc(convoRoomID).set(convoRoomMaps);
  }


}

