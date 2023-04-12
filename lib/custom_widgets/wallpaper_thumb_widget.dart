import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/constants/app_colors.dart';
import 'package:wallify/constants/app_size.dart';
import 'package:wallify/custom_widgets/shimmer.dart';
import 'package:wallify/model/wallpaper_model.dart';
import 'package:wallify/views/image/image_view.dart';

BuildContext? context;

// ignore: non_constant_identifier_names
Widget WallpaperThumbnail({required List<WallpaperModel> wallpapers, context}) {
  // WallpaperThumbnail(wallpaper, context);
  return Padding(
    padding: EdgeInsets.only(bottom: getHeight(16)),
    child: GridView.builder(
      itemCount: wallpapers.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      // crossAxisCount: 2,
      // childAspectRatio: 0.6,
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(16),
      ),
      // mainAxisSpacing: 8.0,
      // crossAxisSpacing: 8.0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) => GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageView(
                  imgUrl: wallpapers[index].src!.portrait,
                  heroTag: wallpapers[index].src!.portrait! + index.toString(),
                ),
              ),
            );
          },
          child: Hero(
            tag: wallpapers[index].src!.portrait! + index.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: wallpapers[index].src!.portrait!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[50])!,
                  child: Container(
                    height: getHeight(200),
                    width: getWidth(100),
                    decoration: BoxDecoration(
                      color: Kolors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
