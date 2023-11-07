import 'package:mobx/mobx.dart';

part 'service_card.mobx.g.dart';

class ServiceCardMobx = _serviceCardMobx with _$ServiceCardMobx;

abstract class _serviceCardMobx with Store {
  @observable
  bool isEditing = false;

  @action
  void changeEditing() {
    isEditing = !isEditing;
  }
}
