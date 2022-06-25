
import 'package:flutter/material.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/welcomepages/SignInPage.dart';
import 'file:///C:/Users/adeso/AndroidStudioProjects/messenger_app/lib/pages/welcomepages/SignUpScreen.dart';
import 'package:messenger_app/widget/DelayedAnimation.dart';
import 'package:ripple_effect/ripple_effect.dart';



class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double xOffset = 0;
  bool onPageChanged = false;
  final pageKey = RipplePage.createGlobalKey();
  final signUpKey = RippleEffect.createGlobalKey();
  final signInKey = RippleEffect.createGlobalKey();

  Future<void> toSignUpPage() => Navigator.of(context).push(
    FadeRouteBuilder(
      page: SignUpPage(),
    ),
  );

  Future<void> toSignInPage() => Navigator.of(context).push(
    FadeRouteBuilder(
      page: SignInPage(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;



    return RipplePage(
      pageKey: pageKey,
      child: Scaffold(
        body: Container(
          width: width,
          decoration: BoxDecoration(
            color:  Color.fromRGBO(238,238,238, 1),

          ),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: height*0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DelayedAnimation(child: Text(
                    "Welcome User",
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  delay: 1000,),
                  SizedBox(height: height*0.01,),
                  DelayedAnimation(child: Text(
                    "Are you new?",
                    style: TextStyle(
                        fontFamily: "Open Sans",
                        fontSize: 18,
                        color: Color.fromRGBO(0, 0, 0, 0.5),

                        fontWeight: FontWeight.w600
                    ),
                  ),
                    delay: 1500,),
                  SizedBox(height: height*0.43,),
                  DelayedAnimation(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RippleEffect(
                        pageKey: pageKey,
                        effectKey: signUpKey,
                        color: Colors.red,
                        child: GestureDetector(
                          onTap: (){
                            RippleEffect.start(signUpKey, () => toSignUpPage());
                          },
                          child: Container(
                            height:height*0.08,
                            width: width* 0.4,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                              //border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontFamily: "Open Sans",
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      RippleEffect(
                        pageKey: pageKey,
                        effectKey: signInKey,
                        color: Colors.blue,
                        child: GestureDetector(
                          onTap: (){
                            RippleEffect.start(signInKey, () => toSignInPage());
                          },
                          child: Container(
                            height:height*0.08,
                            width: width* 0.4,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                                //border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontFamily: "Open Sans",
                                    fontSize: 20,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ), delay: 2000,)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
