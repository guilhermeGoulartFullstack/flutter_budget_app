import 'package:app_emerson/components/animated_delete_button.component.dart';
import 'package:app_emerson/components/get_services_cards.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/enum/situation.enum.dart';
import 'package:app_emerson/firebase/firebase_budget.repository.dart';
import 'package:app_emerson/mobx/budget_details.mobx.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:app_emerson/utils/budget_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class NewBudgetFinalization extends StatefulWidget {
  const NewBudgetFinalization({
    super.key,
    required this.budgetServices,
    required this.client,
    required this.totalKm,
    required this.screenSize,
  });
  final List<ServiceModel> budgetServices;
  final String client;
  final int totalKm;
  final Size screenSize;

  @override
  State<NewBudgetFinalization> createState() => _NewBudgetFinalizationState();
}

class _NewBudgetFinalizationState extends State<NewBudgetFinalization> {
  final additionalValueController = TextEditingController();
  final FirebaseBudgetRepository budgetController =
      Get.put(FirebaseBudgetRepository());

  late double originalValue;
  final mobx = BudgetDetailsMobx();

  @override
  void initState() {
    originalValue = widget.budgetServices
        .map((e) => e.value)
        .reduce((value, element) => value + element);
    mobx.setTotalValue(originalValue: originalValue, additionalValue: 0);
    super.initState();
  }

  final newDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share(budgetToStringWithDescription(
                    services: widget.budgetServices,
                    totalValue: mobx.totalValue));
              },
              icon: const Icon(Icons.share))
        ],
        backgroundColor: AppColors.secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: widget.screenSize.height,
          minWidth: widget.screenSize.width,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(5, 5),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: GetServiceCards(services: widget.budgetServices)),
                ),
              ),
              const Gap(20),
              Container(
                padding: const EdgeInsets.all(20),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.primaryColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(5, 5),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Descrição",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 160,
                        child: Center(
                          child: TextField(
                            onChanged: (_) {
                              setState(() {});
                            },
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            expands: true,
                            maxLines: null,
                            controller: newDescriptionController,
                            decoration: const InputDecoration(
                              fillColor: AppColors.secondaryColor,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Observer(
                      builder: (context) => _Values(
                        controller: additionalValueController,
                        totalValue: mobx.totalValue,
                        setTotalValue: () {
                          mobx.setTotalValue(
                              originalValue: originalValue,
                              additionalValue:
                                  additionalValueController.text.isEmpty
                                      ? 0
                                      : double.parse(
                                          additionalValueController.text));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.secondaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 10, horizontal: screenSize.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.terciaryColor,
                ),
                child: AnimatedDeleteButton(deleteCallback: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
              ),
              TextButton(
                onPressed: newDescriptionController.text.trim().isNotEmpty
                    ? () async {
                        await budgetController.add(
                          sign: widget.client,
                          situation: SituationEnum.waitingForApproval,
                          totalKm: widget.totalKm,
                          totalValue: mobx.totalValue,
                          additionalValue: double.parse(
                              additionalValueController.text.isNotEmpty
                                  ? additionalValueController.text
                                  : "0"),
                          description: newDescriptionController.text,
                          serviceList: widget.budgetServices,
                        );
                        await budgetController.setCanFetchTrue();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      newDescriptionController.text.trim().isNotEmpty
                          ? Colors.green
                          : Colors.grey),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Finalizar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Values extends StatelessWidget {
  const _Values({
    required this.controller,
    required this.totalValue,
    required this.setTotalValue,
  });
  final TextEditingController controller;
  final double totalValue;
  final Function() setTotalValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              "Valor adicional",
              style: TextStyle(color: Colors.white),
            ),
            Gap(5),
            Container(
              height: 50,
              width: 130,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (value) {
                  setTotalValue();
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Adicional",
                  prefix: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      "R\$",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Valor total",
              style: TextStyle(color: Colors.white),
            ),
            Gap(5),
            Container(
              height: 50,
              width: 130,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Center(
                  child: Text(
                "R\$${totalValue.toString()}",
                style: const TextStyle(color: Colors.white),
              )),
            ),
          ],
        ),
      ],
    );
  }
}

String budgetToString(
    {required List<ServiceModel> services, required double totalValue}) {
  List<String> servicesNames = services
      .map((e) => "**${e.service}* => R\$${e.value.toStringAsFixed(2)}")
      .toList();

  String servicesToString = servicesNames.join("\n");

  return "Segue o orçamento feito:\n\n$servicesToString\nTotal: R\$ ${totalValue.toString()}";
}
