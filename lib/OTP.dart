import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/Registor_screen.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as https;
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

class OTP extends StatefulWidget {
  var sixcode;
  var name;
  var email;
  OTP({super.key,required this.sixcode ,required this.name, required this.email});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  void initState() {
    super.initState();
   sendStaticOtpEmail(email);
  }
  bool notmacth=false;
 
  void checkcode(var c)async{
   setState(() {
     isLoading =true;
   });

    if(c==widget.sixcode){
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLogin", true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Bottom(),
        ),
      );
    }else{
      setState(() {
        isLoading=false;
        notmacth=true;
      });

    }
  }  
 
Future<void> sendStaticOtpEmail(String recipientEmail) async {
  print("email funcation is called");
  // Replace 'YOUR_EMAIL' and 'YOUR_PASSWORD' with your email credentials
  String email = 'lookranks@gmail.com';
  String password = 'xzit nmya uqar rmel';

  // Replace 'YOUR_NAME' with your name
  final smtpServer = gmail(email, password);

  // Static OTP value
  String staticOtp = widget.sixcode;
  

  // Create the email message
  final message = Message()
    ..from = Address(email, 'LookRanks')
    ..recipients.add(recipientEmail)
    ..subject = 'OTP Verification'
    ..text = 'Dear ${widget.name},\n your One-Time Password (OTP) is: $staticOtp\n Use this unique code for secure access and protect it from unauthorized access.';

  try {
    // Send the email
    await send(message, smtpServer);
    print('Static OTP sent successfully');
  } catch (e) {
    print('Error sending static OTP: $e');
  }
}

  // Controller for the OTP text fields
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
bool isLoading=false;
  

    

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ):SingleChildScrollView(
              child: Column(
                    children: [
                      SizedBox(height: 10),
                      Image.asset('assets/images/OTP.png'),
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
                          Center(
                            child: Text(
                              "OTP   ",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                // letterSpacing: 1.2,
                                fontFamily: "Sans",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              "Please check your email and enter the 6-character code",
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
            
                      
                      SizedBox(height: 20),
                      Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _otpControllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    maxLength: 1,
                    onChanged: (value) {
                      // You can add any additional logic when OTP is entered
                      if (value.isNotEmpty && index < 5) {
                        _otpControllers[index + 1].text = '';
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      counter: Offstage(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              
                      ),
                      if(notmacth)
                      Text("OTP incorrect",style: TextStyle(color: Colors.redAccent),),
                      SizedBox(height: 20),
                       InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                         
                 String otp = _otpControllers.map((controller) => controller.text).join();
                print("Entered OTP: $otp");
                checkcode(otp);
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
                "Verify",
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
                         setState(() {
                   isLoading=true;
                  });
                       
              Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Registor_screen(),
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
