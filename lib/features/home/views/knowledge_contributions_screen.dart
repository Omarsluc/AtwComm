import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/features/home/logic/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blog_detail_screen.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/arrow_back.dart';
import '../logic/search_state.dart';

class CustomReadButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomReadButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Read',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Blog {
  final String title;
  final String intro;
  final String content;
  final String author;
  final String? imageUrl;

  Blog({
    required this.title,
    required this.intro,
    required this.content,
    required this.author,
    this.imageUrl,
  });
}

class KnowledgeContributionScreen extends StatelessWidget {
  const KnowledgeContributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample blog data
    final blogs = [
      Blog(
        title: 'Flutter State Management',
        intro: 'A quick overview of state management approaches in Flutter.',
        content:
            'Flutter offers several ways to manage state... (full content here)',
        author: 'Jane Doe',
        imageUrl: null,
      ),
      Blog(
        title: 'Dart Null Safety',
        intro: 'Understanding null safety in Dart and how it helps.',
        content:
            'Null safety is a major addition to Dart... (full content here)',
        author: 'John Smith',
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.colorBlack,
        leading: ArrowBackCustom(),
        title: Text(
          '    Blogs',
          style: TextStyles.font16WhiteMedium,
        ),
      ),
      backgroundColor: ColorsManager.colorBlack,
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blog.intro,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomReadButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetailScreen(blog: blog),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
