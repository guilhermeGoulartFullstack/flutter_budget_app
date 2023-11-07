import 'package:app_emerson/model/budget.model.dart';
import 'package:mobx/mobx.dart';

part 'budget_list.mobx.g.dart';

class BudgetListMobx = _budgetListMobx with _$BudgetListMobx;

abstract class _budgetListMobx with Store {
  @observable
  List<BudgetModel> budgets = [];

  @action
  void setBudgets({required List<BudgetModel> newList}) {
    budgets = newList;
  }
}
