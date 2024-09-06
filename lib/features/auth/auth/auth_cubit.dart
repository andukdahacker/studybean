import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/auth/repository/auth_local_repository.dart';

import '../models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authLocalRepository) : super(AuthInitial());

  final AuthLocalRepository _authLocalRepository;

  Future<void> checkAuth() async {
    try {
      emit(AuthLoading());
      final localUser = await _authLocalRepository.getUser();
      if (localUser == null) {
        emit(AuthUnauthorized());
      } else {
        emit(AuthSuccess(user: localUser));
      }
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(AuthError(message: e.toString()));
    }
  }
}