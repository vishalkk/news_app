// ignore_for_file: unnecessary_null_comparison

import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/bloc/get_top_headlines_bloc.dart';
import 'package:news_app/elements/error_element.dart';
import 'package:news_app/elements/loader_element.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlineSliderWidget extends StatefulWidget {
  const HeadlineSliderWidget({Key? key}) : super(key: key);

  @override
  _HeadlineSliderWidgetState createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc.getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error == null && snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }

          return _buildHeadlineSliderWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSliderWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;
    return  SizedBox(
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: false,
          height: 200.0,
          viewportFraction: 0.9,
        ),
        items: getExpenseSliders(articles),
      ),
    );
  }

  getExpenseSliders(List<ArticleModel> articles) {
    return articles
        .map((article) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailNews(article: article)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: article.img != null
                              ? NetworkImage(article.img)
                              : const AssetImage("assets/img/placeholder.jpg")
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: const [
                              0.1,
                              0.9
                            ],
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.white.withOpacity(0.0)
                            ]),
                      ),
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: 250.0,
                        child: Column(
                          children: [
                            Text(
                              article.title,
                              style: const TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 10.0,
                        left: 10.0,
                        child: Text(
                          article.source.name,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 9.0),
                        )),
                    Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: Text(
                          timeAgo(DateTime.parse(article.date.toString())),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 9.0),
                        ))
                  ],
                ),
              ),
            ))
        .toList();
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
