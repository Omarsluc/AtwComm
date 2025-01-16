import 'dart:developer';

import 'package:atw_comm/core/helpers/extention.dart';
import 'package:atw_comm/features/home/logic/search_state.dart';
import 'package:atw_comm/features/home/views/widgets/background_and_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/service/speachToText.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/style.dart';
import '../../../core/widgets/app_text_form_filed.dart';
import '../../../generated/assets.dart';
import '../logic/search_cubit.dart';

class HomeScreen extends StatelessWidget {
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
              BlocBuilder<SearchCubit, SearchStates>(
                builder: (context, state) {
                  bool isLoading = state is SearchLoadingState;
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20),
                      child: Form(
                        key: GlobalKey(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            SvgPicture.asset(
                              Assets.imagesAtwLogo,
                              width: 170,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            buildInputRow(context),
                            SizedBox(
                              height: 30,
                            ),
                            isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: ColorsManager.urlColor,
                                  ))
                                : Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                      context.read<SearchCubit>().botResponse ??
                                          '',
                                      style: TextStyles.font16WhiteMedium,
                                    ),
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
                  );
                },
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
