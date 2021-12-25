import "dart:convert";
import 'package:news_app/model/article.dart';



ArticleModel apiModelFromJson(String str) => ArticleModel.fromJson(json.decode(str));

class ArticleResponse {
  final List<ArticleModel> articles;
  final String error;

  ArticleResponse(this.articles, this.error);

  ArticleResponse.fromJson(Map<String, dynamic> json)
      : articles = (json["articles"] as List<dynamic>)
            .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        error = "";

  ArticleResponse.withError(String errorValue)
      : articles = [],
        error = errorValue;
}
