import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:wallify/constants/app_colors.dart';
import 'package:wallify/constants/app_size.dart';
import 'package:wallify/constants/app_text.dart';
import 'package:wallify/custom_widgets/shimmer.dart';
import 'package:wallify/custom_widgets/wallpaper_thumb_widget.dart';
import 'package:wallify/data/data.dart';
import 'package:wallify/model/wallpaper_model.dart';

class Categorie extends StatefulWidget {
  final String? categorieName;

  const Categorie({Key? key, this.categorieName}) : super(key: key);

  @override
  _CategorieState createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  var _isLoading = false;
  List<WallpaperModel> wallpapers = [];

  getSearchWallpaper(String query) async {
    setState(() {
      _isLoading = true;
    });
    var url =
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=40");
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
    getSearchWallpaper(widget.categorieName!);
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
        title: AppText(
          text: widget.categorieName!,
          color: Kolors.black,
          size: 24,
        ),
        backgroundColor: Kolors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
