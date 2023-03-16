import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String id;
  final String gender;
  final String ttl;
  final int age;

  UserModel({
    required this.name,
    required this.gender,
    required this.ttl,
    required this.id,
    required this.age,
  });

  factory UserModel.fromData(DocumentSnapshot doc) {
    return UserModel(
      name: doc.get('name') ?? "",
      id: doc.id,
      age: doc.get('age') ?? 0,
      gender: doc.get('gender'),
      ttl: doc.get('ttl'),
    );
  }
}
