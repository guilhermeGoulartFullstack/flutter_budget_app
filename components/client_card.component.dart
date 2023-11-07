import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:app_emerson/model/cliente.model.dart';
import 'package:app_emerson/mobx/client_card.mobx.dart';
import 'package:app_emerson/components/card_switch.component.dart';
import 'package:app_emerson/firebase/firebase_client.repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ClientCard extends StatefulWidget {
  const ClientCard({
    super.key,
    required this.clientModel,
    required this.isEven,
    required this.screenSize,
  });
  final ClientModel clientModel;
  final bool isEven;
  final Size screenSize;

  @override
  State<ClientCard> createState() => _ClientCardState();
}

class _ClientCardState extends State<ClientCard> {
  final FirebaseClientRepository clientController =
      Get.put(FirebaseClientRepository());

  final ClientCardMobx mobx = ClientCardMobx();

  @override
  Widget build(BuildContext context) {
    final signTextController =
        TextEditingController(text: widget.clientModel.sign);

    signTextController.addListener(
      () {
        final text = signTextController.text.toUpperCase();
        signTextController.value = signTextController.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      },
    );

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
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Observer(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  // height: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    readOnly: !mobx.isEditing,
                    controller: signTextController,
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(7),
                    ],
                  ),
                ),
                CardSwitch(
                  isEven: widget.isEven,
                  deleteCallback: () async {
                    await clientController
                        .delete(id: widget.clientModel.id)
                        .whenComplete(() async {
                      mobx.changeEditing();
                      await clientController.forceFetchClients();
                    });
                  },
                  updateCallback: () async {
                    if (clientController.clientList.any((client) {
                      return (client.sign == signTextController.text &&
                          !(client.id == widget.clientModel.id));
                    })) {
                      Fluttertoast.showToast(
                        msg: "Cliente já cadastrado",
                        gravity: ToastGravity.BOTTOM,
                      );
                    } else {
                      await clientController
                          .put(
                              id: widget.clientModel.id,
                              sign: signTextController.text)
                          .whenComplete(() async {
                        mobx.changeEditing();
                        await clientController.forceFetchClients();
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
      ),
    );
  }
}
