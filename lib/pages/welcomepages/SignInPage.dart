import 'package:flutter/material.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/mainPages/MainScreen.dart';
import 'package:messenger_app/services/FirebaseAuth.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/welcomepages/SignUpScreen.dart';
import 'package:messenger_app/widget/DelayedAnimation.dart';
import 'package:messenger_app/widget/User.dart';
import 'package:ripple_effect/ripple_effect.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();
  final fireInstance = FireAuth();
  bool usernameChange = false;
  String usernameErrorText = "";
  bool passwordChange = false;
  String passwordErrorText = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Colors.blue
            ),
            child: Padding(
              padding: EdgeInsets.only(top: height*0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DelayedAnimation(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    delay: 100,
                  ),
                  SizedBox(height: height*0.02,),
                  DelayedAnimation(child: Text(
                    "Let's get you in",
                    style: TextStyle(
                        fontFamily: "Open Sans",
                        fontSize: 18,
                        color: Color.fromRGBO(255, 255, 255, 0.5),

                        fontWeight: FontWeight.w600
                    ),
                  ),
                    delay: 400,),
                  SizedBox(height: height*0.25,),
                  DelayedAnimation(
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            width: width*0.8,
                            height: height*0.08,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(color: Colors.black, offset: Offset(-1, 1),),
                                  BoxShadow(color: Colors.white, offset: Offset(1, -1))
                                ],
                                color: Colors.blue
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Enter Email or Username";
                                  }
                                  return usernameChange? usernameErrorText:null;
                                },
                                controller: usernameController,
                                decoration: InputDecoration(
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  errorStyle: TextStyle(
                                      height: 0.1,
                                      color: Colors.white.withOpacity(0.5)),
                                  hintText: "Username/Email",
                                  enabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 20
                                  ),
                                  focusedBorder: InputBorder.none,
                                  focusColor: Colors.white,

                                ),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height*0.05,),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            width: width*0.8,
                            height: height*0.08,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(color: Colors.black, offset: Offset(-1, 1),),
                                  BoxShadow(color: Colors.white, offset: Offset(1, -1))
                                ],
                                color: Colors.blue
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                validator: (value){
                                  if (value.isEmpty){
                                    return "Enter Password";
                                  }
                                  return passwordChange ? passwordErrorText: null;
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  errorStyle: TextStyle(
                                      height: 0.1,
                                      color: Colors.white.withOpacity(0.5)),
                                  hintText: "Password",
                                  enabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 20
                                  ),
                                  focusedBorder: InputBorder.none,
                                  focusColor: Colors.white,

                                ),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),],
                      ),
                    ),
                    delay: 700,
                  ),
                  SizedBox(height: height*0.05,),
                  DelayedAnimation(
                    child: GestureDetector(
                      onTap: () async{
                        setState(() {
                          usernameController.text.trim();
                          usernameChange = false;
                          passwordChange = false;
                        });

                        if(_signInFormKey.currentState.validate()){
                          if(usernameController.text.contains("@")){
                            if(RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(usernameController.text)){
                              UserInformation userInfo =
                              await fireInstance.signInWithEmailAndPassword(usernameController.text, passwordController.text);
                              if(userInfo == null){
                                setState(() {
                                  usernameChange = true;
                                  passwordChange = true;
                                  usernameErrorText = "Wrong Email";
                                  passwordErrorText = "Wrong Password";
                                  _signInFormKey.currentState.validate();
                                });
                              }
                              else{
                                Navigator.of(context).pushReplacement(FadeRouteBuilder(
                                    page: HomeScreen(userInfo: userInfo)));
                              }


                            }
                            else{
                              setState(() {
                                usernameChange = true;
                                usernameErrorText = "Invalid Email";
                                _signInFormKey.currentState.validate();
                              });
                            }
                          }
                          else{
                            UserInformation userInfo =
                            await fireInstance.signInWithUserNameAndPassword(usernameController.text, passwordController.text);
                            if(userInfo == null){
                              setState(() {
                                usernameChange = true;
                                passwordChange = true;
                                usernameErrorText = "Wrong Username";
                                passwordErrorText = "Wrong Password";
                                _signInFormKey.currentState.validate();
                              });
                            }
                            else{
                              Navigator.of(context).pushAndRemoveUntil(FadeRouteBuilder(page: HomeScreen(userInfo: userInfo)), (route) => false);

                            }
                          }
                        }
                      },
                      child: Container(
                        height:height*0.08,
                        width: width* 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          //border: Border.all(color: Colors.black)
                        ),
                        child: Center(
                          child: Text(
                            "Sign In",
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
                  SizedBox(height: height*0.05,),
                  DelayedAnimation(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(FadeRouteBuilder(page: SignUpPage()));
                      },
                      child: Text(
                        "You're New?'",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            color: Colors.black,
                            fontFamily: "Open Sans",
                            fontSize: 15
                        ),
                      ),
                    ),
                    delay: 3000,
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
