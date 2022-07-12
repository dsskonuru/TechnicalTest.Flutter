import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tech_task/features/home/ui/widgets/bookmarks_view.dart';
import 'package:flutter_tech_task/features/home/ui/widgets/feed_view.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FeedView(),
    BookmarksView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Posts')),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        icons: const <IconData>[
          Icons.rss_feed_rounded,
          Icons.collections_bookmark_rounded,
        ],
        activeColor: Colors.amber[800],
        leftCornerRadius: 32.0,
        rightCornerRadius: 32.0,
        inactiveColor: Colors.grey[600],
        blurEffect: true,
        onTap: _onItemTapped,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.none,
      ),
    );
  }
}
