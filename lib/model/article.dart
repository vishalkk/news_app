import 'package:news_app/model/source.dart';
import "dart:convert";

ArticleModel apiModelFromJson(String str) =>
    ArticleModel.fromJson(json.decode(str));

//String apiModelToJson(ArticleModel data) => json.encode(data.toJson());

class ArticleModel {
  final SourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String date;
  final String img;
  final String content;

  ArticleModel._(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.date,
      required this.img,
      required this.content});

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel._(
        source: SourceModel.fromJson(json["source"]),
        author: json["author"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        url: json["url"] ?? "",
        img: json["urlToImage"] ?? "",
        date: json["publishedAt"] ?? "",
        content: json["content"] ?? "",
      );
}
