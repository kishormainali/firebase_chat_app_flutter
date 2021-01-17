import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final bool isActive;
  final int activeAt;
  final String createdAt;

  const UserModel({
    this.uid,
    this.name,
    this.email,
    this.isActive,
    this.activeAt,
    this.createdAt,
  });

  UserModel copyWith({
    String uid,
    String name,
    String email,
    bool isActive,
    int activeAt,
    String createdAt,
  }) {
    if ((uid == null || identical(uid, this.uid)) &&
        (name == null || identical(name, this.name)) &&
        (email == null || identical(email, this.email)) &&
        (isActive == null || identical(isActive, this.isActive)) &&
        (activeAt == null || identical(activeAt, this.activeAt)) &&
        (createdAt == null || identical(createdAt, this.createdAt))) {
      return this;
    }

    return new UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      activeAt: activeAt ?? this.activeAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool get stringify => true;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return new UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isActive: map['isActive'] as bool,
      activeAt: map['activeAt'] as int,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'isActive': this.isActive,
      'activeAt': this.activeAt,
      'createdAt': this.createdAt,
    };
  }

  @override
  List<Object> get props => [
        uid,
        name,
        email,
        isActive,
        activeAt,
        createdAt,
      ];
}
