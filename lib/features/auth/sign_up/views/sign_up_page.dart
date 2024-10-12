import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_go_router_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/auth/models/sign_up_input.dart';
import 'package:studybean/features/auth/sign_up/bloc/sign_up_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _usernameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  bool _obscureText = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpCubit>(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          switch (state) {
            case SignUpInitial():
            case SignUpLoading():
              break;
            case SignUpSuccess():
              if (state.isEmailVerified) {
                context.showAppDialog(
                    title: 'Sign up successful',
                    message: 'Check your email to verify your account',
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            context.go('/signIn');
                          },
                          child: const Text('To Sign In')),
                    ]);
                return;
              }
              context.push('/signIn');
              break;
            case SignUpError():
              context.showErrorDialog(
                title: 'Sign up failed',
                message: state.message,
              );
              break;
            case SignUpFirebaseSuccess():
              context.read<SignUpCubit>().signUp(
                    SignUpInput(
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                    state.userCredential,
                  );
              break;
            case SignUpFirebaseError():
              context.showErrorDialog(
                title: 'Sign up failed',
                message: state.message,
                onRetry: () => context.read<SignUpCubit>().firebaseEmailSignUp(
                      SignUpInput(
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    ),
              );
              break;
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sign Up'),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        enabled: (state is! SignUpLoading),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }

                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }

                          if (value.length > 30) {
                            return 'Username must be less than 30 characters';
                          }

                          return null;
                        },
                        onEditingComplete: () {
                          _emailFocusNode.requestFocus();
                        },
                        decoration: const InputDecoration()
                            .applyDefaults(context.theme.inputDecorationTheme)
                            .copyWith(labelText: 'Username'),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        enabled: (state is! SignUpLoading),
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
                        onEditingComplete: () {
                          _passwordFocusNode.requestFocus();
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
                        enabled: (state is! SignUpLoading),
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

                          if (!value
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'Password must contain at least one special character';
                          }

                          return null;
                        },
                        obscureText: _obscureText,
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
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignUpCubit>().firebaseEmailSignUp(
                                  SignUpInput(
                                    username: _usernameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                        child: (state is SignUpLoading)
                            ? CircularProgressIndicator(
                                color: context.theme.colorScheme.onPrimary,
                              )
                            : const Text('Sign up'),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: () {
                              final currentPath = context.currentPath;

                              if (currentPath.pathSegments
                                  .contains('firstTime')) {
                                context.push('/firstTime/signIn');
                              } else {
                                context.push('/signIn');
                              }
                            },
                            child: Text(
                              'Sign in',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: context.theme.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      // const SizedBox(
                      //   width: 8,
                      // ),
                      // GestureDetector(
                      //     onTap: () {
                      //       final currentPath = context.currentPath;
                      //
                      //       if (currentPath.pathSegments
                      //           .contains('firstTime')) {
                      //         context.push('/firstTime/signIn');
                      //       } else {
                      //         context.push('/signIn');
                      //       }
                      //     },
                      //     child: Text('Sign in')),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
