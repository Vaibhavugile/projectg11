import 'package:flutter/material.dart';

import '../screens/user_home_screen.dart';
import '../screens/user_markets_screen.dart';
import '../screens/user_charts_screen.dart';
import '../screens/user_notice_screen.dart';
import '../screens/user_profile_screen.dart';
import '../widgets/premium_bottom_nav.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() =>
      _UserDashboardState();
}

class _UserDashboardState
    extends State<UserDashboard> {

  int _currentIndex = 0;

  final List<Widget> _pages = const [

    UserHomeScreen(),

    UserMarketsScreen(),

    UserChartsScreen(),

    UserNoticeScreen(),

    UserProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: PremiumBottomNav(

        currentIndex: _currentIndex,

        onChanged: (index) {

          setState(() {

            _currentIndex = index;

          });

        },

      ),

    );
  }
}