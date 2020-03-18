import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double screenHeight;
  double screenWidth;
  double maxSlide;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    maxSlide = 0.7 * screenWidth;
    return SafeArea(
      child: GestureDetector(
        onHorizontalDragStart: _dragStartHandler,
        onHorizontalDragUpdate: _dragUpdateHandle,
        onHorizontalDragEnd: _dragEndHandle,
        child: Container(
          child: Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        (_animationController.value) * maxSlide - screenWidth,
                        0),
                    child: Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                            (1 - _animationController.value) * math.pi / 2),
                      child: child,
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: Colors.yellow,
                    width: maxSlide,
                    height: screenHeight,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(maxSlide * _animationController.value, 0),
                    child: Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(-_animationController.value * math.pi / 2),
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.green,
                      width: screenWidth,
                      height: screenHeight,
                    ),
                    FloatingActionButton(
                      elevation: 5.0,
                      onPressed: _handleClick,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dragStartHandler(DragStartDetails details) {}
  void _dragUpdateHandle(DragUpdateDetails detail) {
    _animationController.value += detail.primaryDelta / maxSlide;
  }

  void _dragEndHandle(DragEndDetails details) {
    if (_animationController.value < 0.5) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _handleClick() {
    if (_animationController.isCompleted)
      _animationController.reverse();
    else
      _animationController.forward();
  }
}
