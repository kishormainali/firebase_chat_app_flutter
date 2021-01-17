import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/models/UserModel.dart';
import 'package:mvvm_architecture/viewmodels/chat_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../utils/extensions/extensions.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.nonReactive(
      builder: (context, ChatViewModel model, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Chats'),
              actions: [
                IconButton(
                  icon: Icon(
                    FlutterIcons.md_log_out_ion,
                  ),
                  onPressed: model.logOut,
                )
              ],
            ),
            body: StreamBuilder<List<UserModel>>(
              stream: model.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data.isEmpty) {
                    return Center(
                      child: Text('No Users Found'),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final user = data[index];
                        return UserItem(
                          user: user,
                          onTap: model.onUserTap,
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error.toString()}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ));
      },
      viewModelBuilder: () => getIt<ChatViewModel>(),
      initialiseSpecialViewModelsOnce: true,
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
    Key key,
    @required this.user,
    @required this.onTap,
  }) : super(key: key);

  final UserModel user;
  final Function(UserModel user) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(user),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        constraints: BoxConstraints(
          minHeight: 50.0,
        ),
        decoration: BoxDecoration(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.deepOrange.withOpacity(0.8),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      user.name.shortName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 5.0,
                    child: Container(
                      width: 15.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        color: user.isActive ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      user.isActive ? 'active now' : user.activeAt.toDateMoment,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
