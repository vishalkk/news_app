import 'package:flutter/material.dart';
import 'package:news_app/bloc/get_source_news_bloc.dart';
import 'package:news_app/elements/loader_element.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

class SourceDetail extends StatefulWidget {
  final SourceModel source;
  const SourceDetail({Key? key, required this.source}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final SourceModel source;

  _SourceDetailState(this.source);
  @override
  void initState() {
    super.initState();
    getSourceNewsBloc.getSourceNews(source.id);
  }

  @override
  void dispose() {
    getSourceNewsBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            centerTitle: false,
            elevation: 0.0,
            backgroundColor: style.Colors.mainColor,
            title: const Text(
              "",
            )),
      ),
      body: Column(
        children: [
          Container(
            height: 180,
            padding: const EdgeInsets.only(
                bottom: 10.0, left: 5.0, right: 5.0, top: 5.0),
            color: style.Colors.mainColor,
            width: MediaQuery.of(context).size.width,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  //bottomRight: Radius.circular(30.0),
                  Radius.circular(30.0),
                ),
                color: Colors.tealAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Hero(
                    tag: source.id,
                    child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/logos/${source.id}.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    source.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    source.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<ArticleResponse>(
              stream: getSourceNewsBloc.subject.stream,
              builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.error == null &&
                      snapshot.data!.error.isNotEmpty) {
                    return Container();
                  }
                  return _buildSourceNewsWidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return buildLoadingWidget();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSourceNewsWidget(ArticleResponse? data) {
    List<ArticleModel> articles = data!.articles;

    if (articles.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              "No more news",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailNews(
                              article: articles[index],
                            )));
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                height: 150,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                        left: 5.0,
                        right: 5.0,
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.tealAccent,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ]),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                      width: MediaQuery.of(context).size.width * 2.85 / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            articles[index].title,
                            maxLines: 3,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14.0),
                          ),
                          Expanded(
                              child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                        timeUntil(DateTime.parse(
                                            articles[index].date)),
                                        style: const TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0))
                                  ],
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ]),
                        padding: const EdgeInsets.only(right: 10.0),
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        height: 130,
                        child: FadeInImage.assetNetwork(
                            alignment: Alignment.topCenter,
                            placeholder: 'assets/img/placeholder.jpg',
                            image: articles[index].img,
                            fit: BoxFit.fitHeight,
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * 1 / 3))
                  ],
                ),
              ),
            );
          });
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
