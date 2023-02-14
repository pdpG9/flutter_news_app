
import 'dart:convert';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.child,
  });

  int id;
  String name;
  String slug;
  List<CategoryModel>? child;

  factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"]??-1,
    name: json["name"]??"",
    slug: json["slug"]??"",
    child: json["child"] == null ? [] : List<CategoryModel>.from(json["child"]!.map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "child": child == null ? [] : List<dynamic>.from(child!.map((x) => x.toJson())),
  };
}