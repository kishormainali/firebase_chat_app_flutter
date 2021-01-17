import 'package:flutter/material.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/viewmodels/splash_view_model.dart';
import 'package:mvvm_architecture/views/routes/app_router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: () {
                getIt<NavigationService>().replaceWith(Routes.authView);
              },
              child: Text('SplashView'),
            ),
          ),
        );
      },
      viewModelBuilder: () => getIt<SplashViewModel>(),
      onModelReady: (model) => model.checkUserLoggedStatus(),
      fireOnModelReadyOnce: true,
    );
  }
}
