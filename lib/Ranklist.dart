import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pull_to_refresh;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_application_1/Bottom.dart';

class Ranklist extends StatefulWidget {
  const Ranklist({Key? key}) : super(key: key);

  @override
  State<Ranklist> createState() => _Ranklist();
}

class _Ranklist extends State<Ranklist> {
  late ScrollController _scrollController;
  var data = <String, dynamic>{};
  int itemsPerPage = 10;
  int currentPage = 1;
  List<Map<String, dynamic>> result = [];
  bool firsttime = true;
  int? count;
  Timer? _refreshTimer;
  pull_to_refresh.RefreshController refreshController =
      pull_to_refresh.RefreshController(initialRefresh: false);
  Future<List<Map<String, dynamic>>> getdata(int page) async {
    var res = await http
        .get(Uri.parse('https://lookranks.com/and_api/ranklist/?page=$page'));
    var apiData = jsonDecode(res.body);
    Debugs('Ranklist api data :$apiData');
    count = apiData["count"];
    return List<Map<String, dynamic>>.from(apiData["results"]);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    result = [];
    currentPage == 1;

    _loadData();
    _refreshTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      _loadData();
    });
  }

  void dispose() {
    super.dispose();
    // Cancel the refresh timer to prevent memory leaks
    _refreshTimer?.cancel();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    // Remove the cache manager initialization
    final prefs = await SharedPreferences.getInstance();

    if (currentPage == 1) {
      // You can remove the code related to cache here
      // FileInfo? fileInfo = await cacheManager.getFileFromCache('savedData.json');
      // if (fileInfo != null) {
      //   String data = await fileInfo.file.readAsString();
      //   setState(() {
      //     result = (json.decode(data) as List<dynamic>).cast<Map<String, dynamic>>();
      //     currentPage++;
      //   });
      // }
    }

    final newData = await getdata(currentPage);

    setState(() {
      result.addAll(newData);

      // You can remove the code related to saving data to cache here
      // if (currentPage == 1) {
      //   String newDataJson = json.encode(newData);
      //   cacheManager.putFile('savedData.json', Uint8List.fromList(newDataJson.codeUnits));
      // }

      currentPage++;
    });
  }

  // Future<void> _loadData() async {
  //   DefaultCacheManager cacheManager = DefaultCacheManager();
  //   final prefs = await SharedPreferences.getInstance();

  //   if (currentPage == 1) {
  //     // Try to load data from the cache on the first load
  //     FileInfo? fileInfo =
  //         await cacheManager.getFileFromCache('savedData.json');
  //     if (fileInfo != null) {
  //       // Data found in the cache, parse and set it
  //       String data = await fileInfo.file.readAsString();
  //       setState(() {
  //         // currentPage = prefs.getInt('RanklistcurrentPage') ?? 1;
  //         result =
  //             (json.decode(data) as List<dynamic>).cast<Map<String, dynamic>>();
  //         currentPage++;
  //       });
  //     }
  //   }

  //   final newData = await getdata(currentPage);

  //   setState(() {
  //     result.addAll(newData);

  //     // Save the new data tothe cache
  //     if (currentPage == 1) {
  //       String newDataJson = json.encode(newData);
  //       cacheManager.putFile(
  //           'savedData.json', Uint8List.fromList(newDataJson.codeUnits));
  //     }

  //     // Update currentPage and save it
  //     currentPage++;
  //     // prefs.setInt('RanklistcurrentPage', currentPage);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        //toolbarHeight: 40,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[50],
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 40, left: 5.0, bottom: 25),
          child: GradientText(
            "RankList",
            style: TextStyle(
              fontFamily: "Lemon",
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
            colors: [
              Colors.blueAccent,
              Colors.pinkAccent,
              //  Colors.blueGrey,
              //  Colors.green
            ],
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: result.length + 1, // +1 for a loading indicator at the end
        itemBuilder: (BuildContext context, i) {
          if (i < result.length) {
            return CustomListItem(
              flags: result[i]["country_name"],
              subtitle: result[i]['description'],
              rank: i + 1,
              imagelink: result[i]['picuserreverse']["pic"],
              title: result[i]['name'],
              rating: result[i]["star_rating"],
              isNewUser: false,
              rateby: result[i]["viewcounts"],
              fontsize: 14,
            );
          } else if (count == result.length - 1) {
          } else {
            if (count != result.length) {
              if (firsttime) {
                firsttime = false;
                return Tencard();
              } else {
                return CustomListItemShimmer();
              }
            }
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    DefaultCacheManager cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();
    // Reload data from the API when the user scrolls up
    currentPage = 1; // Reset the page to the first page
    final newData = await getdata(currentPage);

    setState(() {
      result = newData;
      refreshController.refreshCompleted();
      currentPage++;
    });
  }
}

class CustomListItem extends StatelessWidget {
  final String flags;
  final String title;
  var subtitle;
  final String imagelink;
  final int rank;
  final double rating;
  final bool isNewUser;
  final double fontsize;
  int rateby;

  CustomListItem(
      {required this.flags,
      required this.title,
      required this.subtitle,
      required this.imagelink,
      required this.rating,
      required this.fontsize,
      required this.rank,
      this.isNewUser = false,
      required this.rateby});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 2, 3, 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(15),
              topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(1),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ClipOval(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullImage(
                              imageUrl: imagelink,
                            ),
                          ));
                    },
                    child: Hero(
                      tag: imagelink,
                      child: CachedNetworkImage(
                        imageUrl: imagelink,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        // placeholder: (context, url) => CircularProgressIndicator(
                        //     color: Colors
                        //         .redAccent), // Placeholder widget while loading
                        errorWidget: (context, url, error) => Icon(Icons
                            .error), // Widget to display in case of an error
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Icon(
                        Icons.local_activity_rounded,
                        size: 30,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white60,
                      ),
                      width: 20,
                      height: 20,
                    ),
                    if (rank == 1)
                      Text(
                        '🥇',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    else if (rank == 2)
                      Text(
                        '🥈',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    else if (rank == 3)
                      Text(
                        '🥉',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    else
                      Text(
                        rank.toString(),
                        style: TextStyle(fontSize: 9, color: Colors.red),
                      )
                  ],
                ),
              ],
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title.length > 11 ? "${title.substring(0, 9)}..." : title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (flags != "None")
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage(
                          "assets/images/flags/${flags.toLowerCase()}.png",
                        ),
                      ),
                    if (isNewUser)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'New User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.0),
                // if (rateby != null)
                Row(
                  children: [
                    Text(
                      "Rated By ",
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    Text(
                      rateby.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    if (rateby < 2)
                      Text(
                        " person ",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),

                    if (rateby > 1)
                      Text(
                        " people ",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    // Text(
                    //   " Peoples",
                    //   style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    // ),
                  ],
                ),
              ],
            ),
            Spacer(),
            SizedBox(width: 10),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.yellow[600],
                      size: 70,
                    ),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tencard extends StatefulWidget {
  const Tencard({super.key});

  @override
  State<Tencard> createState() => _TencardState();
}

class _TencardState extends State<Tencard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
        CustomListItemShimmerss(),
      ],
    );
  }
}

class CustomListItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 4, 5, 4),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: 40,
                )),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150,
                    height: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 30),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  Icons.star_rate_rounded,
                  size: 70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListItemShimmerss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 4, 5, 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: 40,
                )),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150,
                    height: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 30),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  Icons.star_rate_rounded,
                  size: 70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullImage extends StatefulWidget {
  final String imageUrl;

  FullImage({required this.imageUrl});

  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.yellow[700], size: 40),
      ),
      backgroundColor:
          Colors.white12, // Set the background color to transparent

      body: Hero(
        tag: widget.imageUrl,
        child: Center(
          child: Image.network(widget.imageUrl),
        ),
      ),
    );
  }
}




// To clear data from SharedPreferences when the app is exited, you can use the onTerminate method provided by the path_provider package. This method will be called when the app is terminated, and you can use it to clear your data in SharedPreferences. Here's how you can do it:

// Add the path_provider package to your pubspec.yaml:
// yaml
// Copy code
// dependencies:
//   flutter:
//     sdk: flutter
//   http: ^0.13.3
//   shared_preferences: ^2.0.8
//   refresh_indicator: ^2.0.3
//   path_provider: ^2.0.5
// Import the necessary libraries:
// dart
// Copy code
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';
// Implement the onTerminate method to clear data in your app's main function:
// dart
// Copy code
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   runApp(MyApp());
  
//   // Register a callback to clear data when the app is terminated
//   SystemChannels.lifecycle.setMessageHandler((msg) {
//     if (msg == AppLifecycleState.paused.toString()) {
//       clearSharedPreferencesData();
//     }
//     return null;
//   });
// }

// Future<void> clearSharedPreferencesData() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.remove('savedData');
// }
// In the code above:

// We're using SystemChannels.lifecycle.setMessageHandler to register a callback that listens to app lifecycle events. When the app goes into the background (state: AppLifecycleState.paused), it calls the clearSharedPreferencesData function to remove data from SharedPreferences.
// This approach will clear data from SharedPreferences when the app is terminated. It's important to note that this will work for both user-initiated app closures and system-initiated terminations.