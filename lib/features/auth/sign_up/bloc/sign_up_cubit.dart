import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/exceptions/http_exception.dart';
import 'package:studybean/features/auth/models/sign_up_input.dart';
import 'package:studybean/features/auth/repository/auth_repository.dart';
import 'package:studybean/features/auth/services/firebase_auth_service.dart';

import '../../models/user.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository, this._firebaseAuthService)
      : super(SignUpInitial());

  final AuthRepository _authRepository;
  final FirebaseAuthService _firebaseAuthService;

  Future<void> firebaseEmailSignUp(SignUpInput input) async {
    try {
      emit(SignUpLoading());
      final userCredential =
          await _firebaseAuthService.signUpWithEmailAndPassword(
        input.email,
        input.password,
      );

      emit(SignUpFirebaseSuccess(userCredential: userCredential));
    } on firebase_auth.FirebaseAuthException catch (e, stackTrace) {
      addError(e, stackTrace);
      switch (e.code) {
        case 'email-already-in-use':
          emit(SignUpFirebaseError(
              message: e.message ?? 'Email already in use'));
          break;
        case 'invalid-email':
          emit(SignUpFirebaseError(
              message: e.message ?? 'Invalid email address'));
          break;
        case 'weak-password':
          emit(SignUpFirebaseError(
              message: e.message ?? 'Password is not strong enough'));
          break;
        case 'operation-not-allowed':
          emit(SignUpFirebaseError(
            message: e.message ?? 'Operation not allowed',
          ));
          break;
        case 'too-many-requests':
          emit(SignUpFirebaseError(
            message: e.message ?? 'Too many requests',
          ));
          break;
        default:
          emit(SignUpFirebaseError(
              message: 'Something went wrong, please try again!'));
          break;
      }
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignUpError(message: e.toString()));
    }
  }

  Future<void> signUp(SignUpInput input, firebase_auth.UserCredential credential) async {
    try {
      final result = await _authRepository.signUp(input);

      final emailVerified = credential.user?.emailVerified ?? false;

      emit(SignUpSuccess(user: result.user, isEmailVerified: emailVerified));
    } on APIException catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignUpError(message: e.message));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignUpError(message: e.toString()));
    }
  }
}
