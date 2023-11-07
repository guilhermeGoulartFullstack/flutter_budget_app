import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String id;
  final String sign;

  const ClientModel({
    required this.id,
    required this.sign,
  });

  toJson() {
    return {
      "id": id,
      "sign": sign,
    };
  }

  factory ClientModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ClientModel(
      id: document.id,
      sign: data["sign"],
    );
  }
}
