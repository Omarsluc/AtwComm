import 'dart:developer';

import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/utils/consts.dart';
import 'package:atw_comm/core/widgets/arrow_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/service/speachToText.dart';
import '../../../core/theming/style.dart';
import '../../../core/widgets/app_text_form_filed.dart';
import '../../../generated/assets.dart';
import '../logic/search_cubit.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArrowBackCustom(),
              SizedBox(height: 30.h,),
              Center(child: Text('Hello ${userNameIdentified??''} How Can i help you today',style: TextStyles.font16WhiteMedium,)),
              SizedBox(height: 30.h,),
              AppTextFormField(
                hintText: 'Ask Me',
                hintStyle:
                TextStyles.font14LightGrayRegular.copyWith(color: Colors.grey),
                controller:  context.read<SearchCubit>().searchController,
                onFieldSubmitted: (val) {
                  context.read<SearchCubit>().sendToModel(context);
                },
                suffixIcon: InkWell(
                  onTap: () async {
                    // Start listening for speech
                    await SpeechToTextService.startListening().then((_) {
                      final voiceText = SpeechToTextService.recognizedWords;
                      // context
                      //     .read<SearchCubit>()
                      //     .changeTextFormFieldBasedOnVoiceUser(
                      //   voiceUser: voiceText,
                      // );
                      log("Recognized Words: $voiceText");
                    });
                  },
                  child: SvgPicture.asset(
                    Assets.iconsMic,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
