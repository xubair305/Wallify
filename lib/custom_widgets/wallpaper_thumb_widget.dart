import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/constants/app_size.dart';
import 'package:wallify/model/wallpaper_model.dart';
import 'package:wallify/views/image/image_view.dart';

List<WallpaperModel>? wallpapers;
BuildContext? context;

// ignore: non_constant_identifier_names
Widget WallpaperThumbnail({wallpapers, context}) {
  // WallpaperThumbnail(wallpaper, context);
  return Padding(
    padding: EdgeInsets.only(bottom: getHeight(16)),
    child: GridView.count(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(16),
      ),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: wallpapers.map<Widget>((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgUrl: wallpaper.src.portrait,
                          )));
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                // child: Image.network(
                //   wallpaper.src!.portrait!,
                //   fit: BoxFit.cover,
                // ),
                child: CachedNetworkImage(
                  imageUrl: wallpaper.src!.portrait!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
