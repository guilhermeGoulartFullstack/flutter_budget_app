import 'package:app_emerson/components/default_error_message.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:app_emerson/firebase/firebase_client.repository.dart';
import 'package:app_emerson/components/client_card.component.dart';
import 'package:app_emerson/components/new_client_pop_up.component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientList extends StatefulWidget {
  const ClientList({
    super.key,
    required this.screenSize,
  });
  final Size screenSize;

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final FirebaseClientRepository clientController =
      Get.put(FirebaseClientRepository());

  Future openNewClientModal() async {
    showDialog(
      context: context,
      builder: (context) {
        return NewClientPopUp(
          screenSize: widget.screenSize,
        );
      },
    );
  }

  @override
  initState() {
    clientController.fetchClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text("Clientes"),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  clientController.forceFetchClients();
                },
                icon: const Icon(Icons.update))
          ],
          backgroundColor: AppColors.secondaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryGreen,
          child: const Center(
            child: Icon(Icons.person_add_alt_1),
          ),
          onPressed: () {
            openNewClientModal();
          },
        ),
        body: Container(
          constraints: BoxConstraints(minHeight: widget.screenSize.height),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fundo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Obx(() {
            if (clientController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (clientController.hasError.value) {
                return DefaultErrorMessage(
                  screenSize: widget.screenSize,
                  icon: Icons.wifi_tethering_error,
                  text: "Erro de conexão",
                );
              } else if (clientController.clientList.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80, top: 14),
                  shrinkWrap: true,
                  itemCount: clientController.clientList.length,
                  itemBuilder: (c, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 24),
                      child: ClientCard(
                        clientModel: clientController.clientList[index],
                        isEven: (index % 2 == 0),
                        screenSize: widget.screenSize,
                      ),
                    );
                  },
                );
              } else {
                return DefaultErrorMessage(
                  screenSize: widget.screenSize,
                  icon: Icons.person_search_rounded,
                  text: "Nenhum cliente cadastrado",
                );
              }
            }
          }),
        ));
  }
}
