import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/saved_post_ids_provider.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/bookmarks_view.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/feed_view.dart.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final Set<int> savedPostIds =
            ref.watch(savedPostIdsProvider).value ?? {};
        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('{JSON} Placeholder Posts')),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _selectedIndex,
            onTap: (i) => _onItemTapped(i),
            items: [
              /// Posts
              SalomonBottomBarItem(
                icon: const Icon(Icons.rss_feed_rounded),
                title: const Text("Posts"),
                selectedColor: Colors.purple,
              ),

              /// Bookmarks
              SalomonBottomBarItem(
                icon: Badge(
                  badgeContent: Text(savedPostIds.length.toString()),
                  showBadge: savedPostIds.isNotEmpty,
                  child: const Icon(Icons.collections_bookmark_rounded),
                ),
                title: const Text("Bookmarks"),
                selectedColor: Colors.pink,
              ),
            ],
          ),
        );
      },
    );
  }
}
