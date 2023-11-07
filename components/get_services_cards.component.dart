import 'package:app_emerson/components/detailed_service_card.component.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:flutter/material.dart';

class GetServiceCards extends StatelessWidget {
  const GetServiceCards({
    super.key,
    required this.services,
  });
  final List<ServiceModel> services;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: services
            .map((service) => DetailedServiceCard(service: service))
            .toList(),
      ),
    );
  }
}
