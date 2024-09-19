import 'dart:convert';

import 'package:get/get.dart';
import 'package:sport_fm/services/local_storage.dart';
import 'package:sport_fm/utils/enum.dart';

import '../models/radio_model.dart';

class FavoriteController extends GetxController {
  final isLoading = false.obs;
  RxList<RadioModel> favRadios = <RadioModel>[].obs;
  final fav = ''.obs;

  @override
  void onInit() {
    getFavorite();
    super.onInit();
  }

  void getFavorite() {
    isLoading.value = true;
    fav.value = LocalStorage.instance.read(StorageKey.favorite.name) ?? "[]";
    favRadios.clear();
    favRadios.addAll(jsonDecode(fav.value).map<RadioModel>((item) {
      return RadioModel.fromJson(item);
    }));
    isLoading.value = false;
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
