import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/auth/auth/auth_cubit.dart';

import '../../features/auth/models/user.dart';

extension AuthContextExtension on BuildContext {
  (bool, User?) checkAuth() {
    switch(read<AuthCubit>().state) {
      case AuthInitial():
      case AuthLoading():
      case AuthUnauthorized():
      case AuthError():
        return (false, null);
      case AuthSuccess():
        final state = read<AuthCubit>().state as AuthSuccess;
        return (true, state.user);
    }
  }
}