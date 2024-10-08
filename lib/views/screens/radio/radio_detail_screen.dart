import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sport_fm/controller/favorite_controller.dart';
import 'package:sport_fm/utils/dimen_const.dart';
import 'package:sport_fm/views/widgets/custom_loading.dart';
import 'package:sport_fm/views/widgets/playing_card.dart';

import '../../../controller/play_radio_controller.dart';
import '../../../utils/color_const.dart';
import '../../widgets/custom_text.dart';

class RadioDetailScreen extends StatelessWidget {
  const RadioDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playRadioController = Get.put(PlayRadioController());
    final favoriteController = Get.put(FavoriteController());
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: CustomText(
            text: ''.tr,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: Obx(
          () => playRadioController.isLoading.value
              ? const Center(
                  child: CustomLoading(),
                )
              : Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            favoriteController
                                .addToFavorite(playRadioController.radio.value);
                          },
                          child: Obx(
                            () => favoriteController.isLoading.value
                                ? Icon(
                                    Icons.favorite_outline,
                                    color: secondaryColor,
                                    size: 20.sp,
                                  )
                                : Icon(
                                    favoriteController.favRadios
                                            .where((item) =>
                                                (item.stationuuid ?? '')
                                                    .contains(
                                                        playRadioController
                                                                .radio
                                                                .value
                                                                .stationuuid ??
                                                            ''))
                                            .toList()
                                            .isNotEmpty
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: secondaryColor,
                                    size: 20.sp,
                                  ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 100.h,
                          height: 100.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.r),
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: [
                                Image.network(
                                  playRadioController.radio.value.favicon ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, url, error) =>
                                      Image.asset('assets/images/fm.webp'),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  child: Image.asset(
                                    'assets/images/overlay.webp',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      kSizedBoxH10,
                      Center(
                        child: CustomText(
                          text: playRadioController.radio.value.name ?? '',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      kSizedBoxH5,
                      Center(
                        child: CustomText(
                            text: playRadioController.radio.value.tags ?? ''),
                      ),
                      kSizedBoxH10,
                      ControlButtons(
                          playRadioController.player, playRadioController),
                      kSizedBoxH10,
                      CustomText(
                        text: 'other'.tr,
                        fontWeight: FontWeight.w500,
                      ),
                      kSizedBoxH5,
                      Expanded(
                        child: ListView.builder(
                          itemCount: playRadioController.radios.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PlayingCard(
                              radioModel: playRadioController.radios[index],
                              playRadioController: playRadioController,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final PlayRadioController playRadioController;
  const ControlButtons(this.player, this.playRadioController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () {
                  playRadioController.previousUrl();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_double_arrow_left,
                    size: 28.h,
                    color: secondaryColor,
                  ),
                ),
              );
            }
          },
        ),
        kSizedBoxW25,
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return SizedBox(
                height: 40.h,
                width: 40.h,
                child: const Center(
                  child: CustomLoading(),
                ),
              );
            } else if (playing != true) {
              return GestureDetector(
                onTap: player.play,
                child: Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  width: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 37.h,
                    color: secondaryColor,
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return GestureDetector(
                onTap: player.pause,
                child: Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  width: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.pause,
                    size: 37.h,
                    color: secondaryColor,
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () => player.seek(Duration.zero),
                child: Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  width: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.replay,
                    size: 37.h,
                    color: secondaryColor,
                  ),
                ),
              );
            }
          },
        ),
        kSizedBoxW25,
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () {
                  playRadioController.nextUrl();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_double_arrow_right,
                    size: 28.h,
                    color: secondaryColor,
                  ),
                ),
              );
            }
          },
        )
      ],
    );
  }
}
