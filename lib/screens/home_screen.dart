
import 'package:flutter/material.dart';

import 'call_log_screen.dart';
import 'dialer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const DialerScreen(),
    const CallLogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dialpad),
            label: 'Dialer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Call Log',
          ),
        ],
      ),
    );
  }
}