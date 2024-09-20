import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sport_fm/controller/radio_controller.dart';
import 'package:sport_fm/views/widgets/custom_loading.dart';

import '../../../utils/color_const.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/radio_card.dart';
import '../search/search_screen.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final radioController = Get.put(RadioController());
    // final playRadioController = Get.put(PlayRadioController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: CustomText(
          text: 'radio'.tr,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Get.to(() => const SearchScreen(), arguments: {
                'radios': radioController.radios,
              });
            },
            icon: Icon(
              Icons.search,
              color: secondaryColor,
              size: 15.sp,
            ),
          ),
        ],
      ),
      body: Obx(
        () => radioController.isLoading.value
            ? const Center(
                child: CustomLoading(),
              )
            : Stack(
                fit: StackFit.passthrough,
                children: [
                  Padding(
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
                            itemCount: radioController.radios.length,
                            itemBuilder: (context, index) {
                              return RadioCard(
                                radioModel: radioController.radios[index],
                                radios: radioController.radios,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  // Visibility(
                  //   visible: playRadioController.radio.value != null,
                  //   child: Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: PlayingCard(),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
