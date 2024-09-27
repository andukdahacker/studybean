import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/auth/change_password/bloc/change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _currentPasswordController;
  late final FocusNode _currentPasswordFocusNode;
  late final TextEditingController _newPasswordController;
  late final FocusNode _passwordFocusNode;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _confirmPasswordFocusNode;

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _currentPasswordController = TextEditingController();
    _currentPasswordFocusNode = FocusNode();
    _newPasswordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _confirmPasswordController = TextEditingController();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change password'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                    controller: _currentPasswordController,
                    focusNode: _currentPasswordFocusNode,
                    obscureText: _obscureText3,
                    decoration: const InputDecoration()
                        .applyDefaults(context.theme.inputDecorationTheme)
                        .copyWith(
                          labelText: 'Current password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText3 = !_obscureText3;
                              });
                            },
                            icon: Icon(_obscureText3
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
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
                    }),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _newPasswordController,
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

                    if(_currentPasswordController.text == value) {
                      return 'New password cannot be the same as the current password';
                    }

                    return null;
                  },
                  decoration: const InputDecoration()
                      .applyDefaults(context.theme.inputDecorationTheme)
                      .copyWith(
                        labelText: 'New password',
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
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: _obscureText2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please reenter your new password';
                    }

                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                  decoration: const InputDecoration()
                      .applyDefaults(context.theme.inputDecorationTheme)
                      .copyWith(
                        labelText: 'Confirm new password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                          icon: Icon(_obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                ),
                const SizedBox(
                  height: 32,
                ),
                BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                  listener: (context, state) {
                    switch (state) {
                      case ChangePasswordInitial():
                      case ChangePasswordLoading():
                        break;
                      case ChangePasswordSuccess():
                        context.pop();
                        break;
                      case ChangePasswordError():
                        context.showErrorDialog(
                            title: 'Error', message: state.error.toString());
                        break;
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          context.read<ChangePasswordCubit>().changePassword(
                                _currentPasswordController.text,
                                _newPasswordController.text,
                              );
                        }
                      },
                      child: state is ChangePasswordLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Change password'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
