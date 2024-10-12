import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/check_user_credit/check_local_user_credit_cubit.dart';

class LocalAccountPage extends StatelessWidget {
  const LocalAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CheckLocalUserCreditCubit>()..checkUserCredit(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CheckLocalUserCreditCubit, CheckLocalUserCreditState>(
                builder: (context, state) {
                  switch (state) {
                    case CheckLocalUserCreditInitial():
                    case CheckLocalUserCreditLoading():
                      return CircularProgressIndicator(
                        color: context.theme.primaryColor,
                      );
                    case CheckLocalUserCreditSuccess():
                      return Text(
                        'Credits left: ${state.totalCredits}',
                        style: context.theme.textTheme.titleMedium,
                      );
                    case CheckLocalUserCreditError():
                      return const Text('Error');
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Create an account and get amazing perks!',
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Icon(Icons.layers_outlined),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Create multiple Roadmaps',
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(Icons.trending_up),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Get 3x Credits for AI features',
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(Icons.card_giftcard),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Receive bundles of utilities',
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.push('/signUp');
                },
                child: const Text('Create an account'),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: context.theme.textTheme.bodyMedium,
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/signIn');
                          },
                          child: Text(
                            'Sign In',
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
