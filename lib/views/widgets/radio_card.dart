import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sport_fm/controller/favorite_controller.dart';
import 'package:sport_fm/utils/color_const.dart';
import 'package:sport_fm/views/screens/radio/radio_detail_screen.dart';

import '../../models/radio_model.dart';
import 'custom_text.dart';

class RadioCard extends StatelessWidget {
  final RadioModel? radioModel;
  final List<RadioModel>? radios;
  const RadioCard({super.key, this.radioModel, this.radios});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.put(FavoriteController());
    return InkWell(
      onTap: () {
        Get.to(() => const RadioDetailScreen(), arguments: {
          'radio': radioModel,
          'radios': radios,
        });
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Image.network(
                  radioModel?.favicon ?? '',
                  fit: BoxFit.fill,
                  errorBuilder: (context, url, error) =>
                      Image.asset('assets/images/fm.webp'),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Image.asset('assets/images/overlay.webp'),
                )
              ],
            ),
          ),
          Positioned(
            left: 8.w,
            right: 8.w,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: radioModel?.name ?? '',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: radioModel?.tags ?? '',
                  color: Colors.white,
                )
              ],
            ),
          ),
          Positioned(
            top: 5.w,
            right: 5.w,
            child: InkWell(
              onTap: () {
                favoriteController.addToFavorite(radioModel ?? RadioModel());
              },
              child: Obx(
                () => favoriteController.isLoading.value
                    ? Icon(
                        Icons.favorite_outline,
                        color: secondaryColor,
                      )
                    : Icon(
                        favoriteController.favRadios
                                .where((item) => (item.stationuuid ?? '')
                                    .contains(radioModel?.stationuuid ?? ''))
                                .toList()
                                .isNotEmpty
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: secondaryColor,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
