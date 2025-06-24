import 'package:atw_comm/core/helpers/spacing.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/article_list_item.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/assets.dart';

class AllArticlesScreen extends StatelessWidget {
  const AllArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with globe decoration
            Container(
              height: 300.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsManager.mainColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Back button and profile
                  CustomAppBar(),
                  // Globe image
                  Positioned(
                    right: 0,
                    top: 20.h,
                    child: Image.asset(
                      Assets.figuresWorldGlobeBooks,
                      height: 280.h,
                    ),
                  ),
                ],
              ),
            ),
            // Articles List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  itemCount: 10, // Replace with actual article count
                  itemBuilder: (context, index) {
                    final articleTypes = ArticleType.values;
                    final articleType = articleTypes[index % articleTypes.length];
                    String title;
                    switch (articleType) {
                      case ArticleType.uiUx:
                        title = 'UI UX Article';
                        break;
                      case ArticleType.backend:
                        title = 'Backend';
                        break;
                      case ArticleType.devOps:
                        title = 'DevOps';
                        break;
                    }

                    return ArticleListItem(
                      title: title,
                      time: '2h 15m',
                      articleType: articleType,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
