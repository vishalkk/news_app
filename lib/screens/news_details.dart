// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/model/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/style/theme.dart' as style;

class DetailNews extends StatefulWidget {
  final ArticleModel article;

  const DetailNews({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  _DetailNewsState createState() => _DetailNewsState(article);
}

class _DetailNewsState extends State<DetailNews> {
  final ArticleModel article;

  _DetailNewsState(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      bottomNavigationBar: GestureDetector(
        onTap: () {
          launch(article.url);
        },
        child: Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
            
            color: Colors.tealAccent,
            gradient: style.Colors.primaryGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Read More...",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "SFPro-Bold",
                    fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(30.0, 30.0),
              bottomRight: Radius.elliptical(30.0, 30.0),
            ),
          ),
          backgroundColor: style.Colors.mainColor,
          title: Text(
            article.title,
            style: const TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FadeInImage.assetNetwork(
                alignment: Alignment.topCenter,
                placeholder: 'images/placeholder.png',
                image: article.img,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 1 / 3),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(article.date.substring(0, 10),
                        style: const TextStyle(
                            color: style.Colors.mainColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(article.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  timeUntil(DateTime.parse(article.date)),
                  style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Html(data: article.content, style: {
                  "body": Style(
                      fontSize: const FontSize(14.0), color: Colors.black87),
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }
}
