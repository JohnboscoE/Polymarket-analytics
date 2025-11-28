import 'package:flutter/material.dart';
import '../analytics_dashboard.dart';
import '../constants.dart';
import 'trending_markets_screen.dart';
import 'top_traders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  //  screens accessible from the bottom navigation bar
  static const List<Widget> _widgetOptions = <Widget>[
    AnalyticsDashboard(),
    TrendingMarketsScreen(),
    TopTradersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // --- Bottom Floating Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'Traders',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: brandBlue,
        unselectedItemColor: lightText.withOpacity(0.6),
        onTap: _onItemTapped,

        backgroundColor: cardSurface,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}