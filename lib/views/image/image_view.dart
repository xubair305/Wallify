import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallify/constants/app_colors.dart';
import 'package:wallify/constants/app_size.dart';

class ImageView extends StatefulWidget {
  final String? imgUrl;
  final String heroTag;

  const ImageView({Key? key, this.imgUrl, required this.heroTag})
      : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  // var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.heroTag,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: getHeight(24)),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // _save();
                    _saveImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Kolors.green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Kolors.white),
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [Color(0x36ffffff), Color(0x0fffffff)],
                        ),
                      ),
                      child: const Icon(
                        EvaIcons.downloadOutline,
                        color: Kolors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: getHeight(12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Kolors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Kolors.white),
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [Color(0x36ffffff), Color(0x0fffffff)],
                        ),
                      ),
                      child: const Icon(
                        EvaIcons.close,
                        color: Kolors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _saveImage() async {
    // if (Platform.isAndroid) {
    //   await _askPermission();
    // }
    bool havePermission = false;
    var permissionStatus = await Permission.storage.status;
    if (!permissionStatus.isLimited && !permissionStatus.isGranted) {
      var permissionStatus1 = await Permission.storage.request();
      havePermission = permissionStatus1.isGranted;
    } else if (permissionStatus.isDenied) {
      var permissionStatus1 = await Permission.storage.request();
      havePermission = permissionStatus1.isGranted;
    } else {
      havePermission = true;
    }
    // if(permissionStatus.isDenied){

    // }
    if (havePermission) {
      var response = await Dio().get(widget.imgUrl!,
          options: Options(responseType: ResponseType.bytes));
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Downloaded..."),
            duration: Duration(seconds: 2),
          ),
        );
        log("********************Saved in gallery*******************");
      }
    }
  }
}
