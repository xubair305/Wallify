import 'package:wallify/model/categories_model.dart';

String apiKey = "563492ad6f9170000100000139764acfbb7a491fa82e4d8881dcaee7";

List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [
    CategoriesModel(
      categorieName: "Street Art",
      imgUrl:
          "https://images.pexels.com/photos/2263686/pexels-photo-2263686.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500https://images.pexels.com/photos/2263686/pexels-photo-2263686.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    ),
    CategoriesModel(
      categorieName: "Wild Life",
      imgUrl:
          "https://images.pexels.com/photos/4562477/pexels-photo-4562477.png?auto=compress&cs=tinysrgb&dpr=1&w=500",
    ),
    CategoriesModel(
      categorieName: "Bikes",
      imgUrl:
          "https://images.pexels.com/photos/2747540/pexels-photo-2747540.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
    ),
    CategoriesModel(
      categorieName: "Cars",
      imgUrl:
          "https://images.pexels.com/photos/337909/pexels-photo-337909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    ),
    CategoriesModel(
      categorieName: "City",
      imgUrl:
          "https://images.pexels.com/photos/1095826/pexels-photo-1095826.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    ),
    CategoriesModel(
      categorieName: "3D Wall",
      imgUrl:
          "https://images.pexels.com/photos/5011647/pexels-photo-5011647.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    ),
    CategoriesModel(
      categorieName: "Forest",
      imgUrl:
          "https://images.pexels.com/photos/957024/forest-trees-perspective-bright-957024.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    ),
  ];
  return categories;
}
