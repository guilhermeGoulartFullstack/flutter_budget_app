import 'package:app_emerson/components/budget_list_by_situation.component.dart';
import 'package:app_emerson/components/default_error_message.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/enum/situation.enum.dart';
import 'package:app_emerson/firebase/firebase_budget.repository.dart';
import 'package:app_emerson/model/budget.model.dart';
import 'package:app_emerson/screens/create_new_budget.screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BudgetList extends StatefulWidget {
  const BudgetList({
    super.key,
    required this.screenSize,
  });
  final Size screenSize;

  @override
  State<BudgetList> createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  final FirebaseBudgetRepository budgetController =
      Get.put(FirebaseBudgetRepository());

  final scrollController = ScrollController();

  @override
  void initState() {
    budgetController.fetchBudgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text("Orçamentos"),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  budgetController.forceFetchBudgets();
                },
                icon: const Icon(Icons.update))
          ],
          backgroundColor: AppColors.secondaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryGreen,
          child: const Center(
            child: Icon(Icons.assignment_add),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CreateNewBudget(
                  screenSize: widget.screenSize,
                );
              },
            )).then((_) => budgetController.forceFetchBudgets());
          },
        ),
        body: Container(
          constraints: BoxConstraints(minHeight: widget.screenSize.height),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fundo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Obx(() {
            if (budgetController.canFetch.value) {
              budgetController.fetchBudgets();
            }
            if (budgetController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (budgetController.hasError.value) {
                return DefaultErrorMessage(
                  screenSize: widget.screenSize,
                  icon: Icons.wifi_tethering_error,
                  text: "Erro de conexão",
                );
              } else if (budgetController.budgetList.isNotEmpty) {
                List<BudgetModel> inProgress = [];
                List<BudgetModel> approved = [];
                List<BudgetModel> waitingForApproval = [];
                List<BudgetModel> canceled = [];
                List<BudgetModel> done = [];
                for (BudgetModel actualBudget in budgetController.budgetList) {
                  switch (actualBudget.situation) {
                    case SituationEnum.inProgress:
                      inProgress.add(actualBudget);
                      break;
                    case SituationEnum.approved:
                      approved.add(actualBudget);
                      break;
                    case SituationEnum.canceled:
                      canceled.add(actualBudget);
                      break;
                    case SituationEnum.waitingForApproval:
                      waitingForApproval.add(actualBudget);
                      break;
                    case SituationEnum.done:
                      done.add(actualBudget);
                      break;
                  }
                }
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      const Gap(24),
                      BudgetListBySituation(
                        title: "Em progresso",
                        budgetList: inProgress,
                        situation: SituationEnum.inProgress,
                        screenSize: widget.screenSize,
                        scrollController: scrollController,
                      ),
                      const Gap(24),
                      BudgetListBySituation(
                        title: "Aprovados",
                        budgetList: approved,
                        situation: SituationEnum.approved,
                        screenSize: widget.screenSize,
                        scrollController: scrollController,
                      ),
                      const Gap(24),
                      BudgetListBySituation(
                        title: "Esperando aprovação",
                        budgetList: waitingForApproval,
                        situation: SituationEnum.waitingForApproval,
                        screenSize: widget.screenSize,
                        scrollController: scrollController,
                      ),
                      const Gap(24),
                      BudgetListBySituation(
                        title: "Cancelados",
                        budgetList: canceled,
                        situation: SituationEnum.canceled,
                        screenSize: widget.screenSize,
                        scrollController: scrollController,
                      ),
                      const Gap(24),
                      BudgetListBySituation(
                        title: "Finalizados",
                        budgetList: done,
                        situation: SituationEnum.done,
                        screenSize: widget.screenSize,
                        scrollController: scrollController,
                      ),
                      const Gap(80),
                    ]),
                  ),
                );
              } else {
                return DefaultErrorMessage(
                  screenSize: widget.screenSize,
                  icon: Icons.playlist_remove_outlined,
                  text: "Nenhum orçamento cadastrado",
                );
              }
            }
          }),
        ));
  }
}
