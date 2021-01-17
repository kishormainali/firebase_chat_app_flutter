import 'package:injectable/injectable.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/services/firebase_service.dart';
import 'package:mvvm_architecture/views/routes/app_router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class SplashViewModel extends BaseViewModel {
  final _fireService = getIt<FirebaseService>();
  final _navigationService = getIt<NavigationService>();

  Future<void> checkUserLoggedStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = await _fireService.isLoggedIn;
    if (isLoggedIn) {
      await _navigationService.replaceWith(Routes.homeView);
    } else {
      await _navigationService.replaceWith(Routes.authView);
    }
  }
}
