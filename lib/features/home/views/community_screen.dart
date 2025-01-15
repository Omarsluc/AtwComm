import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/features/home/logic/search_cubit.dart';
import 'package:atw_comm/features/home/logic/search_cubit.dart';
import 'package:atw_comm/features/home/views/widgets/background_and_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/arrow_back.dart';
import '../logic/search_state.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchStates>(
      builder: (context, state) {
        bool isLoading = state is SearchLoadingState;
        return Scaffold(
          backgroundColor: ColorsManager.colorBlack,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArrowBackCustom(),
                  SizedBox(height: 30,),
                  buildInputRow(context),
                  SizedBox(height: 30,),
                  isLoading ? Center(child: CircularProgressIndicator(color: ColorsManager.urlColor,)) : Text(context.read<SearchCubit>().botResponse ?? '',style: TextStyles.font16WhiteMedium,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
