import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/models/UserModel.dart';
import 'package:mvvm_architecture/models/chat_model.dart';
import 'package:mvvm_architecture/services/firebase_service.dart';
import 'package:mvvm_architecture/views/routes/app_router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class ChatViewModel extends BaseViewModel {
  final _fireService = getIt<FirebaseService>();
  final _navigationService = getIt<NavigationService>();
  final chatController = TextEditingController();

  String get userId => _fireService.currentUser.uid;

  Stream<List<UserModel>> getUsers() => _fireService.getUsers(_fireService.currentUser.uid);

  Stream<List<ChatModel>> getUserChat({@required String friendId}) =>
      _fireService.getChats(uid: userId, friendId: friendId);

  void sendMessage(ChatModel chat) async => await _fireService.sendMessage(chat);

  void logOut() async {
    await _fireService.logOut();
    _navigationService.replaceWith(Routes.authView);
  }

  void onUserTap(UserModel user) {
    _navigationService.navigateTo(
      Routes.chatView,
      arguments: ChatViewArguments(userModel: user),
    );
  }

  @override
  void dispose() {
    chatController?.dispose();
    super.dispose();
  }

  void onSendButtonPressed(UserModel userModel) async {
    String username = await _fireService.getUserName(userId);
    if (chatController.text.isNotEmpty) {
      final chatModel = ChatModel(
        uid: userId,
        peerId: userModel.uid,
        username: username,
        message: chatController.text.trim().toString(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      sendMessage(chatModel);
      chatController.clear();
    }
  }
}
