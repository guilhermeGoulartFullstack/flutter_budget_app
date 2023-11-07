import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DetailedServiceCard extends StatelessWidget {
  const DetailedServiceCard({super.key, required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 300,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.primaryColor,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Center(
                  child: Text(
                service.service,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              )),
            ),
            const Gap(20),
            Container(
              height: 160,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    service.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Container(
              width: 150,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Center(
                child: Text(
                  "R\$ ${service.value.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
