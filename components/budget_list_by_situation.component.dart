import 'package:app_emerson/components/budget_card.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/enum/situation.enum.dart';
import 'package:app_emerson/firebase/firebase_budget.repository.dart';
import 'package:app_emerson/model/budget.model.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BudgetListBySituation extends StatefulWidget {
  BudgetListBySituation({
    super.key,
    required this.title,
    required this.budgetList,
    required this.situation,
    required this.screenSize,
    this.isOpen = true,
    required this.scrollController,
  });
  final String title;
  final SituationEnum situation;
  final Size screenSize;
  final List<BudgetModel> budgetList;
  final ScrollController scrollController;
  bool isOpen;

  @override
  State<BudgetListBySituation> createState() => _BudgetListBySituationState();
}

class _BudgetListBySituationState extends State<BudgetListBySituation> {
  final budgetList = <BudgetModel>[].obs;

  final FirebaseBudgetRepository budgetController =
      Get.put(FirebaseBudgetRepository());

  void teste(List<BudgetModel> a) {
    budgetList.assignAll(widget.budgetList);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      teste(widget.budgetList);
      return DragTarget<BudgetModel>(
        onAccept: (data) async {
          if (data.situation != widget.situation) {
            await budgetController.changeBudget(
                id: data.id,
                situation: widget.situation,
                totalValue: data.totalValue,
                additionalValue: data.additionalValue,
                serviceList: data.serviceList);
            await budgetController.forceFetchBudgets();
          }
        },
        builder: (context, accepted, __) => Container(
            decoration: BoxDecoration(
              boxShadow: accepted.isEmpty
                  ? [
                      const BoxShadow(
                        color: Colors.black,
                        offset: Offset(5, 5),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                  : [
                      const BoxShadow(
                        color: Color.fromARGB(255, 124, 124, 124),
                        offset: Offset(0, 0),
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                        inset: true,
                      ),
                    ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(20),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Gap(5),
                      IconButton(
                        onPressed: () {
                          widget.isOpen = !widget.isOpen;
                          setState(() {});
                        },
                        icon: Icon(widget.isOpen
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                      ),
                      const Gap(20),
                    ],
                  ),
                  widget.isOpen
                      ? (budgetList.isNotEmpty
                          ? SizedBox(
                              height: 380,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: budgetList.length,
                                itemBuilder: (c, index) {
                                  final budgetModel = budgetList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: BudgetCard(
                                      budget: budgetModel,
                                      scrollController: widget.scrollController,
                                      screenSize: widget.screenSize,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(
                              height: 150,
                              child: const Center(
                                child: Text(
                                  "Nenhum orçamento neste setor",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ))
                      : const SizedBox.shrink(),
                  Gap(5),
                ],
              ),
            )),
      );
      // }
    });
  }
}
