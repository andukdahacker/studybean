import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/home/bloc/check_user_credit_cubit/check_user_credit_cubit.dart';
import 'package:studybean/features/home/bloc/upload_local_roadmap_cubit/upload_local_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/roadmap_page.dart';

import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _index);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          getIt<UploadLocalRoadmapCubit>()
            ..uploadLocalRoadmap(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<CheckUserCreditCubit>()..checkUserCredit(),
          lazy: false,
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.grey,
          indicatorColor: context.theme.colorScheme.primary,
          onDestinationSelected: (int index) {
            setState(() {
              _index = index;
            });
            _pageController.jumpToPage(index);
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
        body: PageView(
          controller: _pageController,
          children: const [
            RoadmapPage(),
            AccountPage(),
          ],
          onPageChanged: (value) {
            setState(() {
              _index = value;
            });
          },
        ),
      ),
    );
  }
}
