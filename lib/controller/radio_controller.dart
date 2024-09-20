import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sport_fm/models/radio_model.dart';

import '../services/local_storage.dart';
import '../utils/enum.dart';

class RadioController extends GetxController {
  final isLoading = false.obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;
  final isLoadingFav = false.obs;
  RxList<RadioModel> favRadios = <RadioModel>[].obs;
  final fav = ''.obs;

  @override
  void onInit() {
    getRadio();
    getFavorite();
    super.onInit();
  }

  Future<void> getRadio() async {
    isLoading.value = true;
    final String response =
        await rootBundle.loadString('assets/data/radio.json');
    final data = await json.decode(response);
    var r = data as List;
    radios.value = r.map((item) => RadioModel.fromJson(item)).toList();
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }

  void getFavorite() {
    isLoadingFav.value = true;
    fav.value = LocalStorage.instance.read(StorageKey.favorite.name) ?? "[]";
    favRadios.clear();
    favRadios.addAll(jsonDecode(fav.value).map<RadioModel>((item) {
      return RadioModel.fromJson(item);
    }));
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoadingFav.value = false;
    });
  }

  void addToFavorite(RadioModel radio) {
    favRadios.contains(radio) ? favRadios.remove(radio) : favRadios.add(radio);
    LocalStorage.instance.remove(StorageKey.favorite.name);
    LocalStorage.instance
        .write(StorageKey.favorite.name, jsonEncode(favRadios));
    update();
  }

  void removeFromFavorite(RadioModel radio) {
    favRadios.removeWhere((item) => item.stationuuid == radio.stationuuid);
    LocalStorage.instance
        .write(StorageKey.favorite.name, jsonEncode(favRadios));
    update();
  }
}
