import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/auth/services/firebase_auth_service.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._firebaseAuthService)
      : super(ChangePasswordInitial());

  final FirebaseAuthService _firebaseAuthService;

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      emit(ChangePasswordLoading());
      final user = _firebaseAuthService.currentUser;

      if (user == null) {
        emit(ChangePasswordError(error: 'User not found'));
        return;
      }

      await _firebaseAuthService.signInWithEmailAndPassword(user.email ?? '', currentPassword);

      await user.updatePassword(newPassword);

      emit(ChangePasswordSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ChangePasswordError(error: e));
    }
  }
}
