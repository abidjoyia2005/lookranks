import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Bottom.dart';
import '../guider/notification_sender.dart';

class ChatScreen extends StatefulWidget {
  final String SenderUsername;
  var pk_id;

  ChatScreen({required this.SenderUsername, this.pk_id});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Timer? _timer;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _refreshMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the Timer when the widget is disposed
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingMessage = prefs.getString("User${widget.SenderUsername}");

    if (existingMessage != null) {
      List<Map<String, dynamic>> messageList =
          List<Map<String, dynamic>>.from(json.decode(existingMessage));
      setState(() {
        _messages = messageList;
        _isLoading = false;
      });
      _scrollToBottom();
    } else {
      setState(() {
        _messages = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingMessage = prefs.getString("User${widget.SenderUsername}");

    if (existingMessage != null) {
      List<Map<String, dynamic>> newMessageList =
          List<Map<String, dynamic>>.from(json.decode(existingMessage));

      // Check if there are new messages to add
      if (newMessageList.length != _messages.length) {
        setState(() {
          _messages = newMessageList;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                size: 25,
              ),
            ),
            SizedBox(
              width: 3,
            ),
            CircleAvatar(
              radius: 23,
            ),
            SizedBox(
              width: 7,
            ),
            Text(widget.SenderUsername)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(8.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return message['You'] == 'false'
                          ? ReceivedMessageBubble(
                              message: message['message'],
                              time: getTimeAgo(
                                  parseIso8601Timestamp(message['time'])))
                          : SentMessageBubble(
                              message: message['message'],
                              time: message['time']);
                    },
                  ),
          ),
          ChatInputField(pk_Id: widget.pk_id, Username: widget.SenderUsername),
        ],
      ),
    );
  }
}

class SentMessageBubble extends StatelessWidget {
  final String message;
  final String time;

  const SentMessageBubble({
    required this.message,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceivedMessageBubble extends StatelessWidget {
  final String message;
  final String time;

  const ReceivedMessageBubble({
    required this.message,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputField extends StatefulWidget {
  final int pk_Id;
  final String Username;

  ChatInputField({required this.pk_Id, required this.Username});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _messageController = TextEditingController();
  // final String usertoken = 'YOUR_USER_TOKEN'; // Replace with your user token

  Future<void> SendMessage(
      int user, String message, String senderusername) async {
    print(usertoken);
    final response = await http.post(
      Uri.parse("https://lookranks.com/and_api/send/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          "message": message,
          "user": user,
        },
      ),
    );

    if (response.statusCode == 201) {
      addYourMessage(message, senderusername, user, "dfe");
      Debugs("send message :${response.body}");
      Increase_Count_Firebase(senderusername);
      var data = jsonDecode(response.body);
      String FCMTokenFormessage = data["token"];
      await NotificationService.sendNotificationToSelectedDevice(
          ' $UserName Send Message', message, FCMTokenFormessage);
    } else {
      Debugs(response.body);
      Debugs('Failed to load data. Status code: ${response.statusCode}');
    }
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

  Future<void> Increase_Count_Firebase(String username) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('chats').doc(username);

    docRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        int email = data['hasMessages'];
        email = email + 1;
        SaveIncreament(email, username);

        print("User message count: $email");
      } else {
        CreateDocumentFirebase(1, username);
        print("No such document!");
      }
    }).catchError((error) => print("Failed to get user message count: $error"));
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
        .then((value) => print("User Message Count added"))
        .catchError(
            (error) => print("Failed to add user message count: $error"));
  }

  void SaveIncreament(count, String Sendername) async {
    print("User name of 0 count:$Sendername");
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');

    await chatCollection
        .doc(Sendername)
        .set({
          'hasMessages': count,
        })
        .then((value) => print("User Message Count added"))
        .catchError(
            (error) => print("Failed to add user message count: $error"));
  }

  void addYourMessage(
      String message, String Username, int pkid, String Picture) async {
    print("send message is added......to  user  $Username");
    final prefs = await SharedPreferences.getInstance();
    String? existingMessage = prefs.getString("User$Username");
    String? existingInbox = prefs.getString("Inbox");

    List<Map<String, dynamic>> chatList = existingInbox != null
        ? List<Map<String, dynamic>>.from(json.decode(existingInbox))
        : [];
    var currentTime = DateTime.now();
    if (!Exist_User_AddMessage(chatList, Username)) {
      final InboxEntry = {
        'username': Username,
        'message': message,
        'time': currentTime.toString(),
        'Profile_Pic': Picture,
        "pkid": pkid,
      };

      chatList.add(InboxEntry);

      // prefs.setString("Inbox", json.encode(chatList));
      prefs.setString(
          "Inbox", json.encode(arrangeNewMessageFirst(chatList, Username)));
      setState(() {});
    } else {
      final Messages_user = {
        'You': "true",
        'message': message,
        'time': currentTime.toString(),
        //'Profile_Pic':Picture
      };
      List<Map<String, dynamic>> MessageList = existingMessage != null
          ? List<Map<String, dynamic>>.from(json.decode(existingMessage))
          : [];

      MessageList.add(Messages_user);

      prefs.setString("User$Username", json.encode(MessageList));
      prefs.setString(
          "Inbox", json.encode(arrangeNewMessageFirst(chatList, Username)));
      setState(() {});

      print("your store Messages is$MessageList");
    }
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () {
              // Handle photo selection
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final message = _messageController.text;
              if (message.isNotEmpty) {
                SendMessage(widget.pk_Id, message, widget.Username);
                _messageController
                    .clear(); // Clear the text field after sending
              }
            },
          ),
        ],
      ),
    );
  }
}
