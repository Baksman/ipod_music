import 'package:flutter/material.dart';
import 'dart:math' as maths;

import 'package:ipodmusic/ipod/ipod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
        // scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Ipod(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final numerOfTexts = 20;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.forward(from: 0);
            }
          });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(alignment: Alignment.center, children: [
        ...List.generate(
            numerOfTexts,
            (index) => AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(2 * maths.pi * index / numerOfTexts)
                          ..translate(-60.0),
                        child: LinearText());
                  },
                ))
      ]),
    ));
  }
}

class LinearText extends StatelessWidget {
  final textChild = Text(
    "LINEAR",
    style: TextStyle(color: Colors.white,fontSize: 90, fontWeight: FontWeight.bold),
  );
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: textChild,
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [.15, .5])),
          ),
          Visibility(visible: false, child: textChild)
        ],
      ),
    );
  }
}
