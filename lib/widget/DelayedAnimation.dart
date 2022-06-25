import 'dart:async';

import 'package:flutter/material.dart';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const DelayedAnimation({this.delay, @required this.child});
  @override
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
    duration: Duration(milliseconds: 500),);
    final curve = CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    _animOffset = Tween<Offset>(begin: Offset(0.0, 0.8), end: Offset.zero).animate(curve);

    if(widget.child == null){
      _animationController.forward();
      print("hello");
    }
    else{
      Timer(Duration(milliseconds: widget.delay),
          (){
        _animationController.forward();
        print("hello");
          });
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    print("hello 1");
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animationController,
    );
  }
}
