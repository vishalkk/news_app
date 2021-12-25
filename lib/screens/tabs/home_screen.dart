import 'package:flutter/material.dart';
import 'package:news_app/widgets/headline_slider.dart';
import 'package:news_app/widgets/hot_news.dart';
import 'package:news_app/widgets/top_channels.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  ListView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: const [
        HeadlineSliderWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Top Channels",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        TopChannels(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Hot news",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        HotNews(),
      ],
    );
  }
}
