import 'dart:developer';

import 'package:atw_comm/core/helpers/extention.dart';
import 'package:atw_comm/features/home/views/widgets/background_and_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/service/speachToText.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/style.dart';
import '../../../core/widgets/app_text_form_filed.dart';
import '../../../generated/assets.dart';

class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorBlack,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                buildBackgroundImages(context),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20),
                    child: Form(
                      key: GlobalKey(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.imagesAtwLogo,width: 170,),
                          const SizedBox(
                            height: 30,
                          ),
                          AppTextFormField(
                            isEnabled: false,
                            hintText: 'Welcome',
                            hintStyle:
                            TextStyles.font14LightGrayRegular.copyWith(color: Colors.grey),
                            controller: TextEditingController(),
                            validator: (String? val) {
                              if (val.isNullorEmpty()) {
                                return 'Field Must Not Be Empty';
                              }
                              return null;
                            },
                            onFieldSubmitted: (val) {
                              // if (context
                              //     .read<SearchCubit>()
                              //     .formkey
                              //     .currentState!
                              //     .validate()) {
                              //   context.read<SearchCubit>().doSearch();
                              // }
                            },
                          ),
                          const SizedBox(height: 20),
                          // BlocBuilderSearchResult(
                          //   textSize: textSize,
                          //   searchState: state,
                          // ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 30.0),
      //   child: _buildAskMeButton(context),
      // ),
    );
  }
}