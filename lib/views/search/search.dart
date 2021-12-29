import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wallify/constants/app_colors.dart';
import 'package:wallify/constants/app_size.dart';
import 'package:wallify/constants/app_text.dart';
import 'package:http/http.dart' as http;
import 'package:wallify/custom_widgets/shimmer.dart';
import 'package:wallify/custom_widgets/wallpaper_thumb_widget.dart';
import 'package:wallify/data/data.dart';
import 'package:wallify/model/wallpaper_model.dart';

class Search extends StatefulWidget {
  final String? searchQuery;
  const Search({Key? key, this.searchQuery}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<WallpaperModel> wallpapers = [];

  getSearchWallpaper(String query) async {
    setState(() {
      _isLoading = true;
    });
    var url =
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=20");
    var response = await http.get(url, headers: {"Authorization": apiKey});
    // log(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // log(element.toString());
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getSearchWallpaper(widget.searchQuery!);
    searchController.text = widget.searchQuery!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            EvaIcons.arrowIosBackOutline,
            color: Kolors.black,
          ),
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: "Walli",
              color: Kolors.black,
              size: 24,
            ),
            AppText(
              text: "fy",
              color: Kolors.blue,
              size: 24,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        backgroundColor: Kolors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Box here
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(20),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: getWidth(20),
                vertical: getHeight(8),
              ),
              decoration: BoxDecoration(
                color: Kolors.searchBackground,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search wallpaper"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getSearchWallpaper(searchController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Search(searchQuery: searchController.text)));
                    },
                    child: const Icon(
                      EvaIcons.searchOutline,
                    ),
                  )
                ],
              ),
            ),
            _isLoading
                ? Shimmer.fromColors(
                    baseColor: (Colors.grey[400])!,
                    highlightColor: (Colors.grey[100])!,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: getHeight(16)),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        padding: EdgeInsets.symmetric(
                          horizontal: getWidth(16),
                        ),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        children: List.generate(10, (index) {
                          return Container(
                            height: getHeight(200),
                            width: getWidth(100),
                            decoration: BoxDecoration(
                                color: Kolors.white,
                                borderRadius: BorderRadius.circular(20)),
                          );
                        }),
                      ),
                    ),
                  )
                : WallpaperThumbnail(context: context, wallpapers: wallpapers),
          ],
        ),
      ),
    );
  }
}
