import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sport_fm/utils/color_const.dart';
import 'package:sport_fm/utils/dimen_const.dart';
import 'package:sport_fm/views/widgets/custom_card.dart';
import 'package:sport_fm/views/widgets/custom_text.dart';

import '../../controller/play_radio_controller.dart';
import '../../models/radio_model.dart';

class PlayingCard extends StatelessWidget {
  final RadioModel? radioModel;
  final PlayRadioController playRadioController;
  const PlayingCard(
      {super.key, this.radioModel, required this.playRadioController});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        playRadioController.selectChannel(radioModel ?? RadioModel());
      },
      child: CustomCard(
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  radioModel?.favicon ?? '',
                  fit: BoxFit.fill,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, url, error) => Image.asset(
                    'assets/images/fm.webp',
                    width: 50,
                    height: 50,
                  ),
                ),
                kSizedBoxW10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: radioModel?.name ?? ''),
                    CustomText(
                      text: radioModel?.tags ?? '',
                      isEllip: true,
                    )
                  ],
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: radioModel?.stationuuid ==
                    playRadioController.radio.value.stationuuid,
                child: Icon(
                  Icons.music_note,
                  size: 25.sp,
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
