import 'package:app_emerson/components/animated_delete_button.component.dart';
import 'package:app_emerson/components/get_services_cards.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/firebase/firebase_budget.repository.dart';
import 'package:app_emerson/model/budget.model.dart';
import 'package:app_emerson/utils/budget_to_string.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BudgetDetails extends StatelessWidget {
  BudgetDetails({
    super.key,
    required this.budgetModel,
    required this.screenSize,
  });
  final BudgetModel budgetModel;
  final Size screenSize;

  final FirebaseBudgetRepository budgetController =
      Get.put(FirebaseBudgetRepository());

  @override
  Widget build(BuildContext context) {
    final additionalValueController =
        TextEditingController(text: budgetModel.additionalValue.toString());
    final totalValueController =
        TextEditingController(text: budgetModel.totalValue.toString());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(budgetModel.sign),
            Text("KM: ${budgetModel.totalKm.toString()}"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share(
                  budgetToStringWithDescription(
                    services: budgetModel.serviceList,
                    totalValue: budgetModel.totalValue,
                  ),
                );
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
          minHeight: screenSize.height,
          minWidth: screenSize.width,
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
                    borderRadius: BorderRadius.all(Radius.circular(19)),
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
                        child:
                            GetServiceCards(services: budgetModel.serviceList)),
                  )),
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
                      child: Container(
                        height: 160,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            budgetModel.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Row(
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
                                readOnly: true,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: additionalValueController,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
                              child: TextField(
                                readOnly: true,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: totalValueController,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
                      ],
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
                child: AnimatedDeleteButton(deleteCallback: () async {
                  await budgetController
                      .delete(id: budgetModel.id)
                      .whenComplete(() async {
                    await budgetController.forceFetchBudgets().then((_) {
                      Navigator.of(context).pop();
                    });
                  });
                }),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      Text(
                        "Voltar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
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
