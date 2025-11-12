import 'package:atw_comm/core/service/textToSpeach.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:atw_comm/features/articles/logic/article_cubit.dart';
import 'package:atw_comm/features/articles/model/podcast_model.dart';
import 'package:atw_comm/features/staff/views/widgets/add_new_article_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/Api/supabaseApi.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/consts.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/article_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../articles/views/play_podcast_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  PodcastTypes? selectedType;
  bool isLoading = false;
  List<Podcast> podcasts = [];

  final Map<String, PodcastTypes?> _typeMapping = {
    'All': null,
    'Mobile': PodcastTypes.mobile,
    'Security': PodcastTypes.security,
    'Others' : PodcastTypes.others
  };

  Future<void> _fetchPodcasts(PodcastTypes? type) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (type == null) {
        podcasts = await fetchAllPodcasts();
      } else {
        final dbType = podcastTypeToDbString(type);
        podcasts = await fetchPodcastsByType(dbType);
      }
    } catch (e) {
      print('Error fetching podcasts: $e');
      podcasts = [];
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sayWelcomingSentence () {
    TextToSpeechService.speak(text: 'Hello, ${userNameIdentified ?? ''}');
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      userNameIdentified = null;
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.redAccent,
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Unable to sign out right now. Please try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial podcasts
    _fetchPodcasts(null);
    _sayWelcomingSentence();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person,
                            color: ColorsManager.mainColor, size: 32.sp),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${userNameIdentified ?? ''}',
                              style: GoogleFonts.montserrat(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'What are you up to today?',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout),
                        color: ColorsManager.mainColor,
                        tooltip: 'Sign out',
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // New Article Card
                  AddNewArticleCardWidget(),
                  SizedBox(height: 24.h),
                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Articles',
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.allArticlesScreen);
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _typeMapping.entries.map((entry) {
                        final bool isSelected = selectedType == entry.value;
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: Text(entry.key),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedType = selected ? entry.value : null;
                              });
                              _fetchPodcasts(selected ? entry.value : null);
                            },
                            selectedColor: ColorsManager.mainColor,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Podcasts List
                  if (isLoading)
                    Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: ArticleListItem(
                              onTap: () {},
                              articleType: ArticleType.uiUx,
                              title: 'Loading...',
                              time: '---',
                            ),
                          );
                        },
                      ),
                    )
                  else if (podcasts.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 40.h),
                        child: Text(
                          'No podcasts found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: podcasts.length,
                      itemBuilder: (context, index) {
                        final Podcast podcast = podcasts[index];
                        return ArticleListItem(
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
                          articleType: ArticleType.uiUx,
                          title: podcast.title,
                          time:
                              '${DateTime.parse(podcast.createdAt.toString()).difference(DateTime.now()).inHours.abs()}h ago',
                        );
                      },
                    ),
                  SizedBox(height: 86.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
