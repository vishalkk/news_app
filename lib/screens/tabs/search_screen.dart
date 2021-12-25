import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_app/bloc/get_top_headlines_bloc.dart';
import 'package:news_app/bloc/search_bloc.dart';
import 'package:news_app/elements/error_element.dart';
import 'package:news_app/elements/loader_element.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

import '../news_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchBloc.search("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc.search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.teal,
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        EvaIcons.backspaceOutline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc.search(_searchController.text);
                        });
                      },
                    )
                  : const Icon(
                      EvaIcons.searchOutline,
                      color: Colors.tealAccent,
                    ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding: const EdgeInsets.only(
                left: 15.0,
                right: 10.0,
              ),
              labelText: "Search news...",
              hintStyle: const TextStyle(
                fontSize: 14.0,
                color: style.Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              labelStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            autocorrect: false,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleResponse>(
            stream: searchBloc.subject.stream,
            builder: (BuildContext context,
                AsyncSnapshot<ArticleResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error == null &&
                    snapshot.data!.error.isNotEmpty) {
                  return buildErrorWidget(snapshot.data!.error);
                }

                return _buildSearchNews(snapshot.data!);
              } else if (snapshot.hasError) {
                return buildErrorWidget(snapshot.error.toString());
              } else {
                return buildLoadingWidget();
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildSearchNews(ArticleResponse? data) {
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
