import 'package:atw_comm/core/helpers/spacing.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/filter_chip_widget.dart';
import '../../../generated/assets.dart';

class MyArticlesScreen extends StatelessWidget {
  const MyArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: ColorsManager.mainColor,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height /7.7,
            right: -30.w,
            child: Image.asset(
              Assets.figuresGuyReading,
              height: 220.h,
            ),
          ),
          CustomAppBar(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Articles',
                        style: TextStyles.font24BlackBold,
                      ),
                      verticalSpace(5),
                      Text(
                        'Recommendations for you',
                        style: TextStyles.font13GrayRegular,
                      ),
                      verticalSpace(20),
                      SizedBox(
                        height: 150.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            ArticleCategoryCard(
                              title: 'Front End',
                              color1: Color(0xFF6F35A5),
                              color2: Color(0xFF7F54B2),
                            ),
                            ArticleCategoryCard(
                              title: 'Back End',
                              color1: Color(0xFF9B8DCE),
                              color2: Color(0xFFABA1D9),
                            ),
                            ArticleCategoryCard(
                              title: 'Dev Ops',
                              color1: Color(0xFFC4BEE2),
                              color2: Color(0xFFD4CDEE),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(20),
                      Row(
                        children: [
                          const FilterChipWidget(label: 'Label'),
                          horizontalSpace(10),
                          const FilterChipWidget(label: 'Label'),
                          horizontalSpace(10),
                          const FilterChipWidget(label: 'Label'),
                        ],
                      ),
                      verticalSpace(40),
                      AppButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        myText: 'Staff Articles',
                        width: double.infinity,
                        height: 50.h,
                        radius: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleCategoryCard extends StatelessWidget {
  final String title;
  final Color color1;
  final Color color2;

  const ArticleCategoryCard({
    super.key,
    required this.title,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: color2,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: TextStyles.font16WhiteMedium,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
