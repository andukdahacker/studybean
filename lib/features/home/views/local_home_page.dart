import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/common/widgets/bottom_sheet_header_widget.dart';
import 'package:studybean/features/home/views/local_account_page.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_with_ai_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_roadmap_cubit/create_roadmap_with_ai_cubit.dart';

import '../../../common/di/get_it.dart';
import '../../roadmap/views/roadmap/roadmap_local_page.dart';

class LocalHomePage extends StatefulWidget {
  const LocalHomePage({super.key, required this.isFirstTime});

  final bool isFirstTime;

  @override
  State<LocalHomePage> createState() => _LocalHomePageState();
}

class _LocalHomePageState extends State<LocalHomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showFirstTimeDialog(context);
    });
  }

  void showFirstTimeDialog(BuildContext context) async {
    final cubit = context.read<CreateLocalRoadmapWithAiCubit>();
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    await context.showBottomSheet(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 48,
            ),
            Text(
              'You created your first roadmap, and here is our little gift.',
              style: context.theme.textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+10',
                  style: context.theme.textTheme.displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(
                  Icons.hexagon_outlined,
                  size: 48,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'You received 10 Credits!',
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            RichText(
              text: TextSpan(
                text: 'Credit ',
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                      text:
                          'is the currency for services in Study Bean, such as using AI tokens, exchanging rewards and more!',
                      style: context.theme.textTheme.bodyLarge)
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Next'))
          ],
        ),
      ),
      heightRatio: 0.7,
    );

    if (context.mounted) {
      await context.showBottomSheet(
        builder: (context) => Column(
          children: [
            const BottomSheetHeaderWidget(
              title: 'Roadmap with AI',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'A roadmap needs detailed milestones and actions.',
                      style: context.theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Do you want AI to create a full roadmap for you?',
                      style: context.theme.textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          cubit.createWithFirstRoadmap();
                          context.pop();
                        },
                        child: const Text('Create roadmap with AI (-1💎)')),
                    const SizedBox(height: 8,),
                    OutlinedButton(onPressed: () {
                      context.pop();
                    }, child: const Text('No thanks'))
                  ],
                ),
              ),
            ),
          ],
        ),
        heightRatio: 0.4,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLocalRoadmapWithAiCubit,
        CreateLocalRoadmapWithAiState>(
      builder: (context, state) {
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
      },
    );
  }
}
