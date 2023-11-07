enum SituationEnum {
  waitingForApproval,
  approved,
  canceled,
  inProgress,
  done,
}

class EnumConverter {
  static SituationEnum situationFromJson(String value) {
    switch (value) {
      case 'waitingForApproval':
        return SituationEnum.waitingForApproval;
      case 'approved':
        return SituationEnum.approved;
      case 'canceled':
        return SituationEnum.canceled;
      case 'inProgress':
        return SituationEnum.inProgress;
      case 'done':
        return SituationEnum.done;
      default:
        throw ArgumentError('Valor inválido para SituationEnum: $value');
    }
  }

  static String situationToJson(SituationEnum situation) {
    return situation.name.toString();
  }
}
