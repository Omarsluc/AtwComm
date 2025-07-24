import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:atw_comm/core/widgets/article_list_item.dart';
import 'package:atw_comm/features/articles/logic/article_cubit.dart';
import 'package:atw_comm/features/articles/model/podcast_model.dart';
import 'package:atw_comm/features/articles/views/play_podcast_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/Api/supabaseApi.dart';

class AllArticlesScreen extends StatefulWidget {
  const AllArticlesScreen({super.key});

  @override
  State<AllArticlesScreen> createState() => _AllArticlesScreenState();
}

class _AllArticlesScreenState extends State<AllArticlesScreen> {
  bool isLoading = true;
  List<Podcast> podcasts = [];

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => isLoading = true);
    podcasts = await fetchAllPodcasts();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Text('User Experience Articles',
                        style: TextStyles.font20BlackBold),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Text(
                      'Start your learning Journey',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Skeletonizer(
                            enabled: true,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 20.h),
                              itemCount: 6,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16.h),
                              itemBuilder: (context, index) {
                                return ArticleListItem(
                                  onTap: () {},
                                  title: 'Loading...',
                                  time: '---',
                                  articleType: ArticleType.uiUx,
                                );
                              },
                            ),
                          )
                        : podcasts.isEmpty
                            ? Center(
                                child: Text(
                                  'No articles found',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                itemCount: podcasts.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 16.h),
                                itemBuilder: (context, index) {
                                  final podcast = podcasts[index];
                                  return ArticleListItem(
                                    title: podcast.title,
                                    time:
                                        '${DateTime.now().difference(podcast.createdAt).inHours.abs()}h ago', // You can calculate or fetch real duration if available
                                    articleType: ArticleType.uiUx,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (context) => ArticleCubit(),
                                            child: PlayPodcastScreen(
                                              podcast: podcast,
                                            ),
                                          ),
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
        ],
      ),
    );
  }
}
