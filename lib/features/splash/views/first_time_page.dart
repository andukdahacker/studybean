import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstTimePage extends StatelessWidget {
  const FirstTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Text(
                  'StudyBean',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('assets/logo/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  'Create roadmap for your next learning adventure',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Get a clearer path to achieve skills and knowledge with the help of artificial intelligence',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.go('/firstTime/createRoadmap');
                  },
                  child: const Text('Get Started'),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: () {
                    context.go('/firstTime/signIn');
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
