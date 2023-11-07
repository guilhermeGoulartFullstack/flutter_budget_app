import 'package:app_emerson/model/service.model.dart';

String budgetToStringWithDescription(
    {required List<ServiceModel> services, required double totalValue}) {
  int index = 0;
  List<String> servicesServices = services
      .map((e) => "**${e.service}* => R\$${e.value.toStringAsFixed(2)}")
      .toList();

  List<String> servicesDescriptions =
      services.map((e) => e.description).toList();

  String servicesToString = "Segue o orçamento feito:\n\n";

  servicesServices.forEach((element) {
    String actualName = servicesServices.elementAt(index);
    String actualDescription = servicesDescriptions.elementAt(index);

    servicesToString =
        "$servicesToString$actualName\n$actualDescription\n---\n";

    index++;
  });

  servicesToString = "$servicesToString Total: R\$${totalValue.toString()}";
  return servicesToString;
}
