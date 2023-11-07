import 'package:app_emerson/enum/situation.enum.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String sign;
  final String description;
  SituationEnum situation;
  final int totalKm;
  final double totalValue;
  final double additionalValue;
  final List<ServiceModel> serviceList;

  BudgetModel({
    required this.id,
    required this.sign,
    required this.situation,
    required this.totalKm,
    required this.totalValue,
    required this.additionalValue,
    required this.serviceList,
    required this.description,
  });

  toJson() {
    return {
      "id": id,
      "sign": sign,
      "situation": situation,
      "description": description,
      "totalKm": totalKm,
      "totalValue": totalValue,
      "additionalValue": additionalValue,
      "servicesList": serviceList.map((e) => e.toJson()).toList()
    };
  }

  factory BudgetModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    int index = 1;
    List<ServiceModel> newList =
        (data["serviceList"] as List<dynamic>).map((service) {
      final teste = ServiceModel(
          id: index.toString(),
          description: service["description"],
          service: service["service"],
          value: double.parse(service["value"].toString()));
      index++;
      return teste;
    }).toList();

    return BudgetModel(
      id: document.id,
      sign: data["sign"],
      description: data["description"],
      situation: EnumConverter.situationFromJson(data["situation"]),
      totalKm: data["totalKm"],
      totalValue: double.parse(data["totalValue"].toString()),
      additionalValue: double.parse(data["additionalValue"].toString()),
      serviceList: newList,
    );
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final List<ServiceModel> serviceList =
        (json['serviceList'] as List<dynamic>).map((serviceData) {
      return ServiceModel.fromJson(serviceData);
    }).toList();

    return BudgetModel(
      id: json['id'] as String,
      sign: json['sign'] as String,
      situation: EnumConverter.situationFromJson(json['situation']),
      totalKm: json['totalKm'] as int,
      totalValue: json['totalValue'] as double,
      additionalValue: json['additionalValue'] as double,
      description: json['description'] as String,
      serviceList: serviceList,
    );
  }
}
