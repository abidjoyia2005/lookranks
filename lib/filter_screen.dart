import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_application_1/filter_result.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:flutter_application_1/Bottom.dart';

class Filter_screen extends StatefulWidget {
  var btoken;
  Filter_screen({required this.btoken});

  @override
  State<Filter_screen> createState() => _Filter_screenState(btoken: btoken);
}

class _Filter_screenState extends State<Filter_screen> {
  var btoken;
  _Filter_screenState({required this.btoken});
  TextEditingController countryController = TextEditingController();
  var _selectedCountry;
  var CountrysForText = 'Afghanistan';
  List<Map<String, dynamic>> genderOptions = [
    {"name": "Male", "icon": Icons.male},
    {"name": "Female", "icon": Icons.female},
    {"name": "Other", "icon": Icons.transgender}
  ];
  String selectedGender = 'Male';
  String selectedAgeRange = '60+ Years';
  var age;
  var flag;

  Future<void> loadData(int ages, String countrys, String genders) async {
    try {
      final res = await https.get(
        Uri.parse(
            "https://lookranks.com/and_api/filter/?age=$ages&gender=$genders&country=$countrys/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token $btoken', // Add the token to the headers
        },
      );

      if (res.statusCode == 200) {
        var apiData = jsonDecode(res.body);
        Debugs(res.body);

        // setState(() {
        //   data.addAll(apiData);
        //   isLoading = false;
        //   currentPage++; // Increment the current page after loading data.
        // });
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
        Debugs("API Error: ${res.statusCode}");
      }
    } catch (e) {
      // Handle exceptions here, such as network errors.
      Debugs("Error in server request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "filter",
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.yellow[700]),
            centerTitle: true,
            title: Text("Filter"),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Image.asset('assets/images/Filterscreen.png'),
              Text(
                "Select Country",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 23),
              ),
              Container(
                width: 300,
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
                          CountrysForText = country.name;
                          flag = country.countryCode;
                          Debugs('$CountrysForText');
                        });
                      },
                    );
                  },
                  child: Row(
                    children: [
                      if (_selectedCountry != null)
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            "assets/images/flags/${flag.toLowerCase()}.png",
                          ),
                        ),
                      Text(
                        CountrysForText.length >= 30
                            ? CountrysForText.substring(0, 30)
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
                height: 10,
              ),
              Text(
                "Select Gender",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 23),
              ),
              Container(
                width: 300,
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
              SizedBox(
                height: 10,
              ),
              Text(
                "Select Age",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              Container(
                width: 300,
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                    value: selectedAgeRange,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAgeRange = newValue!;
                      });
                    },
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    items: <String>[
                      '< 18 Years',
                      '< 25 Years',
                      '< 30 Years',
                      '< 40 Years',
                      '< 60 Years',
                      '60+ Years',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selectedAgeRange == "< 18 Years")
                      age = 18;
                    else if (selectedAgeRange == "< 25 Years")
                      age = 25;
                    else if (selectedAgeRange == "< 30 Years")
                      age = 30;
                    else if (selectedAgeRange == "< 40 Years")
                      age = 40;
                    else if (selectedAgeRange == "< 60 Years")
                      age = 60;
                    else if (selectedAgeRange == "60+ Years")
                      age = 100;
                    else if (selectedAgeRange == "All") {
                      age = 100;
                    }
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Filter_result(
                            btoken: btoken,
                            ages: age,
                            countrys: CountrysForText,
                            genders: selectedGender.toLowerCase()),
                      ));
                  loadData(age, CountrysForText, selectedGender.toLowerCase());
                  Debugs("$CountrysForText,$selectedGender,$age");
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(0),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: Container(
                  height: 52.0,
                  width: 200,
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
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Filter",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Poppins"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ]),
          ),
        ));
  }
}
