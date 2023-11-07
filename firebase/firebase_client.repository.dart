import 'package:app_emerson/model/cliente.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseClientRepository {
  CollectionReference<Map<String, dynamic>> clientRepository =
      FirebaseFirestore.instance.collection("Client");

  final clientList = <ClientModel>[].obs;
  final RxBool canFetch = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  setCanFetchTrue() {
    canFetch.value = true;
  }

  setCanFetchFalse() {
    canFetch.value = false;
  }

  setIsLoagingTrue() {
    isLoading.value = true;
  }

  setIsLoagingFalse() {
    isLoading.value = false;
  }

  setHasErrorTrue() {
    hasError.value = true;
  }

  setHasErrorFalse() {
    hasError.value = false;
  }

  Future<void> fetchClients() async {
    setIsLoagingTrue();
    if (canFetch.value) {
      try {
        final snapshot = await clientRepository
            .orderBy('addition_date', descending: false)
            .get();
        clientList
            .assignAll(snapshot.docs.map((e) => ClientModel.fromSnapshot(e)));
        setHasErrorFalse();
      } catch (_) {
        setHasErrorTrue();
      }
    }
    setCanFetchFalse();
    setIsLoagingFalse();
  }

  Future<void> forceFetchClients() async {
    setCanFetchTrue();
    fetchClients();
  }

  Future<void> add({
    required String sign,
  }) async {
    Map<String, String> newClient = {
      'sign': sign,
      'addition_date': DateTime.now().toString().substring(0, 10)
    };
    await clientRepository.add(newClient);
  }

  Future<void> put({
    required String id,
    required String sign,
  }) async {
    Map<String, String> updatedClient = {
      'sign': sign,
    };
    await clientRepository.doc(id).update(updatedClient);
  }

  Future<void> delete({
    required String id,
  }) async {
    await clientRepository.doc(id).delete();
  }
}
