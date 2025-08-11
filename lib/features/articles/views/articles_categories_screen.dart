import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/core/utils/enums.dart';
import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:atw_comm/core/widgets/globe_appbar_widget.dart';
import 'package:atw_comm/core/widgets/public_text.dart';
import 'package:atw_comm/features/articles/views/articles_screen.dart';
import 'package:atw_comm/features/articles/views/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/routing/routes.dart';
import '../../../generated/assets.dart';

class ArticlesCategoriesScreen extends StatelessWidget {
  const ArticlesCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryCardData(
        title: 'Mobility',
        count: 15,
        bgColor: const Color(0xFFFFE6E6),
        image: Assets.figuresMobile,
        height: 200.h,
      ),
      // _CategoryCardData(
      //   title: 'Backend',
      //   count: 10,
      //   bgColor: const Color(0xFFE6FFF6),
      //   image: Assets.figuresBoyUsingLaptop,
      //   height: 220.h,
      // ),
      // _CategoryCardData(
      //   title: 'Design',
      //   count: 25,
      //   bgColor: const Color(0xFFE6F0FF),
      //   image: Assets.figuresRocketCloud,
      //   height: 180.h,
      // ),
      _CategoryCardData(
        title: 'AI/ML',
        count: 35,
        bgColor: const Color(0xFFFFE6E6),
        image: Assets.figuresRobot,
        height: 210.h,
      ),
      // _CategoryCardData(
      //   title: 'Managing',
      //   count: 15,
      //   bgColor: const Color(0xFFFFF9E6),
      //   image: Assets.figuresGuyReading,
      //   height: 190.h,
      // ),
      // _CategoryCardData(
      //   title: 'Frontend',
      //   count: 12,
      //   bgColor: const Color(0xFFE6E6FF),
      //   image: Assets.figuresFrontEngineering,
      //   height: 230.h,
      // ),
      _CategoryCardData(
        title: 'Security',
        count: 22,
        bgColor: const Color(0xFFE6FFF6),
        image: Assets.figuresSecurity,
        height: 170.h,
      ),
      _CategoryCardData(
        title: 'Others',
        count: 8,
        bgColor: const Color(0xFFF3E6FF),
        image: Assets.figuresGuyTextingLanding,
        height: 200.h,
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(Assets.iconsAtwLogoPurple,color: ColorsManager.mainColor,),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AtwWebViewScreen(),));
        },
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: ColorsManager.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                const GlobeAppbarWidget(),
                Positioned(
                  bottom: 20.h,
                  left: 0.w,
                  child: AppButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    isSecondary: true,
                    myText: 'Create your own podcast',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.createAIPodcastScreen,
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.allArticlesScreen);
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18.h,
                            crossAxisSpacing: 18.w,
                            childAspectRatio: 0.95,
                          ),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            PodcastTypes type;
                            switch (cat.title) {
                              case 'Mobility':
                                type = PodcastTypes.mobile;
                                break;
                              case 'AI/ML':
                                type = PodcastTypes.ai;
                                break;
                              case 'Security':
                                type = PodcastTypes.security;
                                break;
                              case 'Others':
                              default:
                                type = PodcastTypes.others;
                            }
                            return _CategoryCard(
                              data: cat,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArticlesScreen(type: type),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCardData {
  final String title;
  final int count;
  final Color bgColor;
  final String image;
  final double height;
  const _CategoryCardData({
    required this.title,
    required this.count,
    required this.bgColor,
    required this.image,
    required this.height,
  });
}

class _CategoryCard extends StatelessWidget {
  final _CategoryCardData data;
  final VoidCallback? onTap;
  const _CategoryCard({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: data.height,
        child: Container(
          decoration: BoxDecoration(
            color: data.bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PublicText(
                text: data.title,
                textTheme: TextStyles.font16WhiteSemiBold.copyWith(
                  color: ColorsManager.darkBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                color: ColorsManager.darkBlue,
                fontWeight: FontWeight.bold,
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: 6.h),
              // PublicText(
              //   text: '${data.count} Articles',
              //   textTheme: TextStyles.font12GrayRegular.copyWith(
              //     color: ColorsManager.gray,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 13.sp,
              //   ),
              //   color: ColorsManager.gray,
              //   fontWeight: FontWeight.normal,
              //   padding: EdgeInsets.zero,
              // ),
              SizedBox(
                height: 100.h,
                child: Image.asset(
                  data.image,
                  fit: BoxFit.fill,
                  height: 100.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
