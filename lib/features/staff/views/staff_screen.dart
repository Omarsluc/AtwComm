import 'package:atw_comm/core/helpers/extention.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/article_list_item.dart';
import '../../../generated/assets.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person,
                      color: ColorsManager.mainColor, size: 32.sp),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Omar',
                      style: GoogleFonts.montserrat(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'What are you up to today?',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // New Article Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Quarter circle background
                      Positioned(
                        top: -300.h,
                        right: 40.w,
                        child: Align(
                          alignment: Alignment.topLeft,
                          widthFactor: 0.5,
                          heightFactor: 0.5,
                          child: Container(
                            width: 400.w,
                            height: 400.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Article !',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Got something valuable?',
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.white70),
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    height: 36.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF8B5CF6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        context.pushNamed(Routes.addArticleScreen);
                                      },
                                      child: const Text('Start writing',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Placeholder for illustration
                            SizedBox(
                              width: 110.h,
                              height: 110.w,
                              child: Image.asset(
                                Assets.figuresGuyReading,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search..',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Articals',
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      'View All',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Chips
                Row(
                  children: [
                    FilterChip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      label: const Text('All'),
                      selected: false,
                      onSelected: (_) {},
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      label: const Text('Design'),
                      selected: true,
                      onSelected: (_) {},
                      selectedColor: const Color(0xFF8B5CF6),
                      backgroundColor: Colors.grey[200],
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      label: const Text('Programming'),
                      selected: false,
                      onSelected: (_) {},
                      backgroundColor: Colors.grey[200],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Article List
                Expanded(
                  child: ListView(
                    children: [
                      ArticleListItem(
                        articleType: ArticleType.uiUx,
                        title: 'Ui Ux Artical',
                        time: '5h 15m',
                      ),
                      ArticleListItem(
                        articleType: ArticleType.backend,
                        title: 'Backend',
                        time: '10h 30m',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}