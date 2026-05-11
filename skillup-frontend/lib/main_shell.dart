import 'package:flutter/material.dart';
import 'home_page.dart';
import 'skill_page.dart';
import 'portfolio_checker_page.dart';
import 'cv_checker_page.dart';
import 'skill_matching_page.dart';
import 'projects_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(onNavigateToTab: _onTabSelected),
          const SkillPage(),
          const PortfolioCheckerPage(),
          const CvCheckerPage(),
          const SkillMatchingPage(),
          const ProjectsPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120),
        border: Border(top: BorderSide(color: Color(0xFF222B40), width: 1)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, Icons.home_outlined, 'Home', 0),
            _buildNavItem(Icons.list, Icons.list, 'Skills', 1),
            _buildNavItem(Icons.work, Icons.work_outline, 'Portfolio', 2),
            _buildNavItem(Icons.description, Icons.description_outlined, 'CV', 3),
            _buildNavItem(Icons.track_changes, Icons.track_changes, 'Match', 4),
            _buildNavItem(Icons.folder, Icons.folder_outlined, 'Projects', 5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    final isActive = _currentIndex == index;
    final color = isActive ? const Color(0xFF13B5EA) : Colors.white54;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : inactiveIcon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
