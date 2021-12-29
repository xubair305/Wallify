class WallpaperModel {
  String? photographerName;
  String? photographerUrl;
  int? photographerId;
  SrcModel? src;

  WallpaperModel(
      {this.photographerId,
      this.photographerName,
      this.photographerUrl,
      this.src});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      src: SrcModel.fromMap(jsonData["src"]),
      photographerUrl: jsonData["photographer_url"],
      photographerId: jsonData["photographer_id"],
      photographerName: jsonData["photographer"],
    );
  }
}

class SrcModel {
  String? original;
  String? small;
  String? portrait;

  SrcModel({this.original, this.portrait, this.small});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData["original"],
      small: jsonData["small"],
      portrait: jsonData["portrait"],
    );
  }
}
