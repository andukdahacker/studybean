import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../auth/auth/auth_cubit.dart';
import '../../splash/error_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthInitial():
          case AuthLoading():
          case AuthSuccess():
            break;
          case AuthUnauthorized():
          case AuthError():
            context.go('/login');
            break;
        }
      },
      builder: (context, state) {
        switch (state) {
          case AuthInitial():
          case AuthLoading():
          case AuthUnauthorized():
          case AuthError():
            return const ErrorPage();
          case AuthSuccess():
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      state.user.username,
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.diamond),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${state.user.credits} credits',
                          style: context.theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.showCreditDialog();
                          },
                          child: const Icon(Icons.info_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Email',
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            state.user.email,
                            style: context.theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Password',
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.go('/home/changePassword');
                            },
                            child: Text(
                              'Change password',
                              style: context.theme.textTheme.titleMedium
                                  ?.copyWith(
                                      color: context.theme.colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        context.showConfirmDialog(
                            title: 'Logout',
                            message: 'Are you sure you want to logout?',
                            onConfirm: () {
                              context.read<AuthCubit>().logout();
                            });
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
