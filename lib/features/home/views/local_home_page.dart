import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/home/views/local_account_page.dart';

import '../../roadmap/views/roadmap/roadmap_local_page.dart';

class LocalHomePage extends StatefulWidget {
  const LocalHomePage({super.key});

  @override
  State<LocalHomePage> createState() => _LocalHomePageState();
}

class _LocalHomePageState extends State<LocalHomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.grey,
        indicatorColor: context.theme.colorScheme.primary,
        onDestinationSelected: (int index) {
          setState(() {
            _index = index;
          });
        },
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.map_rounded),
            icon: Icon(Icons.map_outlined),
            label: 'Roadmaps',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
      body: [
        const RoadmapLocalPage(),
        const LocalAccountPage(),
      ][_index],
    );
  }
}
