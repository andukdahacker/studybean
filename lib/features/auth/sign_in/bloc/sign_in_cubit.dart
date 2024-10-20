import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/exceptions/http_exception.dart';
import 'package:studybean/common/services/shared_preference_service.dart';
import 'package:studybean/features/auth/models/sign_in_input.dart';
import 'package:studybean/features/auth/repository/auth_local_repository.dart';
import 'package:studybean/features/auth/repository/auth_repository.dart';

import '../../models/user.dart';
import '../../services/firebase_auth_service.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._firebaseAuthService,
    this._authRepository,
    this._sharedPreferenceService,
    this._authLocalRepository,
  ) : super(SignInInitial());

  final FirebaseAuthService _firebaseAuthService;
  final AuthRepository _authRepository;
  final SharedPreferenceService _sharedPreferenceService;
  final AuthLocalRepository _authLocalRepository;

  Future<void> firebaseSignInWithEmail(SignInInput input) async {
    try {
      emit(SignInLoading());
      final credential = await _firebaseAuthService.signInWithEmailAndPassword(
          input.email, input.password);

      final idToken = await credential.user?.getIdToken();

      if (idToken == null) {
        emit(SignInFirebaseError(message: 'Failed to get id token'));
        return;
      }

      emit(SignInFirebaseSuccess(token: idToken));
    } on firebase_auth.FirebaseAuthException catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignInFirebaseError(message: e.message ?? 'Unknown error'));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignInFirebaseError(
          message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> signInWithEmail(String token) async {
    try {
      final response = await _authRepository.signIn(token);

      await _sharedPreferenceService.setToken(response.token);

      await _authLocalRepository.setUser(response.user);

      emit(SignInSuccess(user: response.user));
    } on APIException catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignInError(message: e.message));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SignInError(message: 'Something went wrong. Please try again'));
    }
  }
}
