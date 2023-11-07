// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_details.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BudgetDetailsMobx on _budgetDetailsMobx, Store {
  late final _$totalValueAtom =
      Atom(name: '_budgetDetailsMobx.totalValue', context: context);

  @override
  double get totalValue {
    _$totalValueAtom.reportRead();
    return super.totalValue;
  }

  @override
  set totalValue(double value) {
    _$totalValueAtom.reportWrite(value, super.totalValue, () {
      super.totalValue = value;
    });
  }

  late final _$_budgetDetailsMobxActionController =
      ActionController(name: '_budgetDetailsMobx', context: context);

  @override
  void setTotalValue(
      {required double additionalValue, required double originalValue}) {
    final _$actionInfo = _$_budgetDetailsMobxActionController.startAction(
        name: '_budgetDetailsMobx.setTotalValue');
    try {
      return super.setTotalValue(
          additionalValue: additionalValue, originalValue: originalValue);
    } finally {
      _$_budgetDetailsMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalValue: ${totalValue}
    ''';
  }
}
