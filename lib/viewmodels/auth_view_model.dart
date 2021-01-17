import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/services/firebase_service.dart';
import 'package:mvvm_architecture/views/routes/app_router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class AuthViewModel extends BaseViewModel {
  final _fireService = getIt<FirebaseService>();
  final _navigationService = getIt<NavigationService>();

  final emailKey = GlobalKey<FormFieldState>();
  final passwordKey = GlobalKey<FormFieldState>();
  final nameKey = GlobalKey<FormFieldState>();

  bool _togglePassword = true;

  bool get togglePassword => _togglePassword;

  bool _signUp = false;

  bool get isSignUp => _signUp;

  void toggle() {
    _togglePassword = !togglePassword;
    notifyListeners();
  }

  void login() async {
    if (hasError) clearErrors();
    if (emailKey.currentState.validate() && passwordKey.currentState.validate()) {
      final email = emailKey.currentState.value;
      final password = passwordKey.currentState.value;
      setBusyForObject("login", true);
      try {
        final response = await _fireService.login(email: email, password: password);
        if (response) {
          _navigationService.replaceWith(Routes.homeView);
        }
      } catch (e) {
        setError(e.toString());
      }
      setBusyForObject("login", false);
    }
  }

  void googleSignIn() async {
    clearFields();
    if (hasError) clearErrors();
    setBusyForObject("google", true);

    try {
      final response = await _fireService.signInWithGoogle();
      if (response) {
        _navigationService.replaceWith(Routes.homeView);
      }
    } catch (e) {
      setError(e.toString());
    }
    setBusyForObject("google", false);
  }

  void signUp() async {
    if (hasError) clearErrors();
    if (nameKey.currentState.validate() && emailKey.currentState.validate() && passwordKey.currentState.validate()) {
      final name = nameKey.currentState.value;
      final email = emailKey.currentState.value;
      final password = passwordKey.currentState.value;
      setBusyForObject("login", true);

      try {
        final response = await _fireService.signUp(name: name, email: email, password: password);
        if (response) {
          _navigationService.replaceWith(Routes.homeView);
        }
      } catch (e) {
        setError(e.toString());
      }
      setBusyForObject("login", true);
    }
  }

  void toggleSignUp() {
    clearErrors();
    _signUp = !_signUp;
    notifyListeners();
  }

  void clearFields() {
    if (isSignUp) nameKey.currentState.reset();
    emailKey.currentState.reset();
    passwordKey.currentState.reset();
  }
}
