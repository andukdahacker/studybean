import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_go_router_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/auth/auth/auth_cubit.dart';
import 'package:studybean/features/auth/models/sign_in_input.dart';
import 'package:studybean/features/auth/sign_in/bloc/sign_in_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  bool _obscureText = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInCubit>(),
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign In'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onEditingComplete: () {
                      _passwordFocusNode.requestFocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }

                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);

                      if (!emailValid) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    decoration: const InputDecoration()
                        .applyDefaults(context.theme.inputDecorationTheme)
                        .copyWith(labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }

                      if (value.length > 20) {
                        return 'Password must be less than 20 characters';
                      }

                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase character';
                      }

                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one lowercase character';
                      }

                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one number';
                      }

                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Password must contain at least one special character';
                      }

                      return null;
                    },
                    decoration: const InputDecoration()
                        .applyDefaults(context.theme.inputDecorationTheme)
                        .copyWith(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/forgotPassword');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.underline,
                          color: context.theme.primaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocConsumer<SignInCubit, SignInState>(
                    listener: (context, state) async {
                      switch (state) {
                        case SignInInitial():
                          break;
                        case SignInLoading():
                          break;
                        case SignInFirebaseSuccess():
                          context
                              .read<SignInCubit>()
                              .signInWithEmail(state.token);
                          break;
                        case SignInFirebaseError():
                          context.showErrorDialog(
                            title: 'Sign In Error',
                            message: state.message,
                            onRetry: () => context
                                .read<SignInCubit>()
                                .firebaseSignInWithEmail(
                                  SignInInput(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                ),
                          );
                          break;
                        case SignInSuccess():
                          await context.read<AuthCubit>().checkAuth();
                          if (context.mounted) {
                            context.go('/home');
                          }
                          break;
                        case SignInError():
                          context.showErrorDialog(
                            title: 'Sign In Error',
                            message: state.message,
                            onRetry: () {
                              context.pop();
                              context
                                .read<SignInCubit>()
                                .firebaseSignInWithEmail(
                                  SignInInput(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                            },
                          );
                          break;
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInCubit>().firebaseSignInWithEmail(
                                  SignInInput(
                                      email: _emailController.text,
                                      password: _passwordController.text),
                                );
                          }
                        },
                        child: (state is SignInLoading)
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Sign In'),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Text(
                  //   'Or',
                  //   style: Theme.of(context).textTheme.bodyMedium,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: const Text('Sign In with Google'),
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: const Text('Sign In with Apple'),
                  // ),
                  const SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      final currentPath = context.location;
                      if (currentPath.pathSegments.contains('firstTime')) {
                        context.push('/firstTime/signUp');
                      } else {
                        context.push('/signUp');
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                                text: 'Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        decoration: TextDecoration.underline,
                                        color: context.theme.primaryColor))
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
