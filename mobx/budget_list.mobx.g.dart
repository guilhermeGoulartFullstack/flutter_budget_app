// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_list.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BudgetListMobx on _budgetListMobx, Store {
  late final _$budgetsAtom =
      Atom(name: '_budgetListMobx.budgets', context: context);

  @override
  List<BudgetModel> get budgets {
    _$budgetsAtom.reportRead();
    return super.budgets;
  }

  @override
  set budgets(List<BudgetModel> value) {
    _$budgetsAtom.reportWrite(value, super.budgets, () {
      super.budgets = value;
    });
  }

  late final _$_budgetListMobxActionController =
      ActionController(name: '_budgetListMobx', context: context);

  @override
  void setBudgets({required List<BudgetModel> newList}) {
    final _$actionInfo = _$_budgetListMobxActionController.startAction(
        name: '_budgetListMobx.setBudgets');
    try {
      return super.setBudgets(newList: newList);
    } finally {
      _$_budgetListMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
budgets: ${budgets}
    ''';
  }
}
