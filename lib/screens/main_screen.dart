import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_app/bloc/bottom_navbar_bloc.dart';
import 'package:news_app/screens/tabs/home_screen.dart';
import 'package:news_app/screens/tabs/search_screen.dart';
import 'package:news_app/screens/tabs/sources_screen.dart';
import 'package:news_app/style/theme.dart' as style;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent[400],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: style.Colors.mainColor,
          title: const Text(
            "iNews",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return const HomeScreen();
              case NavBarItem.SOURCES:
                return const SourcesScreen();
              case NavBarItem.SEARCH:
                return const SearchScreen();
              default:
                testScreen();
            }

            return testScreen();
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0,
                  blurRadius: 10.0,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  iconSize: 20.0,
                  unselectedItemColor: style.Colors.grey,
                  unselectedFontSize: 9.5,
                  selectedFontSize: 9.5,
                  type: BottomNavigationBarType.fixed,
                  fixedColor: style.Colors.mainColor,
                  currentIndex: snapshot.data!.index,
                  onTap: _bottomNavBarBloc.pickItem,
                  items: const [
                    BottomNavigationBarItem(
                        label: 'Home',
                        icon: Icon(EvaIcons.homeOutline),
                        activeIcon: Icon(EvaIcons.home)),

                    BottomNavigationBarItem(
                        label: 'Sources',
                        icon: Icon(EvaIcons.gridOutline),
                        activeIcon: Icon(EvaIcons.gridOutline)),

                    BottomNavigationBarItem(
                        label: 'Search',
                        icon: Icon(EvaIcons.searchOutline),
                        activeIcon: Icon(EvaIcons.search))

                    //)
                  ]),
            ),
          );
        },
      ),
    );
  }

  Widget testScreen() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [Text("Test Screen")],
      ),
    );
  }
}
