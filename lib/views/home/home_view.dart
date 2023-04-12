import 'dart:convert';
import 'dart:developer';
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
  final int _pageSize = 20;
  int _page = 1;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  late ScrollController scrollController;

  firstLoad() async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse(
        "https://api.pexels.com/v1/curated/?page=$_page&per_page=$_pageSize");
    var response = await http.get(url, headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    log(jsonData.toString());

    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {
      _isLoading = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      var url = Uri.parse(
          "https://api.pexels.com/v1/curated/?page=$_page&per_page=$_pageSize");
      var response = await http.get(url, headers: {"Authorization": apiKey});

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      log(jsonData.toString());

      jsonData["photos"].forEach((element) {
        WallpaperModel wallpaperModel = WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(element);
        wallpapers.add(wallpaperModel);
      });

      List<WallpaperModel> listt = List<WallpaperModel>.from(
        (jsonData['photos'] as List<dynamic>).map<WallpaperModel>(
          (x) => WallpaperModel.fromMap(x as Map<String, dynamic>),
        ),
      );
      if (listt.isNotEmpty) {
        setState(() {
          wallpapers.addAll(listt);
        });
      } else {
        // This means there is no more data
        // and therefore, we will not send another GET request
        setState(() {
          _hasNextPage = false;
        });
      }
    }

    setState(() {
      _isLoadMoreRunning = false;
    });
  }

  @override
  void initState() {
    firstLoad();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          _loadMore();
        }
      });
    categories = getCategories();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: SingleChildScrollView(
        controller: scrollController,
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     AppText(
            //       text: "Made By: ",
            //       color: Kolors.grey,
            //       size: 12,
            //     ),
            //     AppText(
            //       text: "Xubair",
            //       color: Kolors.blue,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ],
            // ),
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
            SizedBox(height: getHeight(16)),
            _isLoading
                ? _loadingShimmer()
                : WallpaperThumbnail(context: context, wallpapers: wallpapers),
            // when the _loadMore function is running
            if (_isLoadMoreRunning == true) _loadingShimmer(),

            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the wallpaper'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Shimmer _loadingShimmer() {
    return Shimmer.fromColors(
      baseColor: (Colors.grey[300])!,
      highlightColor: (Colors.grey[50])!,
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
                color: Kolors.white, borderRadius: BorderRadius.circular(20)),
          );
        }),
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
