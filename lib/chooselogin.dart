import 'package:flutter/material.dart';
import 'package:flutter_application_1/Registor_screen.dart';
import 'package:flutter_application_1/login.dart';

class ChooseLogin extends StatefulWidget {
  @override
  _ChooseLoginState createState() => _ChooseLoginState();
}

class _ChooseLoginState extends State<ChooseLogin>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoginSelected = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _isLoginSelected = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _animationController.forward();
      await _animationController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/choosescreen.gif"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(0.0, 1.0),
                  colors: <Color>[
                    Color(0xFF1E2026).withOpacity(0.1),
                    Color(0xFF1E2026).withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 120.0,
                              // bottom: 170.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                "See Your\nLook \nthrough the Eyes\nof Others.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 37.0,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "lemon",
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 40.0,
                                top: 20.0,
                                right: 20.0,
                              ),
                              child: Text(
                                "The World's Best App for Analyzing looks",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Sofia",
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 200.0)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ));

                                setState(() {
                                  // _isLoginSelected = true;
                                });
                                _playAnimation();
                              },
                              child: AnimatedContainer(
                                height: 50,
                                duration: Duration(milliseconds: 300),
                                //height: _isLoginSelected ? 0.0 : 52.0,
                                width: 320,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(80.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFEE140),
                                      Color.fromARGB(255, 251, 158, 71),
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Sofia",
                                    letterSpacing: 0.9,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 30.0)),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Registor_screen(),
                                    ));
                                setState(() {
                                  _isLoginSelected = false;
                                });
                                _playAnimation();
                              },
                              child: AnimatedContainer(
                                height: 50,
                                duration: Duration(milliseconds: 300),
                                width: 320,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(80.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.blueAccent,
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Register Your Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Sofia",
                                    letterSpacing: 0.9,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
