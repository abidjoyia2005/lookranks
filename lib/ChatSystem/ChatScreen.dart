import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ChatSystem/Chating_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Bottom.dart';

class Inbox_Screen extends StatefulWidget {
  var Receiver_User;
  var Receiver_Pkid;
  Inbox_Screen({this.Receiver_Pkid, this.Receiver_User});

  @override
  State<Inbox_Screen> createState() => _Inbox_ScreenState();
}

class _Inbox_ScreenState extends State<Inbox_Screen> {
  var APi_called = false;
  Future<List<dynamic>> loadData(count) async {
    try {
      print("count in funcation : $count");
      ;

      final res = await http.get(
        Uri.parse("https://lookranks.com/and_api/messages/?num=$count"),
        headers: <String, String>{
          'Authorization': 'Token $usertoken',
        },
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body) as List<dynamic>;
        var no_message = data.length;
        no_message = no_message + 1;
        saveUserEmail(0);

        Debugs('messages result from server.......\n ${res.body}');

        for (int i = data.length - 1; i > -1; i--) {
          storeInbox(
              data[i]["message_sender_name"],
              data[i]['message'],
              data[i]['sender_pic'] == null ? "null" : data[i]['sender_pic'],
              data[i]['message_time'],
              data[i]['message_sender']);
        }

        return data;
      } else {
        // Handle different HTTP status codes here
        Debugs("API Error: ${res.statusCode}");
        throw Exception("API Error: ${res.statusCode}");
      }
    } catch (e) {
      // Handle exceptions here, such as network errors.
      Debugs("Error in server request: $e");
      throw Exception("Error in server request: $e");
    }
  }

  Future<void> getUserEmail(String username) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('chats').doc(username);

    docRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        int email = data['hasMessages'];
        print("User message count: $email");
        if (email > 0) {
          _timer?.cancel();
          loadData(email);
        }
      } else {
        CreateDocumentFirebase(0, username);
        print("No such document!");
      }
    }).catchError((error) => print("Failed to get user message count: $error"));
  }

  void saveUserEmail(count) async {
    print("User name of 0 count:$UserName");
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');

    await chatCollection
        .doc(UserName)
        .set({
          'hasMessages': count,
        })
        .then((value) => () {
              start_timer();
              print("User Message Count added");
            })
        .catchError(
            (error) => print("Failed to add user message count: $error"));
  }

  void CreateDocumentFirebase(int count, String UserCreate) async {
    print("User name of 0 count:$UserCreate");
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');

    await chatCollection
        .doc(UserCreate)
        .set({
          'hasMessages': count,
        })
        .then((value) => () {
              print("User Message Count added");
            })
        .catchError(
            (error) => print("Failed to add user message count: $error"));
  }

// for store chat in mobile
//  Future<void> storeChat(var userId, var message) async {
//     final prefs = await SharedPreferences.getInstance();
//     String? existingChat = prefs.getString(userId);

//     List<String> chatList = existingChat != null ? List<String>.from(json.decode(existingChat)) : [];
//     chatList.add(message);

//     prefs.setString(userId, json.encode(chatList));
//   }
  Future<void> storeInbox(String username, String message, String Picture,
      String Date, int pkid) async {
    final prefs = await SharedPreferences.getInstance();
    String? existingInbox = prefs.getString("Inbox");

    List<Map<String, dynamic>> chatList = existingInbox != null
        ? List<Map<String, dynamic>>.from(json.decode(existingInbox))
        : [];
    if (Exist_User_AddMessage(chatList, username)) {
      final Messages_user = {
        'You': "false",
        'message': message,
        'time': Date,
        //'Profile_Pic':Picture
      };
      String? existingMessage = prefs.getString("User$username");

      List<Map<String, dynamic>> MessageList = existingMessage != null
          ? List<Map<String, dynamic>>.from(json.decode(existingMessage))
          : [];

      MessageList.add(Messages_user);

      prefs.setString("User$username", json.encode(MessageList));

      prefs.setString(
          "Inbox", json.encode(arrangeNewMessageFirst(chatList, username)));
      //testing new update card design
      // var pervios_unread = FindUnreadMessage(chatList, username);
      // pervios_unread = pervios_unread + 1;

      // final InboxEntryforupdatecarddata = {
      //   'username': username,
      //   'message': message,
      //   'time': Date,
      //   'Profile_Pic': Picture,
      //   "pkid": pkid,
      //   "UnRead": 3,
      // };

      setState(() {});
    } else {
      final InboxEntry = {
        'username': username,
        'message': message,
        'time': Date,
        'Profile_Pic': Picture,
        "pkid": pkid,
        "UnRead": 1
      };

      chatList.add(InboxEntry);

      prefs.setString(
          "Inbox", json.encode(arrangeNewMessageFirst(chatList, username)));
      //add new user first mssage
      final Messages_user = {
        'You': "false",
        'message': message,
        'time': Date,
        //'Profile_Pic':Picture
      };
      String? existingMessage = prefs.getString("User$username");

      List<Map<String, dynamic>> MessageList = existingMessage != null
          ? List<Map<String, dynamic>>.from(json.decode(existingMessage))
          : [];

      // MessageList.add(Messages_user);

      // prefs.setString("User$username", json.encode(MessageList));
      setState(() {});
    }
  }

  int FindUnreadMessage(var chatlist, String name) {
    for (int i = 0; i < chatlist.lenght; i++) {
      if (name == chatlist['i']['username']) {
        int unread = chatlist['i']['UnRead'];
        return unread;
      }
    }
    return 0;
  }

  List<Map<String, dynamic>> arrangeNewMessageFirst(
      List<Map<String, dynamic>> list, String name) {
    // Find the index of the map with the specified username
    int indexToMove = -1;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['username'] == name) {
        indexToMove = i;
        break;
      }
    }
    // If the username was not found, return the original list
    if (indexToMove == -1) {
      return list;
    }

    // Remove the map from its current position
    var newUser = list.removeAt(indexToMove);

    // Insert the map at the beginning of the list
    list.insert(0, newUser);

    return list;
  }

  bool Exist_User_AddMessage(
      List<Map<String, dynamic>> chatList, String Username) {
    for (int i = 0; i < chatList.length; i++) {
      if (Username == chatList[i]["username"]) {
        return true;
      }
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getInbox() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingInbox = prefs.getString("Inbox");
    print("get Inbox called...... $existingInbox");

    if (existingInbox != null) {
      List<Map<String, dynamic>> inboxList =
          List<Map<String, dynamic>>.from(json.decode(existingInbox));
      print("your store inbox data is$inboxList");

      return inboxList;
    } else {
      return [];
    }
  }

  // Retrieve all chat messages for a user
  Future<List<String>> retrieveChat(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    String? existingChat = prefs.getString(userId);

    if (existingChat != null) {
      return List<String>.from(json.decode(existingChat));
    } else {
      return [];
    }
  }

  // Clear all chat messages for a user
  Future<void> clearChat() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('Inbox');
    setState(() {});
  }

  Timer? _timer;
  void navigator_to_chat() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            SenderUsername: widget.Receiver_User,
            pk_id: widget.Receiver_Pkid,
          ),
        ));
  }

  void start_timer() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      getUserEmail(UserName!);
    });
  }

  @override
  void initState() {
    super.initState();
    print("Reciver user name ${widget.Receiver_User}");
    getInbox();
    start_timer();

    if (widget.Receiver_User != null && widget.Receiver_Pkid != null) {
      navigator_to_chat();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Function to parse ISO 8601 timestamp and return DateTime
  DateTime parseIso8601Timestamp(String iso8601String) {
    return DateTime.parse(iso8601String);
  }

// Function to get time ago string
  String getTimeAgo(DateTime messageTime) {
    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inDays >= 1) {
      // More than a day old
      return DateFormat('MMM d, yyyy')
          .format(messageTime); // e.g., Aug 27, 2024
    } else if (difference.inHours >= 1) {
      // More than an hour but less than a day old
      return '${difference.inHours} hours ago'; // e.g., 3 hours ago
    } else if (difference.inMinutes >= 1) {
      // More than a minute but less than an hour old
      return '${difference.inMinutes} minutes ago'; // e.g., 45 minutes ago
    } else {
      // Less than a minute old
      return 'just now'; // e.g., just now
    }
  }

// Alternative function using the timeago package
  String getTimeAgoUsingTimeago(DateTime messageTime) {
    return timeago.format(messageTime,
        locale: 'en_short'); // e.g., "3h", "2m", "yesterday"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('chats'),
        actions: [TextButton(onPressed: () => clearChat, child: Text("clear"))],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getInbox(), // Call the getInbox() function
        builder: (context, snapshot) {
          // Check the state of the Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading spinner
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, show an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If the data is empty, show a message indicating no data
            return Center(child: Text('No messages found'));
          } else {
            // If data is available, display it in a ListView
            List<Map<String, dynamic>> inboxData = snapshot.data!;
            return ListView.builder(
              itemCount: inboxData.length,
              itemBuilder: (context, index) {
                final item = inboxData[index];
                return Inbox_Screen_Card(
                    message: item['message']!,
                    name: item['username']!,
                    picture: item['Profile_Pic']!,
                    pkid: item['pkid']!,
                    // Unread: item['UnRead'],
                    time: getTimeAgoUsingTimeago(
                        parseIso8601Timestamp(item['time'])));
              },
            );
          }
        },
      ),
    );
  }
}

class Inbox_Screen_Card extends StatefulWidget {
  var name;
  var picture;
  var time;
  var message;
  var pkid;
  var Unread;
  Inbox_Screen_Card(
      {required this.message,
      required this.name,
      required this.picture,
      required this.pkid,
      // required this.Unread,
      required this.time});

  @override
  State<Inbox_Screen_Card> createState() => _Inbox_Screen_CardState();
}

class _Inbox_Screen_CardState extends State<Inbox_Screen_Card> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                SenderUsername: widget.name,
                pk_id: widget.pkid,
              ),
            ));
      },
      child: Container(
        height: 90,
        //color: Colors.black26,
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            widget.picture == "dfe"
                ? CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/No_profile_pic.png'),
                    radius: 30,
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.picture),
                  ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.time} ago",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "1", // Number of unread messages
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),

                    // widget.Unread != Null
                    //     ? Text(
                    //         widget.Unread, // Number of unread messages
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           color: Colors.white,
                    //         ),
                    //       )
                    //     : Container()
                  ),
                )
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
