// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_card.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceCardMobx on _serviceCardMobx, Store {
  late final _$isEditingAtom =
      Atom(name: '_serviceCardMobx.isEditing', context: context);

  @override
  bool get isEditing {
    _$isEditingAtom.reportRead();
    return super.isEditing;
  }

  @override
  set isEditing(bool value) {
    _$isEditingAtom.reportWrite(value, super.isEditing, () {
      super.isEditing = value;
    });
  }

  late final _$_serviceCardMobxActionController =
      ActionController(name: '_serviceCardMobx', context: context);

  @override
  void changeEditing() {
    final _$actionInfo = _$_serviceCardMobxActionController.startAction(
        name: '_serviceCardMobx.changeEditing');
    try {
      return super.changeEditing();
    } finally {
      _$_serviceCardMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isEditing: ${isEditing}
    ''';
  }
}
