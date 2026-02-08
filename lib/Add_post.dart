import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../splash.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';

bool Stackshow = false;

class Postscreen extends StatefulWidget {
  var btoken;
  var bid;
  Postscreen({required this.btoken, required this.bid});

  @override
  State<Postscreen> createState() => _PostscreenState(btoken: btoken, bid: bid);
}

class _PostscreenState extends State<Postscreen> {
  var btoken;
  var bid;
  _PostscreenState({required this.btoken, required this.bid});
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
        'Authorization': 'Token $btoken',
      },
      body: jsonEncode(
        {},
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Debugs("check data");

     // Debugs(data);

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
     // Debugs(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: userHasProfileImage
            ? DetailPost()
            : ImagePickerWidget(btoken: btoken, bid: bid));
  }
}

class ImagePickerWidget extends StatefulWidget {
  var btoken;
  var bid;
  ImagePickerWidget({required this.btoken, required this.bid});
  @override
  _ImagePickerWidgetState createState() =>
      _ImagePickerWidgetState(btoken: btoken, bid: bid);
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  var btoken;
  var bid;
  _ImagePickerWidgetState({required this.btoken, required this.bid});
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
         setState(() {
            userHasProfileImage = true;
          });
        

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
      request.headers['Authorization'] = 'Token $btoken';

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
         
         // Debugs(response.headers);
          // final prefs = await SharedPreferences.getInstance();
          // prefs.setBool("Photoupload", true);

          SecondUploaddata();
          PostActivate();

          //Request was successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                  child: Text(
                'Post Created!',
                style: TextStyle(color: Colors.green),
              )),
            ),
          );
        } else {
          progressDialog.hide();
          //Debugs('Error: ${response.statusCode}');
          //Debugs(await response.stream.bytesToString());

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
        //Debugs('Error: $e');
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
        'Authorization': 'Token $btoken',
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
     // Debugs(data);
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
     // Debugs(data);

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
        'Authorization': 'Token $btoken',
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
      //Debugs(data);

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
                                                              'Camera Permission is Required!'),
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

class DetailPost extends StatefulWidget {
  const DetailPost({Key? key}) : super(key: key);

  @override
  State<DetailPost> createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  late Future<void> apiDataFuture;
  List<dynamic> images = ["skjbdkbekfdb", "ndkaefdewn"];
  List<dynamic>? comentlist;

  @override
  void initState() {
    super.initState();
    apiDataFuture = DetailAccount();
  }

  var apiData;
  var questions;


  Future<void> Questions() async {
    final res = await https.get(
      Uri.parse("https://lookranks.com/and_api/get_answer/$UserName"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        // 'Authorization': 'Token $usertoken'
      },
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      Debugs("questions data.......");
      Debugs(jsonData['answers']);
      setState(() {
       questions=jsonData['answers'];
       qesloading=false;
      });
    } else {
      Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }
    Future<void> DetailAccount() async {
    final res = await https.get(
      Uri.parse("https://lookranks.com/and_api/detail/$UserName"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken'
      },
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      Debugs(jsonData);
      setState(() {
        apiData = jsonData;
        images = jsonData["pic_urls"];
        comentlist = jsonData["comment_list"];
      });
    } else {
        final prefs = await SharedPreferences
                                              .getInstance();

      showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Delete Post",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 290,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 10, 0),
                                                        child: Text(
                                                          " Check your internet connection or restart App this should solve the issue. If not, something might have gone wrong, and you may need to delete your post",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .red[300],
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 20, 20, 0),
                                                        child: Text(
                                                          "Are you sure you want to Delete your post?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the alert dialog
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                        onPressed: () {

                                                          prefs.setString(
                                                              "profilepicture",
                                                              "null");
                                                          DeleteAccount();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
      Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }

  Future<void> DeleteAccount() async {
    final progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Deleting Post...',
      progressWidget: CircularProgressIndicator(),
    );
    progressDialog.show;
    final res = await https.post(
      Uri.parse("https://lookranks.com/and_api/deactivate_account/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        userHasProfileImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Your post has been deleted.',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Bottom(),
        ),
      );

      Debugs("delete");
      Debugs(res.body);
    } else {
      Debugs('Failed to load data. Status code: ${res.statusCode}');
    }
  }
   bool QA =false;
   bool qesloading=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        automaticallyImplyLeading: false,
        // title: Text("Your Post"),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: apiDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SHimer();
          } else if (snapshot.hasError) {
            return Center(
      child: Container(
        // You can adjust the width and height as needed
        // width: 200,
        // height: 200,
        child: Image.asset("assets/images/404Eror.png"),
      ));
          } else if (apiData == null) {
            return Column(
              children: [
                Image.asset('assets/images/NoPost.png'),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  images.length >= 0
                      ? CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 13 / 14,
                          ),
                          items: images.map((imageUrls) {
                            return Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Image.network(imageUrls,
                                          fit: BoxFit.cover),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 16,
                                              height: 16,
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/images/logo.png"),
                                              )),
                                          Stack(
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 15,
                                                color: Colors.white54,
                                              ),
                                              Text("LookRanks",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "Sofia",
                                                      fontWeight:
                                                          FontWeight.w800)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "@",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors
                                                  .redAccent, // Set the text color to black (you can use any color you prefer)
                                              backgroundColor: Colors.white54,
                                            ),
                                          ),
                                          Text(
                                            "$UserName",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors
                                                  .black, // Set the text color to black (you can use any color you prefer)
                                              backgroundColor: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      RatingBarIndicator(
                                        rating:
                                            apiData['star_rating'].toDouble(),
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        unratedColor: Colors.grey[400],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CircularProgressWithPercentage(
                                              percentage: apiData["Grade_per"],
                                              color: Colors.red,
                                              progressicon:
                                                  Icons.local_activity_rounded,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            CircularProgressWithPercentage(
                                              color: Colors.blue,
                                              progressicon:
                                                  Icons.bar_chart_rounded,
                                              percentage: apiData["rating_per"],
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            CircularProgressWithPercentage(
                                              color: Colors.green,
                                              progressicon: Icons.radar_sharp,
                                              percentage: apiData["view_per"],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            );
                          }).toList(),
                        )
                      :
                      // if ({apiData["pic_urls"]}.length == 1)
                      Stack(
                          children: [
                            Container(
                              height: 300,
                              width: double.infinity,
                              child: Image.network(
                                images.first,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ],
                        ),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Colors.deepPurple[200],
                  //         borderRadius: BorderRadius.all(Radius.circular(20))),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Column(
                  //         children: [
                  //           Text(
                  //             "Ratings and Suggestions",
                  //             style: TextStyle(
                  //                 fontFamily: "Sofia",
                  //                 fontSize: 18,
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.w600),
                  //           ),
                  //           Padding(
                  //             padding:
                  //                 const EdgeInsets.only(left: 15, right: 15),
                  //             child: Text(
                  //               "${comentlist!.length} peoples Rate your picture. If you'd like to have more people rate your picture, you need to rate other people's pictures as well. if you rate more people's posts, more people rate your post",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(20)),
                  //       color: Colors.purple[50],
                  //       border: Border.all(
                  //           width: 1.5, color: Colors.deepPurple[400]!),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(12.0),
                  //       child: Column(
                  //         children: [
                  //           Center(
                  //             child: Text(
                  //               "Ratings and Suggestions",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 // letterSpacing: 1.2,
                  //                 fontFamily: "Sans",
                  //               ),
                  //             ),
                  //           ),
                  //           if (comentlist!.length > 1)
                  //             Text(
                  //               "${comentlist?.length ?? 0} people Rate your picture.If you want more ratings, rate other people posts. This way, your post will reach a larger audience and receive more ratings.",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.7,
                  //                 fontFamily: "Sans",
                  //               ),
                  //             ),
                  //           if (comentlist!.length < 2)
                  //             Text(
                  //               "${comentlist?.length ?? 0} person Rate your picture.If you want more ratings, rate other people posts. This way, your post will reach a larger audience and receive more ratings.",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.7,
                  //                 fontFamily: "Sans",
                  //               ),
                  //             ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                    InkWell(
                      onTap: ()async{
                         final prefs = await SharedPreferences
                                              .getInstance();

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Delete Post",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 180,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 10, 0),
                                                        child: Text(
                                                          "Note: Removing your post will result in the loss of your rank and post details.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .red[300],
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 20, 20, 0),
                                                        child: Text(
                                                          "Are you sure you want to Delete your post?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the alert dialog
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                        onPressed: () {
                                                          prefs.setString(
                                                              "profilepicture",
                                                              "null");
                                                          DeleteAccount();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                      },
                      child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(0, 3), // Offset in x and y
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.redAccent),
                          Text(" Delete", style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                    ),
                    SizedBox(width: 10,),
                  InkWell(
                    onTap: (){
                      showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Add Post",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 175,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Note: You can have only one post.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .blue,
                                                              fontSize: 17),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "You already have a post. To create a new one, you must remove the previous one.",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              letterSpacing: 1,
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        // Text(
                                                        //   "You can have only one post.",
                                                        //   style: TextStyle(
                                                        //       color: Colors.red,
                                                        //       fontSize: 15,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w600,
                                                        //       letterSpacing: 1,
                                                        //       fontFamily:
                                                        //           'Sofia'),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                    },
                    child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outlined, color: Colors.blue),
                        Text(" Add", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                  ),
                    SizedBox(width: 10,),
                   InkWell(
                    onTap: (){
                      showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Help",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  height: 258,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8,0, 0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "${comentlist!.length} peoples Rate your picture.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Sofia',
                                                              color: Colors
                                                                  .amber[900],
                                                              fontSize: 17),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "  If you'd like to have more people rate your picture, you need to rate other people's pictures as well. if you rate more people's posts, Your post shows more audience.",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              letterSpacing: 1,
                                                              fontFamily:
                                                                  'Sofia'),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        // Text(
                                                        //   "You can have only one post.",
                                                        //   style: TextStyle(
                                                        //       color: Colors.red,
                                                        //       fontSize: 15,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w600,
                                                        //       letterSpacing: 1,
                                                        //       fontFamily:
                                                        //           'Sofia'),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                    },
                     child: Container(
                     height: 40,
                     width: 100,
                     decoration: BoxDecoration(
                       color: Colors.grey[300],
                       borderRadius: BorderRadius.all(Radius.circular(50)),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.2), // Shadow color
                           spreadRadius: 2, // Spread radius
                           blurRadius: 5, // Blur radius
                           offset: Offset(0, 3), // Offset in x and y
                         ),
                       ],
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.help, color: Colors.amber[900]),
                         Text(" Help", style: TextStyle(color: Colors.amber[900])),
                       ],
                     ),
                   ),
                   )

                  ],),
                  Container(height: 15,),
                apiData["ask_question1"]!='null'?
                 Row(
                  children: [
                    
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        setState(() {
                           QA=false;
                        });
                       
                       
                      },
                      child: AnimatedContainer(
                          duration:Duration(seconds: 2) ,
                        decoration: BoxDecoration( 
                          color: Colors.white70,
                            boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                          border: Border.all(
                            width:QA? 0:2,
    color:QA ?Colors.grey[400]!:Colors.deepPurple[300]! , // Set the border color to black
  ),borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,8,8,0),
                          child: Column(
                            children: [
                              
                              Text("Rating & Comment", style: TextStyle(fontSize: 14, color: QA?Colors.grey[600]:Colors.deepPurple[300])),
                              SizedBox(height: 3,),
                              AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height: 5, 
                                width: QA?30:120,
                                decoration: BoxDecoration(color:QA?Colors.grey[400]:Colors.deepPurple[300], borderRadius: BorderRadius.all(Radius.circular(50))),
                              ), 
                              
                                            
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                   
                    InkWell(
                      onTap: ()async{
                        Questions();
                        setState(() {
                          QA=true; 
                        });
                      },
                      child: AnimatedContainer(
                        duration:Duration(seconds: 2) ,
                        decoration: BoxDecoration( 
                          color: Colors.white70,
                            boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 6, // Blur radius
                          offset: Offset(0, 3), // Offset in x and y
                        ),
                      ],
                          border: Border.all(
                            width:QA? 2:0,
    color:QA ?Colors.deepPurple[300]!: Colors.grey[400]!, // Set the border color to black
  ),borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,8,8,0),
                          child: Column(
                            children: [
                              Text("Question & Answer",style: TextStyle(fontSize: 14, color: QA?Colors.deepPurple[300]:Colors.grey[600])),
                              SizedBox(height: 3,),
                               AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height: 5, 
                                width: QA?130:30,
                                decoration: BoxDecoration(color:QA?Colors.deepPurple[300]:Colors.grey[400], borderRadius: BorderRadius.all(Radius.circular(50))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                  
                 ):
                
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: (){
                        setState(() {
                           QA=false;
                        });
                       
                       
                      },
                      child: Column(

                        children: [
                         
                          Text("Rating & Coment", style: TextStyle(fontSize: 18, color: QA?Colors.grey[600]:Colors.deepPurple[300],fontWeight: FontWeight.w500)),
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 5, 
                            width: QA?30:130,
                            decoration: BoxDecoration(color:QA?Colors.grey[400]:Colors.deepPurple[300], borderRadius: BorderRadius.all(Radius.circular(50))),
                          ), 
                          
                    
                        ],
                      ),
                    ),
                   
                 
                  ],
                 ),

               if(!QA)
                   if (comentlist!.length != 0)
                    for (int i = 0; i < comentlist!.length; i++)
                      UserReviewWidget(
                        Userpic: comentlist?[i]['userpic'],
                        comment: comentlist![i]['comment'],
                        date: comentlist![i]['timestamp'],
                        rating: comentlist![i]['rating'],
                        userName: comentlist![i]['commented_by'],
                      )
                  else
                      Stack(
                          alignment: Alignment.center,
                           children: [
                              Image.asset(
                            'assets/images/Messaging (1).gif'),
                                                   Positioned(
                                                    top: 80,
                                                     child: Text(
                                                                               "No Rating Found",
                                                                               style: TextStyle(
                                                                                   fontSize: 15,
                                                                                   fontWeight: FontWeight.w800,
                                                                                   color: Colors.blueGrey,
                                                                                   fontFamily: 'Poppins'),
                                                     ),
                                                   ),
                                           ],
                         ),
                    if(QA)
                    !qesloading?Column(
                      children: [

                        if(questions.length<-1 ||questions.length==0|| apiData["ask_question1"]==null)
                        apiData["ask_question1"]==null?
                        Column(
                      children: [
                        
                         Column(
                          //alignment: Alignment.center,
                           children: [
                            SizedBox(height: 40,),
                             
                                                   Text(
                                                                             "You do not ask any questions",
                                                                             style: TextStyle(
                                                                                 fontSize: 15,
                                                                                 fontWeight: FontWeight.w800,
                                                                                 color: Colors.blueGrey,
                                                                                 fontFamily: 'Poppins'),
                                                   ),
                                                    Image.asset(
                            'assets/images/3.png'),
                                           ],
                         ),
                       
                      ],
                    ):Column(
                      children: [
                        
                         Stack(
                          alignment: Alignment.center,
                           children: [
                              Image.asset(
                            'assets/images/Messaging (1).gif'),
                                                   Positioned(
                                                    top: 80,
                                                     child: Text(
                                                                               "No Question & Answer founded",
                                                                               style: TextStyle(
                                                                                   fontSize: 15,
                                                                                   fontWeight: FontWeight.w800,
                                                                                   color: Colors.blueGrey,
                                                                                   fontFamily: 'Poppins'),
                                                     ),
                                                   ),
                                           ],
                         ),
                       
                      ],
                    ),
                        for(int i=0;i<questions.length;i++)
                        if(images!= null && questions[i]['answer1']!=null && questions[i]['submitted_by']['name']!=null &&questions[i]['submitted_by']['pic']!=null )
                        CommentReplyCard(name: questions[i]['submitted_by']['name'],
                        pic:questions[i]['submitted_by']['pic'],
                        ans: questions[i]['answer1'],
                        img:images,
                        ques:apiData["ask_question1"],
                       // longpressname:widget.Longpressusername,
                        
                        )
                        
                      ],
                    ):tenreplaycard(),
                
                  SizedBox(
                    height: 65,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CommentReplyCard extends StatelessWidget {
  var name;
  var pic;
  var ans;
  var img;
  var ques;
  CommentReplyCard({this.name,this.pic,this.ans,this.img, this.ques});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                          CircleAvatar(
  radius: 20,
  backgroundImage:  CachedNetworkImageProvider(img.first),
),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                               UserName!.length >= 22
                                ? '${name.substring(0, 19)}...'
                                : UserName!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                               "  Creator",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500,color:Colors.green),
                            ),
                          ],
                        ),
                        Text(
                          ques,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Reply Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30,),
                      CircleAvatar(
  radius: 20,
  backgroundImage: CachedNetworkImageProvider(pic),
),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                               name.length >= 22
                            ? '${name.substring(0, 19)}...'
                            : name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ans,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Reply Metadata (e.g., time)
                  SizedBox(height: 8),
                  // Text(
                  //   "2 hours ago",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class UserReviewWidget extends StatelessWidget {
  //var data;
  final String userName;
  final double rating;
  final String comment;
  final String date;
  String Userpic;

  UserReviewWidget(
      {required this.userName,
      required this.rating,
      required this.comment,
      required this.date,
      required this.Userpic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Userpic == "null"
                    ? CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            AssetImage("assets/images/No_profile_pic.png"),
                      )
                    : CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(Userpic),
                      ),
                SizedBox(width: 8.0),
                Text(
                  userName.length >= 22
                            ? '${userName.substring(0, 19)}...'
                            : userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  unratedColor: Colors.grey[400],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(80,0,0,0),
              child: Text(
                comment,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressWithPercentage extends StatelessWidget {
  final int percentage;
  var color;
  var progressicon;

  CircularProgressWithPercentage(
      {required this.percentage,
      required this.color,
      required this.progressicon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 3.5,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Icon(
              progressicon,
              size: 26,
              color: Colors.grey[400],
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class tenreplaycard extends StatefulWidget {
  const tenreplaycard({super.key});

  @override
  State<tenreplaycard> createState() => _tenreplaycardState();
}

class _tenreplaycardState extends State<tenreplaycard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
        ReplayCardShimmer(),
      ],
    );
  }
}
class ReplayCardShimmer extends StatelessWidget {

 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                    child:CircleAvatar(
                    radius: 20,
                    
                  ),
                  ),
                  
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        child: Container( width: 100, height: 10 ,color: Colors.grey,) ,
                      ),
                    SizedBox(height: 8,),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                        child: Container( width: 180, height: 10,color: Colors.grey) ,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Reply Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30,),
                       Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                    child:CircleAvatar(
                    radius: 20,
                    
                  ),
                  ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        child: Container( width: 100, height: 10 ,color: Colors.grey,) ,
                      ),
                    SizedBox(height: 8,),
                    Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                        child: Container( width: 180, height: 10,color: Colors.grey) ,
                      ),
                        ],
                      ),
                    ],
                  ),
                  // Reply Metadata (e.g., time)
                  SizedBox(height: 8),
                  // Text(
                  //   "2 hours ago",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SHimer extends StatelessWidget {
  const SHimer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                  child: Container(
                    color: Colors.grey[300],
                    height: 315,
                    width: 36,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!),
              SizedBox(
                width: 4,
              ),
              Container(
                height: 395,
                width: 280,
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    Container(
                      child: Positioned(
                          bottom: 90,
                          left: 20,
                          child: Shimmer.fromColors(
                              child: Container(
                                color: Colors.red,
                                height: 11,
                                width: 80,
                              ),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!)),
                    ),
                    Positioned(
                        bottom: 72,
                        left: 20,
                        child: Shimmer.fromColors(
                            child: Container(
                              color: Colors.grey[300],
                              height: 11,
                              width: 90,
                            ),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!)),
                    Positioned(
                      bottom: 47,
                      left: 10,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: RatingBarIndicator(
                          rating: 0.0, // Use a dummy rating value
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          unratedColor: Colors.grey[400],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                              child: Icon(Icons.circle_outlined, size: 48),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          Shimmer.fromColors(
                              child: Icon(Icons.circle_outlined, size: 48),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          Shimmer.fromColors(
                              child: Icon(Icons.circle_outlined, size: 48),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          SizedBox(
                            width: 60,
                          ),
                          Shimmer.fromColors(
                              child: Icon(Icons.add_circle_outline_outlined,
                                  size: 30),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                          SizedBox(
                            width: 10,
                          ),
                          Shimmer.fromColors(
                              child: Icon(
                                Icons.delete,
                                size: 30,
                              ),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              Shimmer.fromColors(
                  child: Container(
                    color: Colors.grey[300],
                    height: 315,
                    width: 36,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                 baseColor:  Colors.grey[300]! ,
                         highlightColor: Colors.grey[100] !,
                         child: Container(height: 40, 
                         width: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.grey),
                         ),
              ),
              SizedBox(width: 10,),
               Shimmer.fromColors(
                 baseColor:  Colors.grey[300]! ,
                         highlightColor: Colors.grey[100] !,
                         child: Container(height: 40, 
                         width: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.grey),
                         ),
              ),
              SizedBox(width: 10,), Shimmer.fromColors(
                 baseColor:  Colors.grey[300]! ,
                         highlightColor: Colors.grey[100] !,
                         child: Container(height: 40, 
                         width: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.grey),
                         ),
              ),
              

          ]),
          SizedBox(height: 10,),
          
             Row(
             children: [
                 SizedBox(width: 10,),
                   Shimmer.fromColors(
                     baseColor:  Colors.grey[300]! ,
                             highlightColor: Colors.grey[100] !,
                     child: Container(
                       
                          decoration: BoxDecoration( 
                         
                           
                            border: Border.all(
                              width: 2,
                       //color:QA ?Colors.deepPurple[300]!: Colors.grey[400]!, // Set the border color to black
                     ),borderRadius: BorderRadius.all(Radius.circular(30))),
                       child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                         child: Column(
                           children: [
                             Shimmer.fromColors(
                               baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: Text(
                                 
                                 "Rating & Comment",
                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                               ),
                             ),
                             SizedBox(height: 3),
                             Shimmer.fromColors(
                                baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: AnimatedContainer(
                                 duration: Duration(seconds: 1),
                                 height: 5,
                                 width: 130,
                                 decoration: BoxDecoration(
                                   color: Colors.grey[400] ,
                                   borderRadius: BorderRadius.all(Radius.circular(50)),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                   Spacer(),
                  Shimmer.fromColors(
                     baseColor:  Colors.grey[300]! ,
                             highlightColor: Colors.grey[100] !,
                     child: Container(
                       
                          decoration: BoxDecoration( 
                         
                           
                            border: Border.all(
                              width: 2,
                       //color:QA ?Colors.deepPurple[300]!: Colors.grey[400]!, // Set the border color to black
                     ),borderRadius: BorderRadius.all(Radius.circular(30))),
                       child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                         child: Column(
                           children: [
                             Shimmer.fromColors(
                               baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: Text(
                                 
                                 "Question & Answer",
                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                               ),
                             ),
                             SizedBox(height: 3),
                             Shimmer.fromColors(
                                baseColor:  Colors.grey[300]! ,
                               highlightColor: Colors.grey[100] !,
                               child: AnimatedContainer(
                                 duration: Duration(seconds: 1),
                                 height: 5,
                                 width: 30,
                                 decoration: BoxDecoration(
                                   color: Colors.grey[400] ,
                                   borderRadius: BorderRadius.all(Radius.circular(50)),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                      SizedBox(width: 10,),
                 ],
           ),
      SizedBox(height: 10), // Adjust the spacing as needed
      
          // Container(
          //     decoration: BoxDecoration(
          //         color: Colors.grey[300],
          //         borderRadius: BorderRadius.all(Radius.circular(20))),
          //     height: 113,
          //     width: 330,
          //     child: Column(
          //       children: [
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 20, width: 120),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!),
          //         SizedBox(
          //           height: 8,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 15, width: 220),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 15, width: 250),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Shimmer.fromColors(
          //             child: Container(
          //                 color: Colors.black, height: 15, width: 100),
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!)
          //       ],
          //     )),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
          SizedBox(
            height: 3,
          ),
          ShimmerColumn(),
        ],
      ),
    );
  }
}

class ShimmerColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: 450,
      child: Card(
        elevation: 3.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Wrap the CircleAvatar with Shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CircleAvatar(
                      radius: 20,
                      // Use a transparent placeholder image
                      backgroundImage: AssetImage("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                        child: Container(
                          height: 5,
                          width: 20,
                        ),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  // Wrap the RatingBarIndicator with Shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: RatingBarIndicator(
                      rating: 0.0, // Use a dummy rating value
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 24.0,
                      unratedColor: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              // Wrap the comment text with Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors
                      .white, // Use a background color that matches your UI
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Wrap the date text with Shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80.0,
                      height: 12.0,
                      color: Colors
                          .white, // Use a background color that matches your UI
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
