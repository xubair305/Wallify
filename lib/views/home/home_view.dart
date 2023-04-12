import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wallify/constants/app_colors.dart';
import 'package:wallify/constants/app_size.dart';
import 'package:wallify/constants/app_text.dart';
import 'package:wallify/custom_widgets/bouncing_button.dart';
import 'package:wallify/custom_widgets/my_app_bar.dart';
import 'package:wallify/custom_widgets/shimmer.dart';
import 'package:wallify/custom_widgets/wallpaper_thumb_widget.dart';
import 'package:wallify/data/data.dart';
import 'package:http/http.dart' as http;
import 'package:wallify/model/categories_model.dart';
import 'package:wallify/model/wallpaper_model.dart';
import 'package:wallify/views/category/categorie.dart';
import 'package:wallify/views/search/search.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _isLoading = false;
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();

  getTrendingWallpaper() async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse("https://api.pexels.com/v1/curated?per_page=20");
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
    getTrendingWallpaper();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: "Made By: ",
                  color: Kolors.grey,
                  size: 12,
                ),
                AppText(
                  text: "Xubair",
                  color: Kolors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: getHeight(16)),
            SizedBox(
              height: getWidth(50),
              child: _isLoading
                  ? Shimmer.fromColors(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          children: List.generate(10, (index) {
                            return Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidth(6)),
                                  height: getWidth(50),
                                  width: getWidth(100),
                                  decoration: BoxDecoration(
                                      color: Kolors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      baseColor: (Colors.grey[400])!,
                      highlightColor: (Colors.grey[100])!)
                  : ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoriesTile(
                          imgUrl: categories[index].imgUrl,
                          name: categories[index].categorieName,
                        );
                      },
                    ),
            ),
            SizedBox(
              height: getHeight(16),
            ),
            _isLoading
                ? Shimmer.fromColors(
                    baseColor: (Colors.grey[400])!,
                    highlightColor: (Colors.grey[100])!,
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
                  )
                : WallpaperThumbnail(context: context, wallpapers: wallpapers),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoriesTile extends StatelessWidget {
  final String? imgUrl;
  final String? name;
  CategoriesTile({
    Key? key,
    required this.imgUrl,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(
                      categorieName: name,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: getWidth(6)),
        child: Stack(
          children: [
            ClipRRect(
              child: Image.network(
                imgUrl!,
                height: getHeight(90),
                width: getWidth(110),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            Container(
              alignment: Alignment.center,
              height: getHeight(90),
              width: getWidth(110),
              decoration: BoxDecoration(
                  color: Kolors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16)),
              child: AppText(
                text: name!,
                color: Kolors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
