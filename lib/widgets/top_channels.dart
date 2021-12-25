// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:news_app/bloc/get_sources_bloc.dart';
import 'package:news_app/elements/error_element.dart';
import 'package:news_app/elements/loader_element.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/screens/source_detail.dart';

class TopChannels extends StatefulWidget {
  const TopChannels({Key? key}) : super(key: key);

  @override
  _TopChannelsState createState() => _TopChannelsState();
}

class _TopChannelsState extends State<TopChannels> {
  @override
  void initState() {
    super.initState();
    getSourceBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourceBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error == null && snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }

          return _buildTopChannels(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopChannels(SourceResponse data) {
    List<SourceModel> sources = data.sources;
    if (sources.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const <Widget>[
                Text(
                  "No Sources",
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 115.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sources.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(top: 10.0),
                width: 80.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SourceDetail(source: sources[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: sources[index].id,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                                spreadRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              )
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/logos/${sources[index].id}.png"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        sources[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            height: 1.4,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        sources[index].category,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.4,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.0,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
