import 'package:auto_route/auto_route_annotations.dart';
import 'package:mvvm_architecture/views/auth/auth_view.dart';
import 'package:mvvm_architecture/views/chat/chat_view.dart';
import 'package:mvvm_architecture/views/chat/home_view.dart';
import 'package:mvvm_architecture/views/chat/profile_view.dart';
import 'package:mvvm_architecture/views/splash_view.dart';

import 'app_router.gr.dart';

@MaterialAutoRouter(
  routes: [
    AutoRoute(page: SplashView, initial: true),
    AutoRoute(page: AuthView),
    AutoRoute(page: HomeView),
    AutoRoute(page: ChatView),
    AutoRoute(page: ProfileView)
  ],
)
class $AppRouter {}
