import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as https;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import '../splash.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

bool Stackshow = false;

class Postscreen extends StatefulWidget {
  var btoken;
  var bid;
  Postscreen({ this.btoken,  this.bid});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (userHasProfileImage == false) {
      CheckProfilecomplete();
    }
  }

  Future<void> CheckProfilecomplete() async {
    final response = await https.put(
      Uri.parse("https://lookranks.com/and_api/profile/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {},
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Debugs("check data");

      Debugs(data);

      if (data["dob"] == null ||
          data["gender"] == null ||
          data["country"] == "") {
        setState(() {
          Stackshow = true;
        });
        Debugs("profile not complete");
      }
    } else {
      Debugs("not check");
      var data = jsonDecode(response.body.toString());
      Debugs(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: userHasProfileImage?HasPost():
            ImagePickerWidget());
  }
}

class ImagePickerWidget extends StatefulWidget {
  
 
  @override
  _ImagePickerWidgetState createState() =>
      _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  

  List<File?> selectedImages = [];
  TextEditingController question = TextEditingController();

  bool errorshow = false;
   Future<void> PostActivate() async {
    try {
      final res = await https.get(
        Uri.parse("https://lookranks.com/and_api/activate"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token $usertoken',
        },
      );

      if (res.statusCode == 200) {
        var apiData = jsonDecode(res.body);
        

         Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Bottom(),
        ),
      );
        Debugs(apiData);

        Debugs("activate");
      } else if (res.statusCode == 404) {
        // Handle a 404 error (Not Found) here, e.g., show a not found message to the user.
        Debugs("API Error 404: Resource not found");
      } else if (res.statusCode == 401) {
        // Handle a 401 error (Unauthorized) here, e.g., show a login screen or access denied message.
        Debugs("API Error 401: Unauthorized");
      } else if (res.statusCode == 500) {
        // Handle a 500 error (Internal Server Error) here, e.g., show a generic error message to the user.
        Debugs("API Error 500: Internal Server Error");
      } else {
        // Handle other API errors here, e.g., show a generic error message to the user.
        Debugs("API Error from activate post: ${res.statusCode}");
      }
    } catch (e) {
      // Handle exceptions here, such as network errors.
      Debugs("Error in server request: $e");
    }
  }
  Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Debugs("Password reset email sent. Check your inbox.");
  } catch (e) {
    Debugs("Error sending password reset email: $e");
  }
}


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    @override
    void initState() {
      super.initState();
    }

    if (pickedFile != null) {
      if (selectedImages.length < 3) {
        setState(() {
          selectedImages.add(File(pickedFile.path));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can select a maximum of 3 images.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
              child: Text(
            'No image selected.',
            style: TextStyle(color: Colors.redAccent),
          )),
        ),
      );
    }
  }
      
  bool Photouploaded = false;

  Future<void> _post() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one picture before posting.'),
        ),
      );
    } else if (selectedImages.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only upload a maximum of 3 images.'),
        ),
      );
    } else {
      final progressDialog = ProgressDialog(
        context,
        customBody: Container(
          width: 300,
          height: 350,
          child: Column(
            children: [
              SizedBox(
                height: 3,
              ),
              Text(
                'Creating Post , Please wait',
                style: TextStyle(
                    fontFamily: 'Lemon',
                    fontSize: 12,
                    color: Colors.purple[300]),
              ),
              Image.asset(
                'assets/images/Image upload.gif',
                fit: BoxFit
                    .cover, // Or another BoxFit option that suits your needs
              ),
              CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      );

      progressDialog.show();
      if (Profilepic != null) {}
      // Define your API endpoint URL
      final apiUrl = Uri.parse('https://lookranks.com/and_api/upload_picture/');

      // Create a multipart request
      final request = https.MultipartRequest(
        'POST',
        apiUrl,
      );
      request.headers['Authorization'] = 'Token $usertoken';

      // Add selected images to the request with corresponding field names
      if (selectedImages.length >= 1) {
        request.files.add(
          await https.MultipartFile.fromPath('pic', selectedImages[0]!.path),
        );
      }
      if (selectedImages.length >= 2) {
        request.files.add(
          await https.MultipartFile.fromPath('pic2', selectedImages[1]!.path),
        );
      }
      if (selectedImages.length >= 3) {
        request.files.add(
          await https.MultipartFile.fromPath('pic3', selectedImages[2]!.path),
        );
      }

      // Add other form data if needed
      // request.fields['picuser'] = Name.text;

      try {
        final response = await request.send();
        Debugs(response.stream);
        if (response.statusCode == 200) {
          setState(() {
            userHasProfileImage = true;
          });
          Debugs(response.headers);
          // final prefs = await SharedPreferences.getInstance();
          // prefs.setBool("Photoupload", true);

          SecondUploaddata();
          PostActivate();

          //Request was successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                  child: Text(
                'Saved!',
                style: TextStyle(color: Colors.green),
              )),
            ),
          );
        } else {
          progressDialog.hide();
          Debugs('Error: ${response.statusCode}');
          Debugs(await response.stream.bytesToString());

          // Request failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                  child: Text(
                'Failed to post data. Please try again.',
                style: TextStyle(color: Colors.red),
              )),
            ),
          );
        }
      } catch (e) {
        // progressDialog.hide();

        // An error occurred
        Debugs('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred. Please try again later.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      }
      // finally {
      //   progressDialog.hide();
      // }
    }
  }

  void _requestPermissionAndPickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        _pickImage(source);
      } else {
        Debugs('noo permission ');
      }
    } else if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        _pickImage(source);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permeisndfka'),
          ),
        );
        // Handle denied or restricted permissions
        // You can show a dialog or a snackbar to inform the user.
      }
    }
  }

  // Future<void> _post() async {
  //   if (selectedImages.isEmpty) {
  //     // Show a message indicating no images were selected.
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Please add at least one picture before posting.'),
  //       ),
  //     );
  //     return;
  //   } else if (selectedImages.length > 3) {
  //     // Show a message indicating too many images were selected.
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('You can only upload a maximum of 3 images.'),
  //       ),
  //     );
  //     return;
  //   }

  //   final progressDialog = ProgressDialog(context);
  //   progressDialog.style(
  //     message: 'Uploading...',
  //     progressWidget: CircularProgressIndicator(),
  //   );

  //   progressDialog.show();

  //   // Define your API endpoint URL
  //   final apiUrl = Uri.parse('https://lookranks.com/and_api/upload_picture/');

  //   // Create a multipart request
  //   final request = https.MultipartRequest('POST', apiUrl);
  //   request.headers['Authorization'] = 'Token $btoken';

  //   // Calculate the total file size for progress tracking
  //   double totalFileSize = 0;

  //   for (int i = 0; i < selectedImages.length; i++) {
  //     final image = selectedImages[i];
  //     final fieldName = 'pic${i + 1}';
  //     final file = File(image!.path);

  //     request.files.add(
  //       await https.MultipartFile.fromPath(fieldName, file.path),
  //     );

  //     // Add the file size to the total file size
  //     totalFileSize += await file.length() / (1024 * 1024); // Convert to MB
  //   }

  //   // Track the total upload progress
  //   double totalUploadProgress = 0;

  //   try {
  //     final response = await request.send();

  //     if (response.statusCode == 200) {
  //       // Handle the response as needed
  //       SecondUploaddata();
  //       PostActivate();

  //       // You can display the total upload progress to the user
  //       // Here, I'm updating the totalUploadProgress variable
  //       totalUploadProgress = totalFileSize;

  //       // Note: If you want to display progress bars for individual images,
  //       // you would need to process the response differently here.

  //       // final prefs = await SharedPreferences.getInstance();
  //       // prefs.setBool("Photoupload", true);
  //       Photouploaded = true;

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => WillPopScope(
  //             onWillPop: () async {
  //               return false;
  //               // Handle back button press here if needed.
  //               // Return true to allow popping, or false to prevent it.
  //               // return true;
  //             },
  //             child: Bottom(),
  //           ),
  //         ),
  //       );

  //       progressDialog.hide();

  //       // Request was successful
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Post successful!'),
  //         ),
  //       );
  //     } else {
  //       Debugs('Error: ${response.statusCode}');
  //       Debugs(await response.stream.bytesToString());

  //       // Request failed
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to post data. Please try again.'),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     // An error occurred
  //     Debugs('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('An error occurred. Please try again later.'),
  //       ),
  //     );
  //   } finally {
  //     progressDialog.hide();
  //   }

  //   // You can now use totalUploadProgress to display the total upload progress
  //   Debugs('Total Upload Progress: $totalUploadProgress MB');
  // }

  Future<void> Uploaddata() async {
    final progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Uploading...',
      progressWidget: CircularProgressIndicator(),
    );
    progressDialog.show();

    setState(() {});

    final response = await https.put(
      Uri.parse("https://lookranks.com/and_api/profile/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          'country': _selectedCountry,
          'dob': "$year-$Month-$Date",
          'gender': selectedGender.toLowerCase(),
          'ask_question1': question.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Debugs(data);
      progressDialog.hide();
      if (Photouploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your post is Uploaded'),
          ),
        );
      }

      // Assuming your API returns a token and user ID, retrieve them from the response.

      // Save the token and user ID to shared preferences.
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('usertoken', token);
      // prefs.setInt('user_id', userId);
      // prefs.setBool("isLogin", true);

      // Navigate to the home screen or perform other actions on successful login
    } else if (response.statusCode == 401) {
      // Unauthorized: Invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Invalid email or password. Please try again."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {},
              )
            ],
          );
        },
      );
    } else if (response.statusCode == 500) {
      var data = jsonDecode(response.body.toString());

      // Internal Server Error: Server-side issue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Server Error"),
            content: Text(
                "An internal server error occurred. Please try again later.  respones :$data"),
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
    } else {
      var data = jsonDecode(response.body.toString());
      Debugs(data);

      // Handle other status codes as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text(
                "An error occurred. Please try again later. respons:$data"),
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

  Future<void> SecondUploaddata() async {
    final progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Uploading...',
      progressWidget: CircularProgressIndicator(),
    );
    progressDialog.show();

    setState(() {});

    final response = await https.put(
      Uri.parse("https://lookranks.com/and_api/profile/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          'ask_question1': question.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Debugs(data);
      progressDialog.hide();
      if (Photouploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your post is Uploaded'),
          ),
        );
      }

      // Assuming your API returns a token and user ID, retrieve them from the response.

      // Save the token and user ID to shared preferences.
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('usertoken', token);
      // prefs.setInt('user_id', userId);
      // prefs.setBool("isLogin", true);

      // Navigate to the home screen or perform other actions on successful login
    } else if (response.statusCode == 401) {
      // Unauthorized: Invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Invalid email or password. Please try again."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {},
              )
            ],
          );
        },
      );
    } else if (response.statusCode == 500) {
      var data = jsonDecode(response.body.toString());

      // Internal Server Error: Server-side issue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Server Error"),
            content: Text(
                "An internal server error occurred. Please try again later.  respones :$data"),
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
    } else {
      var data = jsonDecode(response.body.toString());
      Debugs(data);

      // Handle other status codes as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text(
                "An error occurred. Please try again later. respons:$data"),
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

  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var _selectedCountry;
  DateTime? selectedDate;
  var year;
  var Month;
  var Date;
  var CountrysForText = "Your Country";
  List<Map<String, dynamic>> genderOptions = [
    {"name": "Male", "icon": Icons.male},
    {"name": "Female", "icon": Icons.female},
    {"name": "Other", "icon": Icons.transgender}
  ];
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
          year = selectedDate!.year;
          Month = selectedDate!.month;
          Date = selectedDate!.day;
        });
        Debugs("$year-$Month-$Date");
      }
    });
  }

  String selectedGender = 'Male';
//delogi that i am show in stack
  // void _showDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Update Profile"),
  //         content: Container(
  //           height: 380,
  //           child: Column(
  //             children: [
  //               Container(
  //                 decoration: BoxDecoration(
  //                     boxShadow: [
  //                       BoxShadow(
  //                           blurRadius: 10.0,
  //                           color: Colors.black12.withOpacity(0.1)),
  //                     ],
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.all(Radius.circular(40.0))),
  //                 child: Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
  //                     child: Theme(
  //                       data: ThemeData(
  //                         highlightColor: Colors.white,
  //                         hintColor: Colors.white,
  //                       ),
  //                       child: TextFormField(
  //                           validator: (input) {},
  //                           onSaved: (input) => input = input,
  //                           controller: nameController,
  //                           decoration: InputDecoration(
  //                             hintText: "Your Name",
  //                             hintStyle: TextStyle(
  //                                 fontFamily: "Sofia", color: Colors.black),
  //                             enabledBorder: new UnderlineInputBorder(
  //                               borderSide: BorderSide(
  //                                   color: Colors.white,
  //                                   width: 1.0,
  //                                   style: BorderStyle.none),
  //                             ),
  //                           )),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 16.0),
  //               Container(
  //                 width: double.infinity,
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                     boxShadow: [
  //                       BoxShadow(
  //                           blurRadius: 10.0,
  //                           color: Colors.black12.withOpacity(0.1)),
  //                     ],
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.all(Radius.circular(40.0))),
  //                 child: TextButton(
  //                   onPressed: () {
  //                     showCountryPicker(
  //                       context: context,
  //                       onSelect: (Country country) {
  //                         _selectedCountry = country.countryCode;

  //                         CountrysForText = country.name;
  //                         Debugs(_selectedCountry);
  //                         setState(() {});
  //                       },
  //                     );
  //                   },
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         CountrysForText,
  //                         style: TextStyle(
  //                             //fontFamily: "Sofia",
  //                             color: Colors.black,
  //                             fontSize: 16),
  //                       ),
  //                       Spacer(),
  //                       Icon(
  //                         Icons.arrow_drop_down,
  //                         color: Colors.black54,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 16,
  //               ),
  //               Container(
  //                 width: double.infinity,
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                   boxShadow: [
  //                     BoxShadow(
  //                       blurRadius: 10.0,
  //                       color: Colors.black12.withOpacity(0.1),
  //                     ),
  //                   ],
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.all(Radius.circular(40.0)),
  //                 ),
  //                 child: DropdownButtonFormField<String>(
  //                   value: selectedGender,
  //                   decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //                     border: InputBorder.none,
  //                   ),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       selectedGender = value!;
  //                     });
  //                   },
  //                   items: genderOptions.map((gender) {
  //                     return DropdownMenuItem<String>(
  //                       value: gender["name"],
  //                       child: Row(
  //                         children: [
  //                           Icon(gender["icon"]),
  //                           SizedBox(width: 10),
  //                           Text(gender["name"]),
  //                         ],
  //                       ),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //               SizedBox(height: 16.0),
  //               InkWell(
  //                 onTap: () {
  //                   setState(() {});
  //                   _showDatePicker();
  //                   setState(() {});
  //                 },
  //                 child: Container(
  //                   width: double.infinity,
  //                   height: 50,
  //                   decoration: BoxDecoration(
  //                     boxShadow: [
  //                       BoxShadow(
  //                         blurRadius: 10.0,
  //                         color: Colors.black12.withOpacity(0.1),
  //                       ),
  //                     ],
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.all(Radius.circular(40.0)),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       selectedDate == null
  //                           ? "Date of Birth"
  //                           : "${selectedDate!.toLocal()}"
  //                               .split(' ')[0], // Display selected date
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 30.0),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Uploaddata();
  //                 },
  //                 child: Container(
  //                   height: 52.0,
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(80.0),
  //                     gradient: LinearGradient(
  //                       colors: [
  //                         Color(0xFFFEE140),
  //                         Color(0xFFFF942F),
  //                       ],
  //                     ),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       "Update",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 17.0,
  //                         fontWeight: FontWeight.w700,
  //                         fontFamily: "Sofia",
  //                         letterSpacing: 0.9,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 20,
        // title: Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(children: [
              Scrollbar(
                thickness: 3.0,
                radius: Radius.circular(25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Stack(
                    children: [
                      Row(
                        children: <Widget>[
                          if (selectedImages.length < 3)
                            InkWell(
                              onTap: () {
                                if (selectedImages.length < 3) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SafeArea(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Container(
                                                height: 4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                        boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          spreadRadius: 4, // Spread radius
                          blurRadius: 8, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.lightBlue,
                                                        Color.fromARGB(
                                                            255, 78, 160, 198)
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: ListTile(
                                                  leading:
                                                      Icon(Icons.photo_library),
                                                  title: Text(
                                                    'Pick from Gallery',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                               onTap: () async {
                                                    Navigator.pop(context);
                                                    AndroidDeviceInfo build=await DeviceInfoPlugin().androidInfo;
                                                    if(build.version.sdkInt>=30){
                                                      var re=await Permission.photos.request();
                                                       if (re.isGranted) {
                                                      _pickImage(
                                                          ImageSource.gallery);
                                                    } else if(re.isPermanentlyDenied) {
                                                       ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Permission is Required!'),
                                                        ),
                                                      );
                                                      openAppSettings();
                                                    }else{
                                                       ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                             "Permission is Denied!", style: TextStyle(color: Colors.redAccent)),
                                                        ),
                                                      );
                                                    }
                                                    }else{
                                                      final status =
                                                        await Permission.storage
                                                            .request();
                                                    if (status.isGranted) {
                                                      _pickImage(
                                                          ImageSource.gallery);
                                                    } else if(status.isPermanentlyDenied) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Permission is Required!'),
                                                        ),
                                                      );
                                                      openAppSettings();
                                                    }else{
                                                       ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                             "Permission is Denied!", style: TextStyle(color: Colors.redAccent)),
                                                        ),
                                                      );
                                                    }

                                                    }
                                                    
                                                    

                                                    // _pickImage(
                                                    //     ImageSource.gallery);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              child: Text(
                                                "OR",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontFamily: 'Lemon'),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          spreadRadius: 4, // Spread radius
                          blurRadius: 8, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(255, 188,
                                                            54, 0.737),
                                                        Color(0xFFFF942F),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: ListTile(
                                                  leading:
                                                      Icon(Icons.camera_alt),
                                                  title: Text(
                                                    'Take a Photo',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                    onTap: () async {
                                                    Navigator.pop(context);
                                                    final status =
                                                        await Permission.camera
                                                            .request();
                                                    if (status.isGranted) {
                                                      _pickImage(
                                                          ImageSource.camera);
                                                    } else if(status.isPermanentlyDenied){
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Permission is Required!'),
                                                        ),
                                                      );
                                                      openAppSettings();
                                                      
                                                      // Handle denied or restricted permissions
                                                      // You can show a dialog or a snackbar to inform the user.
                                                    }
                                                    else{
                                                       ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                             "Permission is Denied!", style: TextStyle(color: Colors.redAccent)),
                                                        ),
                                                      );
                                                    }

                                                    // _pickImage(
                                                    //     ImageSource.camera);
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You have already selected 3 images.'),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  if (selectedImages.length == 0)
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            child: Image.asset(
                                                'assets/images/No_profile_pic.png')),
                                        Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Icon(
                                                  Icons
                                                      .add_photo_alternate_rounded,
                                                  color:
                                                      Colors.deepPurple[500]),
                                              Text(
                                                'Add Image',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.deepPurple),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (selectedImages.length > 0 ||
                                      selectedImages.length == null)
                                     Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            child: Image.asset(
                                                'assets/images/empty.jpeg')),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            children: [
                                              Icon(Icons.add_to_photos_rounded,
                                                  color: Colors.deepPurple, size: 40),
                                              Text(
                                                'Add More(Optional)',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.deepPurple, fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          for (int i = 0; i < selectedImages.length; i++)
                            Container(
                              width: 220,
                              height: 290,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black12, width: 1),
                              ),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  selectedImages[
                                              selectedImages.length - i - 1] !=
                                          null
                                      ? Image.file(selectedImages[
                                          selectedImages.length - i - 1]!)
                                      : Icon(Icons.camera_alt, size: 50),
                                  Positioned(
                                      bottom: 5,
                                      left: 10,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedImages.removeAt(
                                                selectedImages.length - i - 1);
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 22,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                      bottom: 5,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SafeArea(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      child: Container(
                                                        height: 4,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Colors
                                                                        .lightBlue,
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        98,
                                                                        133,
                                                                        149)
                                                                  ],
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                        child: ListTile(
                                                          leading: Icon(Icons
                                                              .photo_library),
                                                          title: Text(
                                                              'Pick from Gallery'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            _pickImage(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      child: Text("OR"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xFFFEE140),
                                                                    Color(
                                                                        0xFFFF942F),
                                                                  ],
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                        child: ListTile(
                                                          leading: Icon(
                                                              Icons.camera_alt),
                                                          title: Text(
                                                              'Take a Photo'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            _pickImage(
                                                                ImageSource
                                                                    .camera);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 22,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                            "Please Note   ",
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
                            "Post one or more of your pictures and ask our community about your look. Your first picture will be set as the profile picture.",
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: Colors.deepPurple[200],
              //         borderRadius: BorderRadius.all(Radius.circular(20))),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           "Notice : upload your first picture close to your face because it is use as a profile picture and Type your Question below about about your pictures.",
              //           style: TextStyle(
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.black12.withOpacity(0.1)),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.white,
                          hintColor: Colors.white,
                        ),
                        child: TextFormField(
                            validator: (input) {},
                            onSaved: (input) => input = input,
                            controller: question,
                            decoration: InputDecoration(
                              hintText: "Ask any Question? (Optional)",
                              hintStyle: TextStyle(
                                  fontFamily: "Sofia", color: Colors.black),
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.9,
                    decoration: BoxDecoration(
                            boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 223, 40),
                            Color(0xFFFF942F),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: InkWell(
                        onTap: () {
                          
                          if (selectedImages.length > 0) {
                            // posting = true;
                            setState(() {});
                          }
                          if (!Stackshow) {
                            _post();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    'before post you need to update profile.',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                            );
                          }

                          // _showDialog("Abiodsf");
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              " Post",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Sofia",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            )))),
              ),
              SizedBox(
                height: 80,
              )
            ]),
            if (Stackshow) // here  is dilog
              AlertDialog(
                elevation: 30.0,
                shadowColor: Colors.grey,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Update Your Profile",
                      style: TextStyle(fontFamily: 'Safio', fontSize: 15),
                    ),
                  ],
                ),
                content: Container(
                  height: 525,
                  width: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset('assets/images/Udateprofile.png'),
                        if (errorshow)
                          Column(
                            children: [
                              Text(
                                "Please select your Country,",
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 13),
                              ),
                              Text(
                                "Gender, and Date of Birth",
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 13),
                              ),
                            ],
                          ),
                        SizedBox(height: 12.0),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10.0,
                                    color: Colors.black12.withOpacity(0.1)),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: TextButton(
                            onPressed: () {
                              showCountryPicker(
                                context: context,
                                onSelect: (Country country) {
                                  _selectedCountry =
                                      country.countryCode; //for api post

                                  CountrysForText = country.name;
                                  Debugs(_selectedCountry);
                                  setState(() {});
                                },
                              );
                            },
                            child: Row(
                              children: [
                                if (_selectedCountry != null)
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      "assets/images/flags/${_selectedCountry.toLowerCase()}.png",
                                    ),
                                  ),
                                Text(
                                  CountrysForText.length >= 19
                                      ? CountrysForText.substring(0, 15)
                                      : CountrysForText,
                                  style: TextStyle(
                                    //fontFamily: "Sofia",
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.0,
                                color: Colors.black12.withOpacity(0.1),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                            items: genderOptions.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender["name"],
                                child: Row(
                                  children: [
                                    Icon(gender["icon"]),
                                    SizedBox(width: 10),
                                    Text(gender["name"]),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        InkWell(
                          onTap: () {
                            _showDatePicker();
                            setState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  color: Colors.black12.withOpacity(0.1),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            child: Center(
                              child: Text(
                                selectedDate == null
                                    ? "Date of Birth"
                                    : "${selectedDate!.toLocal()}"
                                        .split(' ')[0], // Display selected date
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedDate == null ||
                                _selectedCountry == null) {
                              setState(() {
                                errorshow = true;
                              });
                            } else {
                              Uploaddata();
                              setState(() {
                                Stackshow = false;
                                errorshow = false;
                              });
                            }
                          },
                          child: Container(
                            height: 45.0,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFEE140),
                                  Color(0xFFFF942F),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Sofia",
                                  letterSpacing: 0.9,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HasPost extends StatefulWidget {
  const HasPost({super.key});

  @override
  State<HasPost> createState() => _HasPostState();
}

class _HasPostState extends State<HasPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.yellow[700]),
        centerTitle: true,
        title: Text("Create Post"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset('assets/images/choose.png'),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'One Post',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 17, right: 17, bottom: 15, top: 10),
            child: Text(
              '    You already have a post. If you want to add another picture or question, you need to remove your previous post because each account is allowed only one post at a time.',
              style: TextStyle(
                  letterSpacing: 0.3,
                  fontSize: 14,
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.w400),
            ),
          ),
          // InkWell(
          //   splashColor: Colors.white,
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Postscreen(),
          //         ));
          //   },
          //   child: AnimatedContainer(
          //     height: 52,
          //     duration: Duration(milliseconds: 300),
          //     width: 260,
          //     decoration: BoxDecoration(
          //       border: Border.all(
          //         color: Colors.transparent,
          //       ),
          //       borderRadius: BorderRadius.circular(80.0),
          //       gradient: LinearGradient(
          //         colors: [
          //           Colors.blue,
          //           Colors.blueAccent,
          //         ],
          //       ),
          //     ),
          //     alignment: Alignment.center,
          //     child: Text(
          //       "Remove Post",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 17.0,
          //         fontWeight: FontWeight.w700,
          //         fontFamily: "Sofia",
          //         letterSpacing: 0.9,
          //       ),
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
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
        ],
      ),
    );
  }
}



class CustomLoadingIndicator {
  late OverlayEntry overlayEntry;

  void show(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.5,
        left: MediaQuery.of(context).size.width * 0.5,
        child: Container(
          width: 300,
          height: 350,
          child: Column(
            children: [
              SizedBox(height: 3),
              Text(
                'Creating Post, Please wait',
                style: TextStyle(
                  fontFamily: 'Lemon',
                  fontSize: 12,
                  color: Colors.purple[300],
                ),
              ),
              Image.asset(
                'assets/images/Image upload.gif',
                fit: BoxFit.cover,
              ),
              CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  void dismiss() {
    overlayEntry.remove();
  }
}

