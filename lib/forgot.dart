import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'login.dart';
import 'dart:convert';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/Registor_screen.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:dio/dio.dart';
import 'package:mailer/mailer.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:otp/otp.dart';

import 'package:mailer/smtp_server.dart';
import 'OTP.dart';
import 'main.dart';
import 'package:flutter/material.dart';



class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController loginEmailController = TextEditingController();
   final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
   bool isloading=false;
   bool error=false;
Future<void> sendStaticOtpEmail(String recipientEmail) async {
   setState(() {
        isloading=true;
      });
  Debugs("email funcation is called");
  // Replace 'YOUR_EMAIL' and 'YOUR_PASSWORD' with your email credentials
  String email = 'lookranks@gmail.com';
  String password = 'xzit nmya uqar rmel';

  // Replace 'YOUR_NAME' with your name
  final smtpServer = gmail(email, password);

  // Static OTP value
  //String staticOtp = widget.sixcode;
  

  // Create the email message
  final message = Message()
    ..from = Address(email, 'LookRanks')
    ..recipients.add(recipientEmail.toString())
    ..subject = 'Change Password'
    ..text = " Dear User,\nPlease make sure your account stays safe!  Please update your password using the link below:\nhttps://lookranks.com/accounts/password/reset/\nThank you for your prompt attention.Best,\nLookRanks";

  try {
    // Send the email
    await send(message, smtpServer);
    Debugs('Static OTP sent successfully');
     setState(() {
        isloading=false;
      });
      
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),));
       showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Sent"),
            content: Text("Please check your email and use the link provided to change your password"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                  
                },
              )
            ],
          );
        },
      );
       setState(() {
        isloading=false;
        error=true;
      });

  } catch (e) {
    Debugs('Error sending static OTP: $e');
  }
}

    Future<void> forgot() async {
      setState(() {
       isloading=true; 
      });
      var _email;
    setState(() {
      //isLoading = true;
       _email = loginEmailController.text;
     // _name = usernamecontroller.text;
      //_password = loginPasswordController.text;
    });

    final response = await https.post(
      Uri.parse("https://lookranks.com/and_api/frgtpswd/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          //"username": _name.toString(),
          "email": _email.toString(),
          //"password": _password.toString(),
        },
      ),
    );
    Debugs('forgot reponse :${response.statusCode}');

    if (response.statusCode == 200) {
      setState(() {
        isloading=false;
      });
      var data=jsonDecode (response.body);
      Debugs(data);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),));
       showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Sent"),
            content: Text("Please check your email and use the link provided to change your password"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                  
                },
              )
            ],
          );
        },
      );
      
     

    

   

      // Navigate to the home screen or perform other actions on successful login

      
    } else  {
      setState(() {
        isloading=false;
        error=true;
      });
      // Unauthorized: Invalid credentials
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isloading ?Center(
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
            ) :SingleChildScrollView(
      child: Column(
                    children: [
                      SizedBox(height: 10),
                      Image.asset('assets/images/forgot.png'),
                      SizedBox(height: 10),
                      
                      Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: Container(
                    decoration: BoxDecoration(
                            boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 6, // Blur radius
                            offset: Offset(0, 3), // Offset in x and y
                          ),
                        ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.purple[50],
                      border:
                          Border.all(width: 1.5, color: Colors.deepPurple[200]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                    //                Image.asset(
                    //   'assets/images/3.png', // Replace with your image file path
                    //   width: 100,
                    //   height: 100,
                    // ),
                        
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              "Please enter your email for forgot password.",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.0,
                                fontFamily: "Sans",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Form( 
                  key:_registerFormKey ,
                  child: Padding(
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
                                                color: Colors.black45
                                                    .withOpacity(0.05),
                                                spreadRadius: 1.5,
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
                ),
            
                      
                      SizedBox(height: 20),
                      if(error)
                      Padding( padding:EdgeInsets.only(bottom: 10),
                       child:Text("Something went wrong. Please try again.", style: TextStyle(color: Colors.redAccent),)),
                      
                      
                   
                     
                       InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                         final formState =
                                              _registerFormKey.currentState;
                         if (formState!.validate()) {
                          //forgot();
 sendStaticOtpEmail(loginEmailController.text);

                                            // Form is valid, proceed to login
                                            
                                          }
               
                      },
                      child: AnimatedContainer(
              height: 52,
              duration: Duration(milliseconds: 300),
              width: 260,
              decoration: BoxDecoration(
                      boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 6, // Blur radius
                            offset: Offset(0, 3), // Offset in x and y
                          ),
                        ],
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
                "Forget Password",
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
                    InkWell(
                      onTap: () {
                                  
              Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
              
                      },
                      child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 52.0,
                width: 260,
                decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 6, // Blur radius
                            offset: Offset(0, 3), // Offset in x and y
                          ),
                        ],
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 214, 84, 84),
                      Color.fromARGB(255, 201, 59, 59),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Go Back",
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
                SizedBox(height: 20,),
                    ],
                  ),
    ),
    );
   
  }
}