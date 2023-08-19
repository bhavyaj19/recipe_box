import 'package:flutter/material.dart';
import 'package:recipe_box/utils/global_variables.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        onDestinationSelected: (index) {
          setState(() {
            _page = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        selectedIndex: _page,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home_rounded),
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
            selectedIcon: Icon(Icons.search_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmarks_outlined),
            label: 'Saved',
            selectedIcon: Icon(Icons.bookmarks_rounded),
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
            selectedIcon: Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
    );
  }
}
