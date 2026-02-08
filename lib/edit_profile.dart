
/*import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
 final String name, country, photoProfile, city;
UpdateProfile({this.country, this.name, this.photoProfile, this.city});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController, countryController, cityController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    countryController = TextEditingController(text: widget.country);
    cityController = TextEditingController(text: widget.city);
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void updateData() {
    // Implement your update logic here.
    // You can use the values from nameController, countryController, and cityController.
    // For example, you can Debugs the updated values.
    Debugs('Name: ${nameController.text}');
    Debugs('Country: ${countryController.text}');
    Debugs('City: ${cityController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 140.0,
                    width: 140.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70.0),
                      color: Colors.blueAccent,
                    ),
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 70.0,
                          backgroundImage: NetworkImage(widget.photoProfile),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              // Implement image selection logic here.
                              // You can use a package like image_picker.
                            },
                            child: Container(
                              height: 45.0,
                              width: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.5),
                                color: Colors.blueAccent,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: countryController,
                decoration: InputDecoration(
                  hintText: 'Country',
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: 'City',
                ),
              ),
            ),
            SizedBox(height: 80.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () {
                  updateData();
                  // Show a dialog or navigate to a different screen on update.
                },
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent, // Change the color as needed.
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/