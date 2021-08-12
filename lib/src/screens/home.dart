import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double>? catAnimation;
  AnimationController? catContoller;
  Animation<double>? boxAnimation;
  AnimationController? boxController;

  initState() {
    super.initState();
    initializeBoxAnim();
    initializeCatAnim();
  }

  void initializeBoxAnim() {
    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    boxAnimation = Tween(
      begin: pi * .6,
      end: pi * .65,
    ).animate(
      CurvedAnimation(
        parent: boxController!,
        curve: Curves.easeInOut,
      ),
    );
    boxAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController!.forward();
      }
    });
    boxController!.forward();
  }

  void initializeCatAnim() {
    catContoller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this, //Vsync basically keeps the track of screen
    );
    catAnimation = Tween(begin: -40.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catContoller!,
        curve: Curves.easeIn,
      ),
    );
  }

  void onTap() {
    if (catContoller!.status == AnimationStatus.completed) {
      boxController!.forward();
      catContoller!.reverse();
    } else if (catContoller!.status == AnimationStatus.dismissed) {
      boxController!.stop();
      catContoller!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation!,
      builder: (context, child) {
        return Positioned(
          child: child!,
          top: catAnimation!.value,
          right: 0,
          left: 0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation!,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation!.value,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation!,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -boxAnimation!.value,
          );
        },
      ),
    );
  }
}
