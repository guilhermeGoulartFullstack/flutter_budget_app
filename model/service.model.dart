import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String description;
  final String service;
  final double value;

  const ServiceModel({
    required this.id,
    required this.description,
    required this.service,
    required this.value,
  });

  toJson() {
    return {
      "id": id,
      "description": description,
      "service": service,
      "value": value,
    };
  }

  factory ServiceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ServiceModel(
      id: document.id,
      description: data["description"],
      service: data["service"],
      value: double.parse(data["value"].toString()),
    );
  }

  Map<String, dynamic> fromServiceModel({required ServiceModel model}) {
    return {
      'service': model.service,
      'description': model.description,
      'value': model.value,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      description: json['description'] as String,
      service: json['service'] as String,
      value: json['value'] as double,
    );
  }
}
