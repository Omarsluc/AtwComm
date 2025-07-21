import 'package:atw_comm/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/routes.dart';
import '../../../../generated/assets.dart';

class AddNewArticleCardWidget extends StatelessWidget {
  const AddNewArticleCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
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
                            fontSize: 14.sp,
                            color: Colors.white70),
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
                            context.pushNamed(
                                Routes.addArticleScreen);
                          },
                          child: const Text('Start writing',
                              style:
                              TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
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
    );
  }
}
