import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clon/account_page.dart';
import 'package:flutter_insta_clon/home_page.dart';
import 'package:flutter_insta_clon/search_page.dart';

class TabPage extends StatefulWidget {
  final User user;

  TabPage(this.user);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  List _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(widget.user),
      SearchPage(widget.user),
      AccountPage(widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('tab_page created');
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
