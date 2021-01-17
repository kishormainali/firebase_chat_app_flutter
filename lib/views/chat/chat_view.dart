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
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final chat = data[index];
                                  final isMe = chat.uid == model.userId;
                                  return ChatItem(
                                    chat: chat,
                                    isMe: isMe,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: model.chatController,
                            autocorrect: false,
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
                            onPressed: () => model.onSendButtonPressed(userModel),
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
}

class ChatItem extends StatelessWidget {
  final ChatModel chat;
  final bool isMe;

  const ChatItem({
    Key key,
    @required this.chat,
    @required this.isMe,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) ...[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.deepOrange.withOpacity(0.8),
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
          ),
        ],
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
                    topLeft: isMe ? Radius.circular(20.0) : Radius.zero,
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: isMe ? Radius.zero : Radius.circular(20.0),
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
