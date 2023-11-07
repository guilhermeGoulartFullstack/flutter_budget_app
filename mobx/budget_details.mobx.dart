import 'package:mobx/mobx.dart';

part 'budget_details.mobx.g.dart';

class BudgetDetailsMobx = _budgetDetailsMobx with _$BudgetDetailsMobx;

abstract class _budgetDetailsMobx with Store {
  @observable
  double totalValue = 0;

  @action
  void setTotalValue(
      {required double additionalValue, required double originalValue}) {
    totalValue = originalValue + additionalValue;
  }
}
