import 'package:flutter/material.dart';
import 'package:studybean/features/home/views/local_account_page.dart';
import 'package:studybean/features/roadmap/views/roadmap/roadmap_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    _pages = [
      const RoadmapPage(),
      const LocalAccountPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _index = index;
          });
        },
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.space_dashboard_rounded),
            icon: Icon(Icons.space_dashboard_outlined),
            label: 'Roadmaps',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_outlined),
            icon: Icon(Icons.settings_outlined),
            label: 'Account',
          ),
        ],
      ),
      body: _pages[_index],
    );
  }
}
