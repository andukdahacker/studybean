import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/firebase_auth_service.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._firebaseAuthService)
      : super(ForgotPasswordInitial());

  final FirebaseAuthService _firebaseAuthService;

  Future<void> forgotPassword(String email) async {
    try {
      emit(ForgotPasswordLoading());
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
      emit(ForgotPasswordSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ForgotPasswordError(error: e));
    }
  }
}
