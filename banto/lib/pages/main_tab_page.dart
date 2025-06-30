import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'tabs/tab1_page.dart';
import 'tabs/tab2_page.dart';
import 'tabs/tab3_page.dart';
import 'tabs/tab4_page.dart';
import 'tabs/tab5_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Tab1Page(),
    const Tab2Page(),
    const Tab3Page(),
    const Tab4Page(),
    const Tab5Page(),
  ];

  final List<String> _normalIcons = [
    AppConstants.tab1NormalIcon,
    AppConstants.tab2NormalIcon,
    AppConstants.tab3NormalIcon,
    AppConstants.tab4NormalIcon,
    AppConstants.tab5NormalIcon,
  ];

  final List<String> _selectedIcons = [
    AppConstants.tab1SelectedIcon,
    AppConstants.tab2SelectedIcon,
    AppConstants.tab3SelectedIcon,
    AppConstants.tab4SelectedIcon,
    AppConstants.tab5SelectedIcon,
  ];

  final List<String> _titles = [
    AppConstants.tab1Title,
    AppConstants.tab2Title,
    AppConstants.tab3Title,
    AppConstants.tab4Title,
    AppConstants.tab5Title,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 自定义图标
                        Container(
                          width: 32,
                          height: 32,
                          child: Image.asset(
                            isSelected ? _selectedIcons[index] : _normalIcons[index],
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
} 