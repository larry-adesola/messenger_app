import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/pages/welcomepages/WelcomeScreen.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/mainPages/MainScreen.dart';
import 'package:messenger_app/services/FirebaseAuth.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/welcomepages/SignInPage.dart';
import 'package:messenger_app/widget/DelayedAnimation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/widget/User.dart';
import 'package:ripple_effect/ripple_effect.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  FireAuth fireAuth = FireAuth();
  final _formKey = GlobalKey<FormState>();
  String errorText = "";
  bool usernameTaken = false;

  String emailErrorText = "";
  bool emailTaken = false;

  File _image;
  final picker = ImagePicker();
  bool imagePicked = false;

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagePicked = true;
      }
    });

    if(pickedFile != null){
      return File(pickedFile.path);
    }
    else{
      return null;
    }
  }

  Future uploadProfilePicture(File file, String username) async{
    String text = 'null';
    List<int> encoded = utf8.encode(text);
    Uint8List data = Uint8List.fromList(encoded);
    if(file != null){
      var storageRef = storage.ref().child("profile_picture/$username");
      await storageRef.putFile(file);
    }
  }

  Future<bool> isInDatabase(String value) async {
    bool exists = false;
    await database.doc("Users/$value").get().then((document) {
      if (document.exists) {
        exists = true;
      } else {
        exists = false;
      }
    });
    return exists;
  }

  Future<bool> isEmailInDatabase(String value) async {
    bool exists = false;
    await database.collection("Users").where("email", isEqualTo: value).get().then((document) {
      if (document.docs.isEmpty) {
        exists = false;
      } else {
        exists = true;
      }
    });
    return exists;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.red),
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DelayedAnimation(
                child: Text(
                  "Hello New User!",
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                delay: 100,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              DelayedAnimation(
                child: Text(
                  "Let's get to know you",
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 18,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      fontWeight: FontWeight.w600),
                ),
                delay: 400,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTap: (){
                    setState(() async {
                      _image = await getImage();
                    });
                  },
                  child: Container(
                    height: height * 0.15,
                    width: height * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,

                    ),
                    child:  imagePicked ? ClipOval(child: Image.file(_image, fit: BoxFit.fill,)) :Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
                delay: 500,
              ),
              SizedBox(height: height*0.01,),
              DelayedAnimation(
                child: Text("Pick Profile Picture", style: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: 15,
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontWeight: FontWeight.w600),),
                delay: 550,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Form(
                key: _formKey,
                child: DelayedAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: width * 0.8,
                        height: height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(-1, 1),
                              ),
                              BoxShadow(
                                  color: Colors.white, offset: Offset(1, -1))
                            ],
                            color: Colors.red),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter Username";
                              } else {
                                return usernameTaken ? errorText : null;
                              }
                            },
                            controller: usernameController,
                            keyboardType: TextInputType.name,
                            autocorrect: true,
                            decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorStyle: TextStyle(
                                height: 0.1,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              hintText: "Username",
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 20),
                              focusedBorder: InputBorder.none,
                              focusColor: Colors.white,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: width * 0.8,
                        height: height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(-1, 1),
                              ),
                              BoxShadow(
                                  color: Colors.white, offset: Offset(1, -1))
                            ],
                            color: Colors.red),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter Email";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return "Invalid Email";
                              } else {
                                return emailTaken ? emailErrorText : null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: true,
                            controller: emailController,
                            decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorStyle: TextStyle(
                                  height: 0.1,
                                  color: Colors.white.withOpacity(0.5)),
                              hintText: "Email",
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 20),
                              focusedBorder: InputBorder.none,
                              focusColor: Colors.white,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: width * 0.8,
                        height: height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(-1, 1),
                              ),
                              BoxShadow(
                                  color: Colors.white, offset: Offset(1, -1))
                            ],
                            color: Colors.red),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            validator: (value) {
                              if (value.length < 6) {
                                return "Password Length 6+";
                              } else {
                                return null;
                              }
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorStyle: TextStyle(
                                height: 0.1,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              hintText: "Password",
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 20),
                              focusedBorder: InputBorder.none,
                              focusColor: Colors.white,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  delay: 700,
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTap: () async {

                    setState(() {
                      usernameController.text = usernameController.text.trim();
                      emailController.text = emailController.text.trim();
                      passwordController.text = passwordController.text.trim();
                      usernameTaken = false;
                      emailTaken = false;
                    });
                    if (_formKey.currentState.validate()) {
                      if (!await isInDatabase(usernameController.text)) {
                        setState(() {
                          usernameTaken = false;
                          _formKey.currentState.validate();
                        });

                        if(!await isEmailInDatabase(emailController.text)){
                          UserInformation userInfo =
                          await fireAuth.signUpWithUserNameEmailAndPassword(
                              usernameController.text,
                              emailController.text,
                              passwordController.text);

                          if(_image != null){
                            await uploadProfilePicture(_image, userInfo.username);
                            print("I am here");
                          }
                          Navigator.of(context).pushAndRemoveUntil(FadeRouteBuilder(page: HomeScreen(userInfo: userInfo)), (route) => false);

                        }
                        else{
                          setState(() {
                            emailErrorText = "Email taken";
                            emailTaken = true;
                            _formKey.currentState.validate();
                          });
                        }
                      } else {
                        setState(() {
                          errorText = "Username taken";
                          usernameTaken = true;
                          _formKey.currentState.validate();
                        });
                      }
                    } else {
                      print("Something went wrong");
                    }
                  },
                  child: Container(
                    height: height * 0.08,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      //border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                delay: 1000,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacement(FadeRouteBuilder(page: SignInPage()));
                  },
                  child: Text(
                    "You have an account?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        color: Colors.black,
                        fontFamily: "Open Sans",
                        fontSize: 15),
                  ),
                ),
                delay: 3000,
              )
            ],
          ),
        ),
      )),
    );
  }
}
