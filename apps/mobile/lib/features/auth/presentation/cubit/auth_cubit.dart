import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/features/auth/data/auth_repository.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await _repository.login(email, password);
      final message = result['message']?.toString() ?? 'Login successful';
      if (result.containsKey('isConfirmed') && result['isConfirmed'] == false) {
        emit(AuthEmailConfirmRequired(email: email, message: message));
      } else {
        await _saveAuth(email: email);
        emit(AuthLoginSuccess(message));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> register(String email, String password, String dateOfBirth) async {
    emit(AuthLoading());
    try {
      final result = await _repository.register(email, password, dateOfBirth);
      final message = result['message']?.toString() ?? 'Registration successful';
      emit(AuthRegisterSuccess(message));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> confirmEmail(String email, String code) async {
    emit(AuthLoading());
    try {
      final result = await _repository.confirmEmail(email, code);
      final message = result['message']?.toString() ?? 'Email confirmed';
      await _saveAuth(email: email);
      emit(AuthEmailConfirmed(message));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isGuestKey, true);
    await prefs.setBool(AppConstants.isLoggedInKey, false);
    emit(AuthLoginSuccess('Guest'));
  }

  Future<void> resendConfirmation(String email) async {
    emit(AuthLoading());
    try {
      final result = await _repository.resendConfirmation(email);
      final message = result['message']?.toString() ?? 'Confirmation resent';
      emit(AuthResendSuccess(message));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      final result = await _repository.forgotPassword(email);
      final message = result['message']?.toString() ?? 'Reset link sent to your email';
      emit(AuthForgotPasswordSuccess(message));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.isGuestKey);
    await prefs.remove(AppConstants.isLoggedInKey);
    await prefs.remove(AppConstants.userEmailKey);
    await prefs.remove(AppConstants.tokenKey);
    emit(AuthInitial());
  }

  void reset() => emit(AuthInitial());

  Future<void> _saveAuth({String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isLoggedInKey, true);
    await prefs.setBool(AppConstants.isGuestKey, false);
    if (email != null) {
      await prefs.setString(AppConstants.userEmailKey, email);
    }
  }
}
