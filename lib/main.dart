import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

final _colorG1 = Color.fromRGBO(850, 100, 758, 1.25);
final _colorG2 = Color.fromRGBO(55, 20, 15, 1);

final _colorG3 = Color.fromRGBO(450, 171, 255, 1);
final _colorG4 = Color.fromRGBO(120, 241, 255, 1);

final _colorBtn1 = Color.fromRGBO(0, 207, 200, 1);
final _colorBtn2 = Color.fromRGBO(0, 241, 158, 1);

final _actionBtnColor = Color.fromRGBO(255, 131, 82, 1);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> btnAnimation;
  AnimationController actionBtnCtrl;
  Animation<double> curveAnimation;
  AnimationController curveCtrl;
  Animation<double> animationInputs;
  AnimationController animationControllerInputs;
  Animation<double> titleAnimation;
  AnimationController titleCtrl;

  String _actionBtnText = 'Register';
  String _currentPage = 'Login';
  bool isForgotVisible = true;

  @override
  void initState() {
    super.initState();

    titleCtrl =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    titleAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: titleCtrl,
      curve: Curves.easeInCubic,
    ));

    curveCtrl = AnimationController(
      value: 0.0,
      duration: Duration(milliseconds: 750),
      upperBound: 0.5,
      lowerBound: 0,
      vsync: this,
    );

    actionBtnCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    btnAnimation = Tween<double>(begin: 0, end: -120).animate(CurvedAnimation(
      parent: actionBtnCtrl,
      curve: Curves.easeInCubic,
    ));

    animationControllerInputs =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    actionBtnCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(Duration(milliseconds: 150), () {
          if (_actionBtnText == 'Register') {
            setState(() {
              _actionBtnText = 'Login';
              _currentPage = 'Register';
            });
          } else {
            setState(() {
              _actionBtnText = 'Register';
              _currentPage = 'Login';
            });
          }
          actionBtnCtrl.reverse();
          animationControllerInputs.reverse();
          titleCtrl.reverse();
        });
      }
    });
  }

  @override
  void dispose() {
    actionBtnCtrl.dispose();
    curveCtrl.dispose();
    animationControllerInputs.dispose();
    titleCtrl.dispose();
    super.dispose();
  }

  void _switchPage() {
    // Forgot password animation
    var dur = isForgotVisible ? 0 : 500;
    Timer(Duration(milliseconds: dur), () {
      setState(() {
        isForgotVisible = !isForgotVisible;
      });
    });

    // other animations
    titleCtrl.forward();
    animationControllerInputs.forward();
    actionBtnCtrl.forward();

    // top/bottom sections animation
    if (_actionBtnText == 'Register') {
      curveCtrl.forward();
    } else {
      curveCtrl.reverse();
    }
  }

  Widget navButton() {
    return Container(
      height: 50.0,
      width: 120.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(65.0),
          bottomRight: Radius.circular(65.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(208, 209, 217, 0.5),
            offset: Offset(0.0, 4.0),
            blurRadius: 8.0,
            spreadRadius: 0.3,
          ),
        ],
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          onTap: _switchPage,
          child: Center(
            child: Text(
              _actionBtnText,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: _actionBtnColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavButton() {
    return AnimatedBuilder(
      animation: actionBtnCtrl,
      child: navButton(),
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(btnAnimation.value, 0),
            child: child,
          ),
        );
      },
    );
  }

  Widget inputContainer(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            height: _currentPage == 'Login' ? 130 : 180,
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(65.0),
                bottomRight: Radius.circular(65.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(208, 209, 217, 0.5),
                  offset: Offset(0.0, 1.0),
                  blurRadius: 8.0,
                  spreadRadius: 0.3,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Icon(
                            Feather.user,
                            color: Color.fromRGBO(203, 207, 218, 1),
                            size: 18.0,
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(132, 144, 155, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color.fromRGBO(208, 209, 217, 1),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Icon(
                            Feather.lock,
                            color: Color.fromRGBO(203, 207, 218, 1),
                            size: 18.0,
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(132, 144, 155, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (_currentPage == 'Register')
                  Divider(
                    height: 1,
                    color: Color.fromRGBO(208, 209, 217, 1),
                  ),
                if (_currentPage == 'Register')
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Icon(
                              Feather.at_sign,
                              color: Color.fromRGBO(203, 207, 218, 1),
                              size: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(132, 144, 155, 1),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: _currentPage == 'Login' ? 35.0 : 60.0,
            right: 20,
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [_colorBtn1, _colorBtn1, _colorBtn2],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(208, 209, 217, 0.7),
                    offset: Offset(0.0, 5.0),
                    blurRadius: 10.0,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white54,
                  borderRadius: BorderRadius.circular(30.0),
                  onTap: () {},
                  child: Center(
                    child: Icon(
                      _currentPage == 'Login'
                          ? Icons.arrow_forward
                          : Icons.check,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_currentPage == 'Login')
            Positioned(
              right: 40,
              bottom: -50,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(203, 207, 218, 1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildInputsAndButton(context) {
    return AnimatedBuilder(
        animation: animationControllerInputs,
        child: inputContainer(context),
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(animationInputs.value, 0),
              child: child,
            ),
          );
        });
  }

  Widget title() {
    return Text(_currentPage,
        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w700));
  }

  Widget buildTitle() {
    return AnimatedBuilder(
        animation: titleCtrl,
        child: title(),
        builder: (context, child) {
          return Opacity(
            opacity: titleAnimation.value,
            child: child,
          );
        });
  }

  Widget _buildTopSection(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: curveCtrl,
      builder: (context, child) {
        return ClipPath(
            clipper: TopSectionClipper(curveCtrl.value), child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_colorG1, _colorG2, _colorG2],
          ),
        ),
        height: size.height / 4,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildCenterSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          buildTitle(),
          Expanded(
            child: buildInputsAndButton(context),
          ),
          buildNavButton(),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: curveCtrl,
      builder: (context, child) {
        return ClipPath(
            clipper: BottomSectionClipper(curveCtrl.value), child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [_colorG3, _colorG4, _colorG4],
          ),
        ),
        height: size.height / 4,
        alignment: Alignment.topCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    animationInputs =
        Tween<double>(begin: 0, end: -size.width).animate(CurvedAnimation(
      parent: animationControllerInputs,
      curve: Curves.easeInCubic,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              _buildTopSection(context),
              _buildCenterSection(context),
              _buildBottomSection(context),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSectionClipper extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;

  BottomSectionClipper(this.move);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height / 1.5);
    double xCtrlPoint = size.width * math.sin(move * slice);
    double yCtrlPoint = size.height * 0.8 + 69 * math.cos(move * slice);
    ;
    var endPoint = Offset(size.width, 0);
    path.quadraticBezierTo(xCtrlPoint, yCtrlPoint, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TopSectionClipper extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;

  TopSectionClipper(this.move);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    double xCenter =
        (size.width / 6) + (size.width * 0.6 + 50) * math.sin(move * slice);
    double yCenter = 0;

    var endPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(xCenter, yCenter, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
