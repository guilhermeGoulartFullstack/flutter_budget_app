import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/firebase/firebase_client.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NewClientPopUp extends StatefulWidget {
  const NewClientPopUp({
    super.key,
    required this.screenSize,
  });
  final Size screenSize;

  @override
  State<NewClientPopUp> createState() => _NewClientPopUpState();
}

class _NewClientPopUpState extends State<NewClientPopUp> {
  final newSignTextController = TextEditingController();

  final FirebaseClientRepository clientController =
      Get.put(FirebaseClientRepository());

  @override
  Widget build(BuildContext context) {
    newSignTextController.addListener(
      () {
        final text = newSignTextController.text.toUpperCase();
        newSignTextController.value = newSignTextController.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      },
    );
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
                  "Placa",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(7),
              ],
              controller: newSignTextController,
            ),
            const Gap(40),
            Container(
              height: 45,
              width: 180,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  color: Colors.white),
              child: TextButton(
                onPressed: () async {
                  if (clientController.clientList.any((client) {
                    return client.sign == newSignTextController.text;
                  })) {
                    Fluttertoast.showToast(
                      msg: "Cliente já cadastrado",
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    if (newSignTextController.text.length == 7) {
                      await clientController.add(
                        sign: newSignTextController.text,
                      );
                      clientController.forceFetchClients();
                      Fluttertoast.showToast(
                        msg: "Cliente adicionado!",
                        gravity: ToastGravity.BOTTOM,
                      );
                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Placa deve conter 7 dígitos",
                        gravity: ToastGravity.BOTTOM,
                      );
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
