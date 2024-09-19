import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sport_fm/views/widgets/custom_text.dart';

import '../../../controller/search_radio_controller.dart';
import '../../../utils/dimen_const.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/radio_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchRController = Get.put(SearchRadioController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CustomText(
          text: 'search'.tr,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Obx(
        () => searchRController.isLoading.value
            ? const Center(
                child: CustomLoading(),
              )
            : Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: searchRController.searchTxtController,
                      hintText: 'search'.tr,
                      isValidate: false,
                      onChange: (value) {
                        searchRController.searchRadio();
                      },
                    ),
                    kSizedBoxH15,
                    Expanded(
                      child: searchRController.searchRadios.isEmpty
                          ? Center(
                              child: CustomText(text: 'no_data'.tr),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15.w,
                                      mainAxisSpacing: 15.h,
                                      childAspectRatio: 1.0),
                              itemCount: searchRController.searchRadios.length,
                              itemBuilder: (context, index) {
                                return RadioCard(
                                  radioModel:
                                      searchRController.searchRadios[index],
                                  radios: searchRController.radios,
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
