import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/models/UserModel.dart';
import 'package:mvvm_architecture/models/chat_model.dart';

@prod
@lazySingleton
class FirebaseService {
  final FirebaseAuth _auth = getIt<FirebaseAuth>();
  final FirebaseFirestore _store = getIt<FirebaseFirestore>();
  final GoogleSignIn _googleSignIn = getIt<GoogleSignIn>();

  //auth
  Future<bool> login({@required String email, @required String password}) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (response.user != null) {
        await updateUserStatus(uid: response.user.uid, status: true);
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<String> getUserName(String userId) async =>
      await _store.collection("users").doc(userId).get().then((value) => value.data()['name']);

  Future<bool> signUp({
    @required String name,
    @required String email,
    @required String password,
  }) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (response.user != null) {
        await _saveUserInfo(uid: response.user.uid, name: name, email: response.user.email);
        await login(email: email, password: password);
        return Future.value(true);
      }
      return Future.value(false);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final response = await _googleSignIn.signIn();
      if (response != null) {
        final googleResult = await response.authentication;
        final credential =
            GoogleAuthProvider.credential(idToken: googleResult.idToken, accessToken: googleResult.accessToken);
        final authResult = await _auth.signInWithCredential(credential);
        await _saveUserInfo(
          uid: authResult.user.uid,
          name: authResult.user.displayName,
          email: authResult.user.email,
          isActive: true,
        );
        return Future.value(true);
      }
      return Future.value(false);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> get isLoggedIn async => _auth.currentUser != null;

  User get currentUser => _auth.currentUser;

  Future<void> logOut() async {
    await updateUserStatus(uid: currentUser.uid, status: false);
    await _auth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }
  }

  Future<void> _saveUserInfo({
    @required String uid,
    @required String name,
    @required String email,
    bool isActive = false,
  }) async {
    await _store.collection("users").doc(uid).set({
      "uid": uid,
      "name": name,
      "email": email,
      "isActive": isActive,
      "activeAt": DateTime.now().millisecondsSinceEpoch,
      "createdAt": DateTime.now().toString()
    });
  }

  Future<void> updateUserStatus({@required String uid, @required bool status}) async {
    await _store.collection("users").doc(uid).update({
      "isActive": status,
      "activeAt": DateTime.now().millisecondsSinceEpoch,
    });
  }

//chat

  Stream<List<UserModel>> getUsers(String uid) {
    return _store.collection("users").where("uid", isNotEqualTo: uid).snapshots().transform(_userTransFormer);
  }

  Stream<List<ChatModel>> getChats({@required uid, @required friendId}) {
    return _store
        .collection("chats")
        .doc(_getChatId(uid, friendId))
        .collection(_getChatId(uid, friendId))
        .snapshots()
        .transform(_chatTransformer);
  }

  Future<void> sendMessage(ChatModel chat) async {
    await _store
        .collection("chats")
        .doc(_getChatId(chat.uid, chat.peerId))
        .collection(_getChatId(chat.uid, chat.peerId))
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(chat.toMap());
  }

  StreamTransformer<QuerySnapshot, List<UserModel>> get _userTransFormer =>
      StreamTransformer.fromHandlers(handleData: (event, sink) {
        var snaps = event.docs.map((e) => e.data()).toList();
        var users = snaps.map((e) => UserModel.fromMap(e)).toList();
        sink.add(users);
      });

  StreamTransformer<QuerySnapshot, List<ChatModel>> get _chatTransformer =>
      StreamTransformer.fromHandlers(handleData: (event, sink) {
        var snaps = event.docs.map((e) => e.data()).toList();
        var chats = snaps.map((e) => ChatModel.fromMap(e)).toList();
        sink.add(chats);
      });

  String _getChatId(String uid, String peerId) {
    String chatId = '';
    if (uid.hashCode > peerId.hashCode) {
      chatId = '$peerId-$uid';
    } else {
      chatId = '$uid-$peerId';
    }
    return chatId;
  }
}
