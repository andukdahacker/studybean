import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/features/auth/forgot_password/views/forgot_password_page.dart';
import 'package:studybean/features/home/views/local_home_page.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_with_ai_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/action_local_page.dart';
import 'package:studybean/features/roadmap/views/roadmap/milestone_page.dart';
import 'package:studybean/features/roadmap/views/roadmap/resource_page.dart';
import 'package:studybean/features/roadmap/views/roadmap/roadmap_detail_page.dart';

import '../features/auth/auth/auth_cubit.dart';
import '../features/auth/change_password/views/change_password_page.dart';
import '../features/auth/sign_in/views/sign_in_page.dart';
import '../features/auth/sign_up/views/sign_up_page.dart';
import '../features/home/views/home_page.dart';
import '../features/roadmap/views/create_roadmap/create_roadmap_local_page.dart';
import '../features/roadmap/views/create_roadmap/create_roadmap_page.dart';
import '../features/roadmap/views/roadmap/action_page.dart';
import '../features/roadmap/views/roadmap/create_action_page.dart';
import '../features/roadmap/views/roadmap/create_local_action_page.dart';
import '../features/roadmap/views/roadmap/milestone_local_page.dart';
import '../features/roadmap/views/roadmap/roadmap_local_detail_page.dart';
import '../features/splash/views/first_time_page.dart';
import '../features/splash/views/splash_page.dart';

enum AppRoutes {
  splash('splash'),
  home('home'),
  firstTime('firstTime'),
  createRoadmap('createRoadmap'),
  signIn('signIn'),
  signUp('signUp'),
  resource('resource'),
  ;

  final String name;

  const AppRoutes(this.name);
}

final _navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _navigatorKey,
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;

    switch (authState) {
      case AuthInitial():
      case AuthLoading():
      case AuthSuccess():
      case AuthError():
        return null;
      case AuthUnauthorized():
        if (state.uri.pathSegments.isNotEmpty &&
            (state.uri.pathSegments.first == 'local' ||
                state.uri.pathSegments.first == 'firstTime' ||
                state.uri.pathSegments.first == 'signUp' ||
                state.uri.pathSegments.first == 'forgotPassword' ||
                state.uri.pathSegments.first == 'signIn')) {
          return null;
        }
        return '/signIn';
    }
  },
  routes: [
    GoRoute(
      name: AppRoutes.splash.name,
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
        name: AppRoutes.firstTime.name,
        path: '/firstTime',
        builder: (context, state) => const FirstTimePage(),
        routes: [
          GoRoute(
            name: 'firstTimeCreateRoadmap',
            path: 'createRoadmap',
            builder: (context, state) => const CreateRoadmapLocalPage(
              isFirstTime: true,
            ),
          ),
          GoRoute(
            name: 'firstTimeLogin',
            path: 'signIn',
            builder: (context, state) => const SignInPage(),
          ),
          GoRoute(
            name: 'firstTimeRegister',
            path: 'signUp',
            builder: (context, state) => const SignUpPage(),
          )
        ]),
    GoRoute(
      name: AppRoutes.signIn.name,
      path: '/signIn',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      name: AppRoutes.signUp.name,
      path: '/signUp',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/local/home',
      name: 'localHome',
      builder: (context, state) {
        final isFirstTime =
            state.uri.queryParameters['isFirstTime'] == 'true' ? true : false;
        return BlocProvider(
          create: (context) => getIt<CreateLocalRoadmapWithAiCubit>(),
          child: LocalHomePage(
            isFirstTime: isFirstTime,
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'createRoadmap',
          builder: (context, state) => const CreateRoadmapLocalPage(),
        ),
        GoRoute(
          path: 'roadmap/:roadmapId',
          builder: (context, state) =>
              RoadmapLocalDetailPage(id: state.pathParameters['roadmapId']!),
          routes: [
            GoRoute(
                path: 'milestone/:milestoneId',
                builder: (context, state) => MilestoneLocalPage(
                    milestoneId: state.pathParameters['milestoneId']!),
                routes: [
                  GoRoute(
                    name: 'createLocalAction',
                    path: 'createAction',
                    builder: (context, state) => CreateLocalActionPage(
                      milestoneId: state.pathParameters['milestoneId']!,
                    ),
                  ),
                  GoRoute(
                    name: 'localActionDetail',
                    path: 'action/:actionId',
                    builder: (context, state) => ActionLocalPage(
                        actionId: state.pathParameters['actionId']!),
                  )
                ]),
          ],
        ),
      ],
    ),
    GoRoute(
        name: AppRoutes.home.name,
        path: '/home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
              path: 'roadmap/:roadmapId',
              builder: (context, state) => RoadmapDetailPage(
                    id: state.pathParameters['roadmapId']!,
                  ),
              routes: [
                GoRoute(
                    path: 'milestone/:milestoneId',
                    builder: (context, state) => MilestonePage(
                        milestoneId: state.pathParameters['milestoneId']!),
                    routes: [
                      GoRoute(
                        path: 'createAction',
                        builder: (context, state) => CreateActionPage(
                          milestoneId: state.pathParameters['milestoneId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'action/:actionId',
                        builder: (context, state) => ActionPage(
                          actionId: state.pathParameters['actionId']!,
                        ),
                        routes: [
                          GoRoute(
                              path: 'resource/:resourceId',
                              name: AppRoutes.resource.name,
                              builder: (context, state) {
                                final resourceId = state
                                    .pathParameters['resourceId'] as String;

                                return ResourcePage(
                                  resourceId: resourceId,
                                );
                              })
                        ],
                      )
                    ]),
              ]),
          GoRoute(
            name: 'createRoadmap',
            path: 'createRoadmap',
            builder: (context, state) => const CreateRoadmapPage(),
          ),
          GoRoute(
            name: 'roadmapDetail',
            path: 'roadmap/:roadmapId',
            builder: (context, state) =>
                RoadmapDetailPage(id: state.pathParameters['roadmapId']!),
          ),
          GoRoute(
            path: 'changePassword',
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ]),
  ],
);
