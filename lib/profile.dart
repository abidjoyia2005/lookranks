import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/listview/CreateProfile.dart';
import 'package:flutter_application_1/listview/Createpost.dart';
import 'package:flutter_application_1/listview/about.dart';
import 'package:flutter_application_1/listview/Createpost.dart';
import 'package:flutter_application_1/listview/first.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Bottom.dart';
import 'listview/contact.dart';
import 'listview/privacy.dart';
import 'listview/terms&conditions.dart';
import 'listview/yourpost.dart';
import 'login.dart';
import 'package:http/http.dart' as https;

class ProfileScreen extends StatelessWidget {
  var btoken;
  var bid;
  ProfileScreen({required this.btoken, required this.bid});
  @override
  Widget build(BuildContext context) {
    return Profile(
      btoken: btoken,
      bid: bid,
    );
  }
}

class Profile extends StatelessWidget {
  var bid;
  var btoken;
  // List<String> imageUrls = [
  //   "https://image.shutterstock.com/image-photo/young-handsome-man-beard-wearing-260nw-1768126784.jpg",
  //   "https://image.shutterstock.com/image-photo/young-handsome-man-beard-wearing-260nw-1768126784.jpg",
  //   "https://image.shutterstock.com/image-photo/young-handsome-man-beard-wearing-260nw-1768126784.jpg",
  // ];
  Profile({required this.btoken, required this.bid});
  Future<void> logout() async {
    try {
      // Disconnect Google Sign-In

      // Remove data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.setString("usertoken", "");
      await prefs.setInt("user_id", 0);
      await prefs.setBool("isLogin", false);
      await prefs.setString("profilepicture", "null");
      await prefs.setString("email", "");
      await prefs.setInt("appnotificationcount", 0);
      userHasProfileImage = false;
      await GoogleSignIn().disconnect();
      UploadFB_Token(usertoken!);

      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      // Handle any errors that might occur during the logout process
      Debugs("Error during logout: $error");
      // You can add additional error handling code here, such as showing an error message to the user.
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
          
          'fb_token':"null",
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

  Future<void> DeletefullAccount(context) async {
    final res = await https.post(
      Uri.parse("https://lookranks.com/and_api/delete-account/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
    );

    if (res.statusCode == 204) {
      logout();
      Debugs("Acount deleted");
      Debugs(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Your Acount has been deleted.',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async {
              return false;
              // Handle back button press here if needed.
              // Return true to allow popping, or false to prevent it.
              // return true;
            },
            child: LoginScreen(),
          ),
        ),
      );
    } else {
      Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                // if (imageUrls.length > 1)
                //   CarouselSlider(
                //     options: CarouselOptions(
                //       autoPlay: true,
                //       enlargeCenterPage: true,
                //       aspectRatio: 13 / 14,
                //     ),
                //     items: imageUrls.map((imageUrls) {
                //       return Stack(children: [
                //         Container(
                //             width: double.infinity,
                //             child: Image.network(imageUrls, fit: BoxFit.cover)),
                //       ]);
                //     }).toList(),
                //   ),
                // if (imageUrls.length == 1)
                //   Stack(
                //     children: [
                //       Container(
                //         height: MediaQuery.of(context).size.height / 1.7,
                //         width: double.infinity,
                //         child: Image.network(
                //           imageUrls.first,
                //           fit: BoxFit.fitHeight,
                //         ),
                //       ),
                //     ],
                //   ),
                Stack(
                  children: [
                    Container(
                      height: 270.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://lookranks-s3space.sgp1.cdn.digitaloceanspaces.com/app-images/profile-bg.webp",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 195,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(0.0, 1.0),
                            colors: <Color>[
                              Colors.white.withOpacity(0.01),
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.1),
                              Colors.white,
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 67.0, left: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: userHasProfileImage
                                  ? NetworkImage(Profilepic ?? "")
                                  : AssetImage(
                                          "assets/images/No_profile_pic.png")
                                      as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7.0,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserName!.length > 16
                                  ? '${UserName?.substring(0, 16)}...' ?? " "
                                  : UserName!,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              email.length > 24
                                  ? "${email.substring(0, 23)}..."
                                  : email,
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Postscreen()));
                },
                child: Category(
                  txt: "Create Post",
                  image: "assets/images/addRecipe.png",
                  padding: MediaQuery.sizeOf(context).width / 2.5,
                ),
              ),
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => DetailPost()));
                    },
                    child: Category(
                      txt: "Your Post",
                      image: "assets/images/yourRecipes.png",
                      padding: 167.0,
                    ),
                  ),
                ])),
            // Padding(
            //     padding: const EdgeInsets.only(top: 20.0),
            //     child: Column(children: <Widget>[
            //       InkWell(
            //         onTap: () {
            //           Navigator.of(context).push(PageRouteBuilder(
            //               pageBuilder: (_, __, ___) =>
            //                   new UpdateProfileScreen()));
            //         },
            //         child: Category(
            //           txt: "Edit Profle",
            //           image: "assets/images/editProfile.png",
            //           padding: 20.0,
            //         ),
            //       ),
            //     ])),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new CallCenter()));
                    },
                    child: Category(
                      txt: "Contact us",
                      image: "assets/images/callCenter.png",
                      padding: 153.0,
                    ),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new aboutApps()));
                    },
                    child: Category(
                      txt: "About      ",
                      image: "assets/images/phone.png",
                      padding: 163.0,
                    ),
                  ),
                ])),
                 InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => privacy(),
                    ));
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(children: <Widget>[
                    Category(
                      txt: "Privacy Policy",
                      image: "assets/images/termcondion.png",
                      padding: 85,
                    ),
                  ])),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionsApp(),
                    ));
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(children: <Widget>[
                    Category(
                      txt: "Terms & Conditions",
                      image: "assets/images/policy.png",
                      padding: 85,
                    ),
                  ])),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (userHasProfileImage) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Post",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                "You should delete your post before deactivating your account.",
                                style: TextStyle(fontFamily: 'Sofia'),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.blue, // Text color
                                      ),
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the alert dialog
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.red, // Text color
                                      ),
                                      child: Text("Remove"),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPost(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(15.0),
                              // ),
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                "Are you sure you want to deactivate your account?",
                                style: TextStyle(fontFamily: 'Sofia'),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.blue, // Text color
                                      ),
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the alert dialog
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.red, // Text color
                                      ),
                                      child: Text("Delete"),
                                      onPressed: () {
                                        DeletefullAccount(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(15.0),
                              // ),
                            );
                          },
                        );
                      }
                    },
                    child: Category(
                      txt: "Delete Acount",
                      image: "assets/images/Deleteacount.png",
                      padding: 125,
                    ),
                  ),
                ])),

            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(children: <Widget>[
                  InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              "Are you sure you want to logout?",
                              style: TextStyle(fontFamily: 'Sofia'),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.blue, // Text color
                                    ),
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the alert dialog
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.red, // Text color
                                    ),
                                    child: Text("Logout"),
                                    onPressed: () {
                                      logout();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                        (Route<dynamic> route) =>
                                            false, // This condition matches any route
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(15.0),
                            // ),
                          );
                        },
                      );
                    },
                    child: Category(
                      txt: "Logout     ",
                      image: "assets/images/logout.png",
                      padding: 158.0,
                    ),
                  ),
                ])),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String? txt; // Use final keyword to define instance variables
  final String? image;
  final GestureTapCallback? tap;
  double padding; // Avoid nullable for padding

  Category({this.txt, this.image, this.tap, required this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                if (image != null) // Check if image is not null before using it
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Image.asset(
                      image!,
                      height: 28.0,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    txt ?? "", // Use a default empty string if txt is null
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Sofia",
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                    size: 15.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
