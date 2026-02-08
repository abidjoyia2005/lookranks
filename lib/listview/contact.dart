import 'package:flutter/material.dart';
import 'package:flutter_application_1/guider/notification_sender.dart';
import 'dart:convert';
import 'package:http/http.dart' as https;

import '../Bottom.dart';


class CallCenter extends StatefulWidget {
  @override
  _CallCenterState createState() => _CallCenterState();
}

class _CallCenterState extends State<CallCenter> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name, _email, _problem;
  TextEditingController nama = TextEditingController();
  TextEditingController emails = TextEditingController();
  TextEditingController problems = TextEditingController();


  Future<void> Feedback() async {
   // _showLoadingDialog(context);
    setState(() {
      _email = emails.text;
      _problem = problems.text;
    });

    final response = await https.post(
      Uri.parse("https://lookranks.com/and_api/feedback/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          "email": _email,
          "message": _problem,
        },
      ),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body.toString());
      Debugs(data);
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
              child: Text(
            'Thanks for your feedback!',
            style: TextStyle(color: Colors.green),
          )),
        ),
      );

      // Assuming your API returns a token and user ID, retrieve them from the response.

      // Save the token and user ID to shared preferences.
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('usertoken', token);
      // prefs.setInt('user_id', userId);
      // prefs.setBool("isLogin", true);

      // Navigate to the home screen or perform other actions on successful login
    } else if (response.statusCode == 400) {
      // Unauthorized: Invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Email"),
            content: Text(" Please Check your Email & try again."),
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
    }

    //  else if (response.statusCode == 500) {
    //   var data = jsonDecode(response.body.toString());
    //   Debugs("e:$_email  p:$_password");
    //   // Internal Server Error: Server-side issue
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text("Server Error"),
    //         content: Text(
    //             "An internal server error occurred. Please try again later.  respones :$data"),
    //         actions: <Widget>[
    //           ElevatedButton(
    //             child: Text("Close"),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     },
    //   );
    // }

    else {
      var data = jsonDecode(response.body.toString());
      Debugs(data);

      // Handle other status codes as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("An error occurred. Please try again later."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.yellow[700]),
        centerTitle: true,
        elevation: 0.0,
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            Image.asset('assets/images/Contactus.png'),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.purple[100],
                border: Border.all(width: 1.5, color: Colors.deepPurple[400]!),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text:
                          "If something goes wrong with our system, or there are suggestions or bugs that interfere with the use of the application, Please let us know through this form or contact us via email at ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                        fontFamily: "Sans",
                        color: Colors.black, // You can set the color you want
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "contact@lookranks.com",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ", we will respond as soon as possible.",
                        ),
                      ],
                    ),
                  )),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Name",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      return null;
                    },
                    onSaved: (input) => _name = input,
                    controller: nama,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black12.withOpacity(0.01),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(13.0),
                      hintText: "Input your name",
                      hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Email",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      return null;
                    },
                    onSaved: (input) => _email = input,
                    controller: emails,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black12.withOpacity(0.01),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(13.0),
                      hintText: "Input your email",
                      hintStyle: TextStyle(fontFamily: "Sans", fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Detail Problem",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextFormField(
                      validator: (input) {
                        return null;
                      },
                      maxLines: 6,
                      onSaved: (input) => _problem = input,
                      controller: problems,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.black12.withOpacity(0.01),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(13.0),
                        hintText: "Input your problem",
                        hintStyle:
                            TextStyle(fontFamily: "Sans", fontSize: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () async{
                      //sendFCMMessage('lookranks-5545c','assets/images/lookranks-5545c-firebase-adminsdk-84b5h-7b1d1426ec.json','e90QiHiIT4i6bzYhj1legt:APA91bHBpka84Zmch1hw67qhCjCp789POQbYAbvGkvwtXniZ0rbUTeL3v6StoC7hUIRKGh8sCU1_FymreoOA0BNxuDfGnmhpqCvQc4L5Bos2cSF8oXNCo4Y7Tqa0HTTvjaHQ9tvMQtIJ','hello','i am abid');
                      final formState = _formKey.currentState;
                     
                      Feedback();

                      if (formState!.validate()) {
                        formState!.save();
                        // Process and submit the form data here
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please input your information"),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
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
                        color:
                            Colors.blue, // Change to your desired button color
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Sofia",
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
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


