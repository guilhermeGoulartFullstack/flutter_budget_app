import 'package:app_emerson/components/card_switch.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/firebase/firebase_service.repository.dart';
import 'package:app_emerson/mobx/service_card.mobx.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ServiceCard extends StatefulWidget {
  const ServiceCard({
    super.key,
    required this.serviceModel,
    required this.isEven,
    required this.screenSize,
  });
  final ServiceModel serviceModel;
  final bool isEven;
  final Size screenSize;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final FirebaseServiceRepository serviceController =
      Get.put(FirebaseServiceRepository());

  final ServiceCardMobx mobx = ServiceCardMobx();

  @override
  Widget build(BuildContext context) {
    final serviceTextController =
        TextEditingController(text: widget.serviceModel.service);
    final descriptionTextController =
        TextEditingController(text: widget.serviceModel.description);
    final valueTextController = TextEditingController(
        text: widget.serviceModel.value.toStringAsFixed(2));

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: (widget.isEven ? Colors.white : AppColors.primaryColor),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(5, 5),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.only(right: 22, left: 22, top: 20),
        child: Observer(
          builder: (context) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      readOnly: !mobx.isEditing,
                      controller: serviceTextController,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: (widget.isEven
                            ? Colors.white
                            : AppColors.terciaryColor),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: (widget.isEven
                            ? AppColors.terciaryColor
                            : Colors.white),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(9))),
                      ),
                    ),
                  ),
                  Gap(40),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: valueTextController,
                      readOnly: !mobx.isEditing,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: (widget.isEven
                            ? Colors.white
                            : AppColors.terciaryColor),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: (widget.isEven
                            ? AppColors.terciaryColor
                            : Colors.white),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(9))),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              SizedBox(
                height: 90,
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  readOnly: !mobx.isEditing,
                  controller: descriptionTextController,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: (widget.isEven
                        ? Colors.white
                        : AppColors.terciaryColor),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: (widget.isEven
                        ? AppColors.terciaryColor
                        : Colors.white),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                  ),
                ),
              ),
              CardSwitch(
                isEven: widget.isEven,
                deleteCallback: () async {
                  await serviceController
                      .delete(id: widget.serviceModel.id)
                      .whenComplete(() async {
                    mobx.changeEditing();
                    await serviceController.forceFetchServices();
                  });
                },
                updateCallback: () async {
                  if (serviceController.serviceList.any((service) {
                    return (service.service == serviceTextController.text &&
                        !(service.id == widget.serviceModel.id));
                  })) {
                    Fluttertoast.showToast(
                      msg: "Serviço já cadastrado",
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    await serviceController
                        .put(
                            id: widget.serviceModel.id,
                            service: serviceTextController.text,
                            description: descriptionTextController.text,
                            value: double.parse(valueTextController.text))
                        .whenComplete(() async {
                      mobx.changeEditing();
                      await serviceController.forceFetchServices();
                    });
                  }
                },
                changeEditingCallback: () {
                  mobx.changeEditing();
                },
                isEditing: mobx.isEditing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
