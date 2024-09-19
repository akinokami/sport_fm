import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sport_fm/controller/favorite_controller.dart';
import 'package:sport_fm/controller/radio_controller.dart';

import '../../widgets/custom_loading.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/radio_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.put(FavoriteController());
    final radioController = Get.put(RadioController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: CustomText(
          text: 'favorite'.tr,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Obx(
        () => favoriteController.isLoading.value
            ? const Center(
                child: CustomLoading(),
              )
            : favoriteController.favRadios.isEmpty
                ? Center(
                    child: CustomText(text: 'no_data'.tr),
                  )
                : Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15.w,
                                    mainAxisSpacing: 15.h,
                                    childAspectRatio: 1.0),
                            itemCount: favoriteController.favRadios.length,
                            itemBuilder: (context, index) {
                              return RadioCard(
                                radioModel: favoriteController.favRadios[index],
                                radios: radioController.radios,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
