import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum ArticleType {
  uiUx,
  backend,
  devOps,
}

class ArticleListItem extends StatelessWidget {
  final String title;
  final String time;
  final ArticleType articleType;

  const ArticleListItem({
    Key? key,
    required this.title,
    required this.time,
    required this.articleType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color itemColor;
    IconData itemIcon;

    switch (articleType) {
      case ArticleType.uiUx:
        itemColor = const Color(0xFF6F35A5);
        itemIcon = Icons.design_services;
        break;
      case ArticleType.backend:
        itemColor = const Color(0xFF9B8DCE);
        itemIcon = Icons.code;
        break;
      case ArticleType.devOps:
        itemColor = const Color(0xFFC4BEE2);
        itemIcon = Icons.settings;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: itemColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(itemIcon, color: itemColor, size: 24),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.more_vert,
          //     color: Colors.grey,
          //   ),
          // ),
        ],
      ),
    );
  }
}
