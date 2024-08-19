import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  String id;
  String name;
  int age;
  String address;

  News({
    required this.id,
    required this.name,
    required this.age,
    required this.address,
  });

  factory News.fromDocument(DocumentSnapshot doc) {
    return News(
      id: doc.id,
      name: doc['name'],
      age: doc['age'],
      address: doc['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'address': address,
    };
  }
}