// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked_services/stacked_services.dart';

import '../viewmodels/auth_view_model.dart';
import '../viewmodels/chat_view_model.dart';
import 'modules/firebase_module.dart';
import '../services/firebase_service.dart';
import '../viewmodels/splash_view_model.dart';
import 'modules/stacked_service_module.dart';

/// Environment names
const _prod = 'prod';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final stackedServiceModule = _$StackedServiceModule();
  final firebaseModule = _$FirebaseModule();
  gh.lazySingleton<AuthViewModel>(() => AuthViewModel());
  gh.lazySingleton<ChatViewModel>(() => ChatViewModel());
  gh.lazySingleton<DialogService>(() => stackedServiceModule.dialogService);
  gh.lazySingleton<FirebaseAuth>(() => firebaseModule.firebaseAuth);
  gh.lazySingleton<FirebaseFirestore>(() => firebaseModule.firebaseStore);
  gh.lazySingleton<FirebaseService>(() => FirebaseService(),
      registerFor: {_prod});
  gh.lazySingleton<FirebaseStorage>(() => firebaseModule.fireStorage);
  gh.lazySingleton<GoogleSignIn>(() => firebaseModule.googleSignIn);
  gh.lazySingleton<NavigationService>(
      () => stackedServiceModule.navigationService);
  gh.lazySingleton<SnackbarService>(() => stackedServiceModule.snackBarService);
  gh.lazySingleton<SplashViewModel>(() => SplashViewModel());
  return get;
}

class _$StackedServiceModule extends StackedServiceModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackBarService => SnackbarService();
}

class _$FirebaseModule extends FirebaseModule {}
