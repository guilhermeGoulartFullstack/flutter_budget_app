import 'package:app_emerson/enum/situation.enum.dart';
import 'package:app_emerson/model/budget.model.dart';
import 'package:app_emerson/model/service.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseBudgetRepository {
  CollectionReference<Map<String, dynamic>> budgetRepository =
      FirebaseFirestore.instance.collection("Budget");

  final budgetList = <BudgetModel>[].obs;
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

  Future<void> fetchBudgets() async {
    setIsLoagingTrue();
    if (canFetch.value) {
      try {
        final snapshot = await budgetRepository
            .orderBy('addition_date', descending: false)
            .get();
        budgetList
            .assignAll(snapshot.docs.map((e) => BudgetModel.fromSnapshot(e)));
        setHasErrorFalse();
      } catch (_) {
        setHasErrorTrue();
      }
    }
    setCanFetchFalse();
    setIsLoagingFalse();
  }

  Future<void> forceFetchBudgets() async {
    setCanFetchTrue();
    fetchBudgets();
  }

  Future<void> add({
    required String sign,
    required SituationEnum situation,
    required int totalKm,
    required double totalValue,
    required double additionalValue,
    required List<ServiceModel> serviceList,
    required String description,
  }) async {
    Map<String, dynamic> newBudget = {
      'sign': sign,
      'situation': situation.name,
      'totalKm': totalKm,
      'totalValue': totalValue,
      'additionalValue': additionalValue,
      'serviceList': serviceList.map((service) {
        return {
          'service': service.service,
          'description': service.description,
          'value': service.value,
        };
      }).toList(),
      'description': description,
      'addition_date': DateTime.now().toString(),
    };
    await budgetRepository.add(newBudget);
  }

  Future<void> changeBudget({
    required String id,
    required SituationEnum situation,
    required double totalValue,
    required double additionalValue,
    required List<ServiceModel> serviceList,
  }) async {
    Map<String, dynamic> updatedBudget = {
      'situation': situation.name,
      'totalValue': totalValue,
      'additionalValue': additionalValue,
      'serviceList': serviceList.map((service) {
        return {
          'service': service.service,
          'description': service.description,
          'value': service.value,
        };
      }).toList(),
    };
    await budgetRepository.doc(id).update(updatedBudget);
  }

  Future<void> addStartDate({
    required String id,
    required DateTime startDate,
  }) async {
    Map<String, dynamic> startedBudget = {
      'start_date': startDate.toString(),
    };
    await budgetRepository.doc(id).update(startedBudget);
  }

  Future<void> delete({
    required String id,
  }) async {
    await budgetRepository.doc(id).delete();
  }
}
