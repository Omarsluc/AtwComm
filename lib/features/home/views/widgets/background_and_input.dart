import 'dart:developer';
import 'package:atw_comm/core/helpers/extention.dart';
import 'package:atw_comm/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/service/speachToText.dart';
import '../../../../core/theming/style.dart';
import '../../../../core/widgets/app_text_form_filed.dart';
import '../../logic/search_cubit.dart';
import 'circle_avatar_with_icon.dart';

Widget buildBackgroundImages(context) {
  return Stack(
    children: [
      const Positioned(
        left: 40,
        bottom: 120,
        child: GradientCircleAvatar(
          text: 'Staff',
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      Positioned(
          right: 40,
          bottom: 50,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.commScreen);            },
            child: const GradientCircleAvatar(
              text: 'Community',
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          )),
    ],
  );
}

Widget buildInputRow(BuildContext context) {
  return Row(
    children: [
      Flexible(
        child: AppTextFormField(
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
      ),
      // const SizedBox(width: 20),
      // InkWell(
      //   onTap: () {
      //     context.pushNamed(Routes.videoScreen);
      //   },
      //   child: Container(
      //     width: 40,
      //     height: 32,
      //     clipBehavior: Clip.antiAlias,
      //     decoration: ShapeDecoration(
      //       gradient: RadialGradient(
      //         center: const Alignment(0.49, 0.50),
      //         radius: 0.39,
      //         colors: [const Color(0x6600804C), Colors.white.withOpacity(0)],
      //       ),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(74),
      //       ),
      //     ),
      //     child: Image.asset('assets/images/video_svgrepo.com.png'),
      //   ),
      // ),
    ],
  );
}
