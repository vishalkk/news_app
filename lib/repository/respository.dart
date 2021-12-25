import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/model/source_response.dart';

class NewsRepository {
  final String apiKey = "47230aa500e94680a96420ec3a84fd33";
  static String mainUrl = "https://newsapi.org/v2/";
  //     "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=47230aa500e94680a96420ec3a84fd33";
  // const API_KEY =;
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://newsapi.org/v2/", headers: {
      "Authorization": "47230aa500e94680a96420ec3a84fd33",
      "accept": "*/*",
    }),
  );

  var getSourcesUrl = '$mainUrl/sources';
  var getTopHeadlinesUrl = '$mainUrl/top-headlines';
  var everythingUrl = "$mainUrl/everything";

  Future<SourceResponse> getSources() async {
    var params = {
      "apiKey": apiKey,
      "language": "en",
      "country": "us",
    };

    try {
      Response response = await _dio.get(getSourcesUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
          queryParameters: params);

      return SourceResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return SourceResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getTopHeadlines() async {
    var params = {
      "apiKey": apiKey,
      "country": "us",
    };

    try {
      Response response = await _dio.get(getTopHeadlinesUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
          queryParameters: params);

      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getHotNews() async {
    var params = {
      "apiKey": apiKey,
      "q": "apple",
      "sortBy": "popularity",
    };

    try {
      Response response = await _dio.get(everythingUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
          queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getSourceNews(String sourceId) async {
    var params = {"apiKey": apiKey, "sources": sourceId};

    try {
      Response response = await _dio.get(getTopHeadlinesUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
          queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> search(String searchValue) async {
    var params = {
      "apiKey": apiKey,
      "q": searchValue,
    };

    try {
      Response response = await _dio.get(getTopHeadlinesUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
          queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError("$error");
    }
  }
}
