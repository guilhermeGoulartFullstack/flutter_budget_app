import 'package:app_emerson/components/default_error_message.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/firebase/firebase_client.repository.dart';
import 'package:app_emerson/firebase/firebase_service.repository.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:app_emerson/screens/new_budget_finalization.screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateNewBudget extends StatefulWidget {
  const CreateNewBudget({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  State<CreateNewBudget> createState() => _CreateNewBudgetState();
}

class _CreateNewBudgetState extends State<CreateNewBudget> {
  @override
  void initState() {
    super.initState();
    clientController.fetchClients();
    serviceController.fetchServices();
  }

  final FirebaseClientRepository clientController =
      Get.put(FirebaseClientRepository());

  final FirebaseServiceRepository serviceController =
      Get.put(FirebaseServiceRepository());

  final totalKmTextController = TextEditingController();

  String? selectedClient;
  List<ServiceModel> selectedServices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.secondaryColor),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        child: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 40,
          ),
        ),
        onPressed: () {
          bool noError = true;
          int? totalKM;
          try {
            if (totalKmTextController.text.isNotEmpty) {
              totalKM = int.parse(totalKmTextController.text.toString());
            }
          } catch (_) {
            noError = false;
            Fluttertoast.showToast(
              msg: "Total Km aceita apenas números sem vírgula",
              gravity: ToastGravity.BOTTOM,
            );
          }
          if (noError) {
            bool isClientSelected = selectedClient != null;
            bool isListValid = selectedServices.isNotEmpty;
            bool isTotalKmValid = totalKmTextController.text.isNotEmpty;

            if (isClientSelected && isListValid && isTotalKmValid) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return NewBudgetFinalization(
                    budgetServices: selectedServices,
                    client: selectedClient!,
                    totalKm: totalKM!,
                    screenSize: widget.screenSize,
                  );
                }),
              );
            } else {
              Fluttertoast.showToast(
                msg: "Preencha os campos",
                gravity: ToastGravity.BOTTOM,
              );
            }
          }
        },
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: widget.screenSize.height,
          minWidth: widget.screenSize.width,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 24, vertical: widget.screenSize.height * 0.1),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildDropdownClient(
                  setClient: (client) {
                    selectedClient = client;
                  },
                  controller: clientController,
                  screenSize: widget.screenSize,
                ),
                const Gap(20),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d')),
                  ],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: totalKmTextController,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Total KM",
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const Gap(20),
                const Text(
                  "Serviços",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: Colors.white),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColors.secondaryColor,
                    ),
                    height: 300,
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        children: selectedServices.asMap().entries.map((entry) {
                          final index = entry.key;
                          final service = entry.value;
                          final bool isEven = (index % 2 == 0);
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: isEven
                                    ? Colors.white
                                    : AppColors.terciaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Gap(20),
                                      Text(
                                        service.service,
                                        style: TextStyle(
                                            color: isEven
                                                ? AppColors.primaryColor
                                                : Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedServices.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const Gap(20),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BuildDropdownService(
                      addService: (String service) {
                        ServiceModel? addition =
                            serviceController.serviceList.singleWhere(
                          (element) => ((element.service == service) &&
                              !selectedServices.contains(element)),
                        );
                        selectedServices.add(addition);
                        setState(() {});
                      },
                      controller: serviceController,
                      screenSize: widget.screenSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildDropdownClient extends StatelessWidget {
  const BuildDropdownClient({
    super.key,
    required this.setClient,
    required this.controller,
    required this.screenSize,
  });
  final Function setClient;
  final FirebaseClientRepository controller;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        if (controller.hasError.value) {
          return DefaultErrorMessage(
            screenSize: screenSize,
            icon: Icons.wifi_tethering_error,
            text: "Erro de conexão",
          );
        } else if (controller.clientList.isNotEmpty) {
          return DropdownSearch(
            items: controller.clientList.map((e) => e.sign).toList(),
            onChanged: (client) {
              setClient(client);
            },
            popupProps: const PopupProps.dialog(
              showSelectedItems: true,
              showSearchBox: true,
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              textAlign: TextAlign.center,
              baseStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              dropdownSearchDecoration: InputDecoration(
                  labelText: "Cliente",
                  floatingLabelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  )),
            ),
            compareFn: (item, sItem) {
              return item == sItem;
            },
          );
        } else {
          return DefaultErrorMessage(
            screenSize: screenSize,
            icon: Icons.person_search_rounded,
            text: "Nenhum cliente cadastrado",
          );
        }
      }
    });
  }
}

class BuildDropdownService extends StatelessWidget {
  const BuildDropdownService({
    super.key,
    required this.addService,
    required this.controller,
    required this.screenSize,
  });
  final Function addService;
  final FirebaseServiceRepository controller;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        if (controller.hasError.value) {
          return DefaultErrorMessage(
            screenSize: screenSize,
            icon: Icons.wifi_tethering_error,
            text: "Erro de conexão",
          );
        } else if (controller.serviceList.isNotEmpty) {
          return SizedBox(
            width: 50,
            height: 50,
            child: DropdownSearch(
              items: controller.serviceList.map((e) => e.service).toList(),
              onChanged: (service) {
                addService(service);
              },
              compareFn: (item, sItem) {
                return item == sItem;
              },
              dropdownButtonProps: const DropdownButtonProps(
                  padding: EdgeInsets.only(right: 2),
                  color: AppColors.terciaryColor,
                  icon: SizedBox(
                      width: 100,
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 30,
                      ))),
              popupProps: const PopupProps.dialog(
                showSelectedItems: false,
                showSearchBox: true,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                textAlign: TextAlign.end,
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return DefaultErrorMessage(
            screenSize: screenSize,
            icon: Icons.person_search_rounded,
            text: "Nenhum serviço cadastrado",
          );
        }
      }
    });
  }
}
