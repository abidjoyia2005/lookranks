import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OTP.dart';
import 'main.dart';

class ContinueWithGoogleButton extends StatefulWidget {
  final Function onPressed;

  ContinueWithGoogleButton({required this.onPressed});

  @override
  State<ContinueWithGoogleButton> createState() =>
      _ContinueWithGoogleButtonState();
}

class _ContinueWithGoogleButtonState extends State<ContinueWithGoogleButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
      child: SignInButton(
        Buttons.Google,
        onPressed: widget.onPressed,
        text: "Continue with Google",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class ContinueWithFacebookButton extends StatelessWidget {
  final Function onPressed;

  ContinueWithFacebookButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Adjust the width as needed
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF1877F2), // Facebook blue color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/facebook_logo.png',
              height: 25, // Adjust the logo height as needed
            ),
            SizedBox(width: 10), // Add some spacing between logo and text
            Text(
              "Continue with Facebook",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Registor_screen extends StatefulWidget {
  const Registor_screen({super.key});

  @override
  State<Registor_screen> createState() => _Registor_screen();
}

class _Registor_screen extends State<Registor_screen> {
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void settoken(String tokens) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('usertoken', tokens);
  }

  bool isLoading = false;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late String _email, _password, _name;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  void saveddata(int id, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('usertoken', token);
    prefs.setBool('FCBtokenuploaded', false);
    prefs.setInt('user_id', id);
   // prefs.setBool("isLogin", true);
  }

  Future<void> LoadData(String Tok, email) async {
    String username = Tok;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', username);
    prefs.setString("email", email);
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      _email = loginEmailController.text;
      _name = usernamecontroller.text;
      _password = loginPasswordController.text;
    });

    final response = await https.post(
      Uri.parse("https://lookranks.com/and_api/register/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "username": _name.toString(),
          "email": _email.toString(),
          "password": _password.toString(),
          //'fb_token': FCMToken!,
        },
      ),
    );

    if (response.statusCode == 201) {
      
      Debugs("e:$_email n:$_name p:$_password");
      var data = jsonDecode(response.body.toString());
      
      LoadData(_name, _email);
      Debugs(data);

      // Assuming your API returns a token and user ID, retrieve them from the response.
      String token = data["token"];
      int userId = data["user_id"];
      UploadFB_Token(token);
      String firstSixCharacters = token.substring(0, 6);
      Debugs("token is :$token");
      saveddata(userId, token);
      getid();
      

      //Save the token and user ID to shared preferences.
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('usertoken', token);
      prefs.setInt('user_id', userId);
      //prefs.setBool("isLogin", true);

      // Navigate to the home screen or perform other actions on successful login

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OTP(sixcode: firstSixCharacters,email:_email.toString() , name:_name.toString() , ),
        ),
      );
    } else if (response.statusCode == 401) {
      // Unauthorized: Invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registor Failed"),
            content: Text("Invalid email or password. Please try again."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Registor_screen(),
                      ));
                },
              )
            ],
          );
        },
      );
    }else if (response.statusCode == 400) {
      // Unauthorized: Invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registor Failed"),
            content: Text("The entered email or username is already in use. Please choose a different one."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Registor_screen(),
                      ));
                },
              )
            ],
          );
        },
      );
    } else if (response.statusCode == 500) {
      var data = jsonDecode(response.body.toString());
      Debugs("e:$_email n:$_name p:$_password");
      // Internal Server Error: Server-side issue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registor Failed"),
            content: Text(
                "An internal server error occurred. Please try again later."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Registor_screen(),
                      ));
                },
              )
            ],
          );
        },
      );
    } else {
      var data = jsonDecode(response.body.toString());
      Debugs(data);
      Debugs("e:$_email n:$_name p:$_password");
      // Handle other status codes as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registor Failed"),
            content: Text("An error occurred. Please try again later."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                 Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Registor_screen(),
                      ));
                },
              )
            ],
          );
        },
      );
    }
  }
  Future<void> UploadFB_Token(String token) async {
   
    final response = await https.put(
      Uri.parse("https://lookranks.com/and_api/fbtoken/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',


      },
      body: jsonEncode(
        {
          
          'fb_token': FCMToken!,
        },
      ),
    );

    if (response.statusCode == 200) {
      Debugs("Token uploaded");
      
      Debugs(response.body);
      


     
    } else {
      var data = jsonDecode(response.body.toString());
      Debugs("Token not uploaded");
      Debugs(data);
     
    }
  }
    
 

  Future<void> performGoogleLogin(
    String googleToken,
    String username2,
    String googleResponseEmail,
    String picUrl,
  ) async {
     final prefs = await SharedPreferences.getInstance();
    
   prefs.setBool('FCBtokenuploaded', false);
    Debugs('Google Token: $googleToken');
    Debugs('Username: $username2');
    Debugs('Email: $googleResponseEmail');
    // Debugs('FCMT: $FCMToken');
    Debugs('PICURL: $picUrl');

    setState(() {});

    var headers = {
      'Authorization': 'Bearer $googleToken',
      'Content-Type': 'application/json',
    };
    var request = https.MultipartRequest(
        'POST', Uri.parse('https://lookranks.com/and_api/google-login/'));
    request.fields.addAll({
      'email': googleResponseEmail,
      'username': username2,
      
      'picurl': picUrl,
    });

    request.headers.addAll(headers);

    https.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
     

      final tokens = data["token"];

      final name = data["username"];
      UploadFB_Token(tokens);
     
      LoadData(name, googleResponseEmail); // Define this function
      saveddata(0, tokens); // Define this function
      getid(); // Define this function

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Bottom(),
        ),
      );
    } else {
      Debugs(response.reasonPhrase);
    }
  }

  googleLogin() async {
    Debugs("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return 0;
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is signed in successfully
      if (finalResult.user != null) {
        Debugs("Google Access Token: ${userData.accessToken}");
        Debugs("Result $result");
        Debugs(result.displayName);
        Debugs(result.email);
        Debugs(result.photoUrl);

        setState(() {
          isLoading = true;
        });
        performGoogleLogin(userData.accessToken!, result.displayName!,
            result.email, result.photoUrl!);

        // Navigate to the home screen
      } else {
        Debugs("Failed to sign in with Firebase.");
      }
    } catch (error) {
      Debugs(error);
    }
  }
  Future<UserCredential> signInWithFacebook() async {
  try {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      print("facebook login failed");
      throw FirebaseAuthException(
        code: 'Facebook Login Failed',
        message: 'The Facebook login was not successful.',
      );
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase authentication exceptions
    Debugs('Firebase Auth Exception: ${e.message}');
    throw e; // rethrow the exception
  } catch (e) {
    // Handle other exceptions
    Debugs('Other Exception: $e');
    throw e; // rethrow the exception
  }
}

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

// Define a function for Facebook login
  Future<void> facebookLogin() async {
    // Debugs a message indicating that Facebook login is being attempted
    Debugs("Facebook Login");

    try {
      // Attempt to login with Facebook and request 'public_profile' and 'email' permissions
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);

      // Check if the login was successful
      if (result.status == LoginStatus.success) {
        // Fetch user data after successful login
        final userData = await FacebookAuth.i.getUserData();

        // Debugs the user data to the console
        Debugs(userData);
      } else {
        // Handle the case where Facebook login was not successful
        Debugs("Facebook Login failed");
      }
    } catch (error) {
      // Handle any errors that occur during the login process
      Debugs("Error during Facebook Login: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    child: Image(image: AssetImage('assets/images/logo4.gif')),
                  ),
                  Container(
                    height: 136,
                    width: 136,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        ContinueWithGoogleButton(
                          onPressed: googleLogin,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ContinueWithFacebookButton(onPressed:signInWithFacebook ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Container(
                              height: _height,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Form(
                                key: _registerFormKey,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Text(
                                      "-OR-",
                                      style: TextStyle(
                                        fontFamily: "Lemon",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Create Account",
                                          style: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 34.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 40.0,
                                      ),
                                      child: Container(
                                        height: 53.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6.0,
                                              color: Colors.black12
                                                  .withOpacity(0.05),
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12.0,
                                            top: 5.0,
                                          ),
                                          child: Theme(
                                            data: ThemeData(
                                              hintColor: Colors.transparent,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: TextFormField(
                                                validator: (input) {
                                                  if (input!.isEmpty) {
                                                    return 'Please type an email';
                                                  }
                                                },
                                                controller:
                                                    loginEmailController,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                autocorrect: false,
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.all(0.0),
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  labelText: 'Email',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black38,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: "Sofia",
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 20.0,
                                      ),
                                      child: Container(
                                        height: 53.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6.0,
                                              color: Colors.black12
                                                  .withOpacity(0.05),
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12.0,
                                            top: 5.0,
                                          ),
                                          child: Theme(
                                            data: ThemeData(
                                              hintColor: Colors.transparent,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: TextFormField(
                                                validator: (input) {
                                                  if (input!.isEmpty) {
                                                    return 'Please type an username';
                                                  }
                                                },
                                                controller: usernamecontroller,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                autocorrect: false,
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.all(0.0),
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  labelText: 'username',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black38,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: "Sofia",
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 15.0,
                                      ),
                                      child: Container(
                                        height: 53.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6.0,
                                              color: Colors.black12
                                                  .withOpacity(0.05),
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          border: Border.all(
                                            color: Colors.black12,
                                            width: 0.15,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12.0,
                                            top: 5.0,
                                          ),
                                          child: Theme(
                                            data: ThemeData(
                                              hintColor: Colors.transparent,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: TextFormField(
                                                validator: (input) {
                                                  if (input!.isEmpty) {
                                                    return 'Please type a password';
                                                  }
                                                },
                                                controller:
                                                    loginPasswordController,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                autocorrect: false,
                                                autofocus: false,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.all(0.0),
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  labelText: 'Password',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black38,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: "Sofia",
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 40.0,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          final formState =
                                              _registerFormKey.currentState;

                                          if (formState!.validate()) {
                                            // Form is valid, proceed to login
                                            loginUser();
                                          }
                                        },
                                        child: Container(
                                          height: 52.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                             boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFFEE140),
                                                Color(0xFFFF942F),
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Sofia",
                                                letterSpacing: 0.9,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                          (Route<dynamic> route) =>
                                              false, // This condition matches any route
                                        );
                                      },
                                      child: Hero(
                                        tag: "login",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "You have an account?",
                                              style: TextStyle(
                                                fontFamily: "Sofia",
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              " Login",
                                              style: TextStyle(
                                                fontFamily: "Sofia",
                                                color: Color(0xFFFF942F),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
