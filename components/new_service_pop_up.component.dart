import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/firebase/firebase_service.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NewServicePopUp extends StatefulWidget {
  const NewServicePopUp({
    super.key,
    required this.screenSize,
  });
  final Size screenSize;

  @override
  State<NewServicePopUp> createState() => _NewServicePopUpState();
}

class _NewServicePopUpState extends State<NewServicePopUp> {
  final newServiceTextController = TextEditingController();
  final newDescriptionTextController = TextEditingController();
  final newValueTextController = TextEditingController();

  final FirebaseServiceRepository serviceController =
      Get.put(FirebaseServiceRepository());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryColor,
      insetPadding:
          EdgeInsets.symmetric(horizontal: widget.screenSize.width * 0.15),
      content: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(9))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Text(
                  "Título",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              controller: newServiceTextController,
            ),
            const Gap(20),
            const Row(
              children: [
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              controller: newDescriptionTextController,
            ),
            const Gap(20),
            const Row(
              children: [
                Text(
                  "Valor",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              controller: newValueTextController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            const Gap(70),
            Container(
              height: 45,
              width: 180,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  color: Colors.white),
              child: TextButton(
                onPressed: () {
                  if (serviceController.serviceList.any((service) {
                    return service.service == newServiceTextController.text;
                  })) {
                    Fluttertoast.showToast(
                      msg: "Serviço já cadastrado",
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    final bool serviceOk =
                        newServiceTextController.text.isNotEmpty;
                    final bool descriptionOk =
                        newDescriptionTextController.text.trim().isNotEmpty;
                    final bool valueOk = newValueTextController.text.isNotEmpty;

                    if (serviceOk && descriptionOk && valueOk) {
                      serviceController.add(
                        service: newServiceTextController.text,
                        description: newDescriptionTextController.text,
                        value: double.parse(newValueTextController.text),
                      );
                      serviceController.forceFetchServices();
                      Navigator.of(context).pop();
                    } else {
                      if (!serviceOk) {
                        Fluttertoast.showToast(
                          msg: "Serviço não deve ser vazio",
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                      if (!descriptionOk) {
                        Fluttertoast.showToast(
                          msg: "Descrição não deve ser vazio",
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                      if (!valueOk) {
                        Fluttertoast.showToast(
                          msg: "Valor não pode ser vazio",
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  "Adicionar",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
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
