import 'package:flutter/material.dart';
import 'package:habitualize/page/homepage/home_screen.dart';
import 'package:habitualize/page/discover/discover_page.dart';
import 'package:habitualize/page/progress_page/progress_page.dart';
import 'package:habitualize/page/journal_page/journal_page.dart';
import 'package:habitualize/widgets/bottomnavbar.dart';
import 'package:habitualize/page/auth/login_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  bool isLoggedIn = false;

  final List<Widget> _pages = [
    const HabitualizeHome(),
    const DiscoverPage(),
    const ProgressPage(),
    const JournalPage(),
  ];

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _handleLogin() {
    if (mounted) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
            ),
          )
        : LoginPage(onLogin: _handleLogin);
  }
}
