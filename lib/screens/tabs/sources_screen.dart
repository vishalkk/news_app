import 'package:flutter/material.dart';
import 'package:news_app/bloc/get_sources_bloc.dart';
import 'package:news_app/elements/error_element.dart';
import 'package:news_app/elements/loader_element.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/screens/source_detail.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({Key? key}) : super(key: key);

  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourceBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error == null && snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }

          return _buildSources(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildSources(SourceResponse? data) {
    List<SourceModel>? sources = data!.sources;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.84,
      ),
      itemCount: sources.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 10.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SourceDetail(source: sources[index]),
                ),
              );
            },
            child: Container(
              width: 100.0,
              decoration: const BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: sources[index].id,
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image:
                            AssetImage("assets/logos/${sources[index].id}.png"),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      sources[index].name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
