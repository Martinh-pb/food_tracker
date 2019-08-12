import 'package:flutter/material.dart';

import 'recipes_screen.dart';
import 'home_screen.dart';
import 'logbook_screen.dart';
import '../widgets/main_drawer.dart';

class TabOverviewScreen extends StatefulWidget {
  static const routeName = '/dayoverview';

  @override
  _TabOverviewScreenState createState() => _TabOverviewScreenState();
}

class _TabOverviewScreenState extends State<TabOverviewScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'title': 'Home',
        'page': HomeScreen(),
      },
      {
        'title': 'Logbook',
        'page': LogBookScreen(),
      },
      {
        'title': 'Recepies',
        'page': RecipesScreen(),
      },
    ];
    super.initState();
  }

  void tabPressed(int tab) {
    setState(() {
      _selectedPageIndex = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text(_pages[0]['title']),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text(_pages[1]['title']),
            icon: Icon(Icons.note_add),
          ),
          BottomNavigationBarItem(
            title: Text(_pages[2]['title']),
            icon: Icon(Icons.restaurant_menu),
          )
        ],
        currentIndex: _selectedPageIndex,
        onTap: tabPressed,
      ),
    );
  }
}
