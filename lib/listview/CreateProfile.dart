
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:country_picker/country_picker.dart';


import '../Bottom.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  var _selectedCountry;
  var CountrysForText = "Select Your Country";
  List<Map<String, dynamic>> genderOptions = [
    {"name": "Male", "icon": Icons.male},
    {"name": "Female", "icon": Icons.female},
    {"name": "Other", "icon": Icons.transgender}
  ];
  String selectedGender = 'Male';

  DateTime? selectedDate; // Store the selected date
  var year;
  var Month;
  var Date;
  File? _image; // Store the selected image
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
   
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
     TextEditingController question = TextEditingController();

  Future<void> Uploaddata() async {
    setState(() {});

    final response = await https.put(
      Uri.parse("https://lookranks.com/and_api/profile/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $usertoken',
      },
      body: jsonEncode(
        {
          'country': _selectedCountry.text,
          'dob': "$year-$Month-$Date",
          'gender': selectedGender.toLowerCase(),
          'ask_question1': question.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Debugs(data);

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

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Profile"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.0),
              Container(
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
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Your Name",
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
              SizedBox(height: 16.0),
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
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: TextButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          _selectedCountry = country;
                          CountrysForText = country.name.toString();
                        });
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        CountrysForText,
                        style: TextStyle(
                            //fontFamily: "Sofia",
                            color: Colors.black,
                            fontSize: 16),
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
                height: 16,
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
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(height: 16.0),
              InkWell(
                onTap: _showDatePicker,
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
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  child: Center(
                    child: Text(
                      selectedDate == null
                          ? "Date of Birth"
                          : "${selectedDate!.toLocal()}"
                              .split(' ')[0], 
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {},
                child: Container(
                  height: 52.0,
                  width: double.infinity,
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
                      "Updates",
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
            ],
          ),
        ),
      ),
    );
  }
}
