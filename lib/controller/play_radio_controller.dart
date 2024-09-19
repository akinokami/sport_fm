import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sport_fm/utils/constants.dart';
import 'package:flutter/material.dart';
import '../models/radio_model.dart';
import 'package:audio_session/audio_session.dart';

class PlayRadioController extends GetxController with WidgetsBindingObserver {
  final player = AudioPlayer();
  Rx<RadioModel?> radio = RadioModel().obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;

  @override
  void onInit() {
    radio.value = Get.arguments['radio'];
    radios.value = Get.arguments['radios'];
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    playAudioUrl();
    super.onInit();
  }

  Future<void> playAudioUrl() async {
    print(radio.value?.url);
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(radio.value?.url ??
          ''))); //"https://stream-uk1.radioparadise.com/aac-320"
    } catch (e) {
      constants.showSnackBar(
          title: 'Warning', msg: 'Radio resource not found.');
    }
  }

  void pause() {
    player.pause();
  }

  @override
  void onClose() {
    player.stop();
    super.onClose();
  }
}
