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
          appBar: AppBar(
            backgroundColor: ColorsManager.colorBlack,
            leading: ArrowBackCustom(),
          ),
          backgroundColor: ColorsManager.colorBlack,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHO WE ARE',
                      style: TextStyle(
                        color: Color(0xFFFFED50),
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Jumper PERSONAL USE ONLY',
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.50,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Imagine a world where technology connects, protects, and empowers. That’s the world ATW is building.\n  Founded in Cairo in ',
                            style: TextStyle(
                              color: Color(0xFF9BF0E1),
                              fontSize: 17,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                            ),
                          ),
                          TextSpan(
                            text: '1997',
                            style: TextStyle(
                              color: Color(0xFFFFED50),
                              fontSize: 17,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                            ),
                          ),
                          TextSpan(
                            text: ' as an R&D organization, ATW grew into a global leader in digital transformation. From Cairo to Houston, Dubai, and across Europe and Africa, we’re creating secure, intelligent solutions that drive business success.  In 2016, ATW’s second generation launched a new era of digitization, expanding globally. By 2019, we’d established roots in Texas, connecting continents with transformative solutions.  Now, as we approach 2025, our third generation is embracing AI to empower businesses to lead in a future of connectivity and trust—one innovation at a time.',
                            style: TextStyle(
                              color: Color(0xFF9BF0E1),
                              fontSize: 17,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 70,width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     gradient: LinearGradient(colors: [Colors.blue,Colors.green])
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
