import 'package:app_emerson/components/text_box.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/model/budget.model.dart';
import 'package:app_emerson/screens/budget_details.screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard(
      {super.key,
      required this.budget,
      required this.scrollController,
      required this.screenSize});
  final BudgetModel budget;
  final ScrollController scrollController;
  final Size screenSize;

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  double offsetY = 0.0;
  bool shouldAnimate = true;
  bool shouldUpdate = false;
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return LongPressDraggable(
      delay: const Duration(milliseconds: 250),
      maxSimultaneousDrags: 1,
      onDragUpdate: (details) {
        offsetY = details.globalPosition.dy;
        if (details.globalPosition.dy < screen.height * 0.15 && shouldAnimate) {
          shouldAnimate = false;
          shouldUpdate = true;
          widget.scrollController.animateTo(0,
              curve: Curves.easeInCubic,
              duration: Duration(milliseconds: 1000));
        } else if (details.globalPosition.dy > screen.height * 0.85 &&
            shouldAnimate) {
          shouldAnimate = false;
          shouldUpdate = true;
          widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              curve: Curves.easeInCubic,
              duration: Duration(milliseconds: 1000));
        } else {
          if ((details.globalPosition.dy < screen.height * 0.85 &&
                  details.globalPosition.dy > screen.height * 0.15) &&
              shouldUpdate) {
            shouldAnimate = true;
            shouldUpdate = false;
            widget.scrollController.animateTo(widget.scrollController.offset,
                curve: Curves.linear, duration: Duration(milliseconds: 1));
          }
        }
      },
      data: widget.budget,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 0.5,
          child: Container(
            width: 250,
            height: 360,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              color: AppColors.primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextBox(
                        text: widget.budget.sign,
                        color: AppColors.secondaryColor,
                      ),
                      CustomTextBox(
                        text: "R\$${widget.budget.totalValue.toString()}",
                        color: AppColors.secondaryColor,
                      ),
                    ],
                  ),
                  const Gap(10),
                  const Text(
                    "Serviços",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      color: AppColors.secondaryColor,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: widget.budget.serviceList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(9)),
                            color: (index % 2 == 0)
                                ? AppColors.terciaryColor
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              widget.budget.serviceList[index].service,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "Descrição",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      height: 120,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        color: AppColors.secondaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Gap(16),
                              Text(
                                widget.budget.description,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Gap(16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      child: GestureDetector(
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return BudgetDetails(
                budgetModel: widget.budget,
                screenSize: widget.screenSize,
              );
            }),
          );
        },
        child: Container(
          width: 250,
          height: 360,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: AppColors.primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextBox(
                      text: widget.budget.sign,
                      color: AppColors.secondaryColor,
                    ),
                    CustomTextBox(
                      text: "R\$${widget.budget.totalValue.toString()}",
                      color: AppColors.secondaryColor,
                    ),
                  ],
                ),
                const Gap(10),
                const Text(
                  "Serviços",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: AppColors.secondaryColor,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.budget.serviceList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(9)),
                          color:
                              (index % 2 == 0) ? AppColors.terciaryColor : null,
                        ),
                        child: Center(
                          child: Text(
                            widget.budget.serviceList[index].service,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Gap(10),
                const Text(
                  "Descrição",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      color: AppColors.secondaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(16),
                            Text(
                              widget.budget.description,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Gap(16),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
