// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../models/UserModel.dart';
import '../auth/auth_view.dart';
import '../chat/chat_view.dart';
import '../chat/home_view.dart';
import '../chat/profile_view.dart';
import '../splash_view.dart';

class Routes {
  static const String splashView = '/';
  static const String authView = '/auth-view';
  static const String homeView = '/home-view';
  static const String chatView = '/chat-view';
  static const String profileView = '/profile-view';
  static const all = <String>{
    splashView,
    authView,
    homeView,
    chatView,
    profileView,
  };
}

class AppRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.authView, page: AuthView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.chatView, page: ChatView),
    RouteDef(Routes.profileView, page: ProfileView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashView(),
        settings: data,
      );
    },
    AuthView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AuthView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    ChatView: (data) {
      final args = data.getArgs<ChatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatView(
          key: args.key,
          userModel: args.userModel,
        ),
        settings: data,
      );
    },
    ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProfileView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ChatView arguments holder class
class ChatViewArguments {
  final Key key;
  final UserModel userModel;
  ChatViewArguments({this.key, @required this.userModel});
}
