import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/routes/routes.dart';

import '../../auth/auth/auth_cubit.dart';
import 'bloc/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<SplashCubit>()..init(),
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            switch (state) {
              case SplashInitial():
                break;
              case SplashLoading():
                break;
              case SplashFirstTime():
                context.goNamed(AppRoutes.firstTime.name);
                break;
              case SplashLoaded():
                final authState = context.read<AuthCubit>().state;

                switch (authState) {
                  case AuthInitial():
                  case AuthLoading():
                    break;
                  case AuthSuccess():
                    context.go('/home');
                    break;
                  case AuthUnauthorized():
                    context.go('/local/home');
                    break;
                  case AuthError():
                    context.go('/signIn');
                    break;
                }
                break;
              case SplashError():
                context.showErrorDialog(
                  title: 'Error',
                  message: 'Something went wrong. Please try again.',
                  onRetry: () {
                    context.read<SplashCubit>().init();
                  },
                );
                break;
            }
          },
          builder: (context, state) => const Center(
            child: Hero(
              tag: 'logo',
              child: Material(
                child: Image(
                  width: 128,
                  height: 128,
                  image: AssetImage('assets/logo/logo.png'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
