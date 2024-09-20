import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import '../models/radio_model.dart';
import 'package:audio_session/audio_session.dart';

class PlayRadioController extends GetxController with WidgetsBindingObserver {
  final player = AudioPlayer();
  Rx<RadioModel?> radio = RadioModel().obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    radio.value = Get.arguments['radio'];
    radios.value = Get.arguments['radios'];
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    playAudioUrl();
    super.onInit();
  }

  Future<void> playAudioUrl() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await player
          .setAudioSource(AudioSource.uri(Uri.parse(radio.value?.url ?? '')));
      player.play();
    } catch (e) {
      // constants.showSnackBar(
      //     title: 'Warning', msg: 'Radio resource not found.');
    }
  }

  void pause() {
    player.pause();
  }

  void nextUrl() {
    isLoading.value = true;
    int index = 0;
    index = radios.indexWhere((item) =>
        (item.stationuuid ?? '').contains(radio.value?.stationuuid ?? ''));
    if (index == radios.length - 1) {
      radio.value = radios[0];
    } else {
      radio.value = radios[index + 1];
    }
    playAudioUrl();
    isLoading.value = false;
  }

  void previousUrl() {
    isLoading.value = true;
    int index = 0;
    index = radios.indexWhere((item) =>
        (item.stationuuid ?? '').contains(radio.value?.stationuuid ?? ''));
    if (index == 0) {
      radio.value = radios[radios.length - 1];
    } else {
      radio.value = radios[index - 1];
    }
    playAudioUrl();
    isLoading.value = false;
  }

  void selectChannel(RadioModel rm) {
    isLoading.value = true;
    radio.value = rm;
    playAudioUrl();
    isLoading.value = false;
  }

  @override
  void onClose() {
    player.stop();
    super.onClose();
  }
}
