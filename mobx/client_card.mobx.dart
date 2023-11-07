import 'package:mobx/mobx.dart';

part 'client_card.mobx.g.dart';

class ClientCardMobx = _clientCardMobx with _$ClientCardMobx;

abstract class _clientCardMobx with Store {
  @observable
  bool isEditing = false;

  @action
  void changeEditing() {
    isEditing = !isEditing;
  }
}
