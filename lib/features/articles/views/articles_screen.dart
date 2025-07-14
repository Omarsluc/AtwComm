import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/Api/supabaseApi.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? category =
        ModalRoute.of(context)?.settings.arguments as String?;
    final List<Color> colors = [
      const Color(0xFFFF7A4D),
      const Color(0xFFB7E28A),
      const Color(0xFF4DFF8C),
      const Color(0xFF4DB8FF),
      const Color(0xFF8C8CFF),
    ];
    // Map display category to DB type if needed
    String? podcastType = category;
    // Example: if display name and type differ, map here
    // if (category == 'AI & ML') podcastType = 'ai_ml';

    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      appBar: CustomAppBar(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category != null ? '$category Podcasts' : 'All Podcasts',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: podcastType != null
                      ? fetchPodcastsByType(podcastType)
                      : Future.value([]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: \\${snapshot.error}'));
                    }
                    final podcasts = snapshot.data ?? [];
                    if (podcasts.isEmpty) {
                      return const Center(child: Text('No podcasts found.'));
                    }
                    return ListView.separated(
                      itemCount: podcasts.length,
                      separatorBuilder: (_, __) => SizedBox(height: 18.h),
                      itemBuilder: (context, index) {
                        final podcast = podcasts[index];
                        return _PodcastItem(
                          number: index + 1,
                          color: colors[index % colors.length],
                          title: podcast['title'] ?? '',
                          subtitle: podcast['article'] ?? '',
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
    );
  }
}

class _PodcastItem extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  final String subtitle;
  const _PodcastItem({
    required this.number,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 16.w),
        Container(
          width: 54.w,
          height: 54.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
