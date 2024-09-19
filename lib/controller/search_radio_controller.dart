import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sport_fm/models/radio_model.dart';

class SearchRadioController extends GetxController {
  final isLoading = false.obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;
  RxList<RadioModel> searchRadios = <RadioModel>[].obs;
  final searchTxtController = TextEditingController();

  @override
  void onInit() {
    radios.value = Get.arguments['radios'];
    searchRadios();
    super.onInit();
  }

  void searchRadio() {
    isLoading.value = true;
    if (searchTxtController.text != '') {
      searchRadios.value = radios
          .where((element) => (element.name ?? '')
              .toLowerCase()
              .contains(searchTxtController.text.toLowerCase()))
          .toList();
    } else {
      searchRadios.value = radios;
    }
    isLoading.value = false;
  }
}
