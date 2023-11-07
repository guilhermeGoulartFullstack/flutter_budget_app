import 'package:app_emerson/model/service.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseServiceRepository {
  CollectionReference<Map<String, dynamic>> serviceRepository =
      FirebaseFirestore.instance.collection("Service");

  final serviceList = <ServiceModel>[].obs;
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

  Future<void> fetchServices() async {
    setIsLoagingTrue();
    if (canFetch.value) {
      try {
        final snapshot = await serviceRepository
            .orderBy('addition_date', descending: false)
            .get();
        serviceList.assignAll(
            snapshot.docs.map((e) => ServiceModel.fromSnapshot(e)).toList());
        setHasErrorFalse();
      } catch (_) {
        setHasErrorTrue();
      }
    }
    setCanFetchFalse();
    setIsLoagingFalse();
  }

  Future<void> forceFetchServices() async {
    setCanFetchTrue();
    fetchServices();
  }

  Future<void> add({
    required String service,
    required String description,
    required double value,
  }) async {
    Map<String, dynamic> newService = {
      'service': service,
      'description': description,
      'value': value,
      'addition_date': DateTime.now().toString().substring(0, 10)
    };
    await serviceRepository.add(newService);
  }

  Future<void> put({
    required String id,
    required String service,
    required String description,
    required double value,
  }) async {
    Map<String, dynamic> updatedService = {
      'service': service,
      'description': description,
      'value': value,
    };
    await serviceRepository.doc(id).update(updatedService);
  }

  Future<void> delete({
    required String id,
  }) async {
    await serviceRepository.doc(id).delete();
  }
}
