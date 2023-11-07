import 'package:app_emerson/components/default_error_message.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:flutter/material.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:app_emerson/components/service_card.component.dart';
import 'package:app_emerson/components/new_service_pop_up.component.dart';
import 'package:app_emerson/firebase/firebase_service.repository.dart';
import 'package:get/get.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({
    super.key,
    required this.screenSize,
  });
  final Size screenSize;

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  final FirebaseServiceRepository serviceController =
      Get.put(FirebaseServiceRepository());

  late Future<List<ServiceModel>> services;

  Future openNewServiceModal() async {
    showDialog(
      context: context,
      builder: (context) {
        return NewServicePopUp(
          screenSize: widget.screenSize,
        );
      },
    );
  }

  @override
  initState() {
    serviceController.fetchServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 34.0),
          child: Text("Serviços"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                serviceController.forceFetchServices();
              },
              icon: const Icon(Icons.update))
        ],
        backgroundColor: AppColors.secondaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        child: const Center(
          child: Icon(Icons.addchart_rounded),
        ),
        onPressed: () {
          openNewServiceModal();
        },
      ),
      body: Container(
        constraints: BoxConstraints(
            minHeight: widget.screenSize.height,
            minWidth: widget.screenSize.width),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          if (serviceController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (serviceController.hasError.value) {
              return DefaultErrorMessage(
                screenSize: widget.screenSize,
                icon: Icons.wifi_tethering_error,
                text: "Erro de conexão",
              );
            } else if (serviceController.serviceList.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 14),
                shrinkWrap: true,
                itemCount: serviceController.serviceList.length,
                itemBuilder: (c, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 24),
                    child: ServiceCard(
                      serviceModel: serviceController.serviceList[index],
                      isEven: (index % 2 == 0),
                      screenSize: widget.screenSize,
                    ),
                  );
                },
              );
            } else {
              return DefaultErrorMessage(
                screenSize: widget.screenSize,
                icon: Icons.playlist_remove_outlined,
                text: "Nenhum serviço cadastrado",
              );
            }
          }
        }),
      ),
    );
  }
}
