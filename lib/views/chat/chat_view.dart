import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/models/UserModel.dart';
import 'package:mvvm_architecture/models/chat_model.dart';
import 'package:mvvm_architecture/viewmodels/chat_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../utils/extensions/extensions.dart';

class ChatView extends StatelessWidget {
  final UserModel userModel;

  const ChatView({Key key, @required this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.nonReactive(
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${userModel.name}'),
                    const SizedBox(height: 3.0),
                    Text(
                      '${userModel.isActive ? 'active now' : userModel.activeAt.toDateMoment}',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<ChatModel>>(
                      stream: model.getUserChat(friendId: userModel.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('${snapshot.error.toString()}'));
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data.isEmpty) {
                            return Center(
                              child: Text('No Chats Found with ${userModel.name}'),
                            );
                          }
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: ListView.builder(
                                key: PageStorageKey("chat-page-key"),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final chat = data[index];
                                  final isMe = chat.uid == model.userId;
                                  final isFirstItem = _getFirstMessage(data, index);
                                  final isLastItem = _getLastMessage(data, index);
                                  return ChatItem(
                                    chat: chat,
                                    isMe: isMe,
                                    isFirstItem: isFirstItem,
                                    isLastItem: isLastItem,
                                  );
                                }),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: model.chatController,
                            autocorrect: false,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) => model.onSendButtonPressed(userModel),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          )),
                          IconButton(
                            iconSize: 46.0,
                            icon: Icon(
                              FlutterIcons.send_circle_mco,
                            ),
                            onPressed: () {
                              model.onSendButtonPressed(userModel);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        },
        viewModelBuilder: () => getIt<ChatViewModel>());
  }

  _getFirstMessage(List<ChatModel> chatItems, int index) {
    return (chatItems[index].peerId != chatItems[(index - 1 < 0 ? 0 : index - 1)].peerId) || index == 0;
  }

  _getLastMessage(List<ChatModel> chatItems, int index) {
    int maxItem = chatItems.length - 1;
    return (chatItems[index].peerId != chatItems[(index + 1 > maxItem ? maxItem : index + 1)].peerId) ||
        index == maxItem;
  }
}

class ChatItem extends StatelessWidget {
  final ChatModel chat;
  final bool isMe;
  final bool isFirstItem;
  final bool isLastItem;

  const ChatItem({
    Key key,
    @required this.chat,
    @required this.isMe,
    @required this.isFirstItem,
    @required this.isLastItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isFirstItem && !isMe
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      chat.username.shortName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                width: 50.0,
                height: 50.0,
              ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .6,
          ),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  color: Colors.blue,
                ),
                child: Text(
                  '${chat.message}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isLastItem)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${chat.createdAt.toTime}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
