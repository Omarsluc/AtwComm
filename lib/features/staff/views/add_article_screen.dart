import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:atw_comm/core/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/Api/supabaseApi.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/utils/enums.dart';
import '../../../core/service/elevenlabs_service.dart';
import 'dart:typed_data';
import '../../../core/helpers/constants.dart';
import 'package:dio/dio.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({Key? key}) : super(key: key);

  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _articleController = TextEditingController();
  String? _selectedType;
  bool _isLoading = false;

  final Map<String, PodcastTypes> _typeMapping = {
    'Mobile': PodcastTypes.mobile,
    'AI/ML': PodcastTypes.ai,
    'Security': PodcastTypes.security,
    'Others': PodcastTypes.others,
  };

  Future<void> _createPodcast() async {
    if (_titleController.text.isEmpty ||
        _articleController.text.isEmpty ||
        _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authorName = await getCurrentUserName();
      if (authorName == null) {
        throw Exception('Could not get current user');
      }

      // 1. Create podcast entry in DB (without audio_url)
      final podcast = await createPodcast(
        title: _titleController.text,
        article: _articleController.text,
        type: podcastTypeToDbString(_typeMapping[_selectedType]!),
        authorName: authorName,
      );

      if (podcast == null) {
        throw Exception('Failed to create podcast');
      }

      // 2. Generate audio using ElevenLabs
      final ttsService = ElevenLabsService(apiKey: SharredKeys.elevenLabsKey);
      final String voiceId =
          'kdmDKE6EkgrWrrykO9Qt'; // Use your preferred voiceId
      Uint8List? audioBytes;
      try {
        audioBytes = await ttsService.textToSpeech(
          text: _articleController.text,
          voiceId: voiceId,
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Audio generation failed: Unauthorized. Please contact support.')),
          );
          audioBytes = null;
        } else {
          rethrow;
        }
      }

      if (audioBytes != null) {
        // 3. Upload audio to Supabase Storage
        final String fileName =
            'podcast_${podcast['id'] ?? DateTime.now().millisecondsSinceEpoch}.mp3';
        final audioUrl =
            await uploadAudioToSupabaseStorage(audioBytes, fileName);

        // 4. Update podcast entry with audio_url if upload succeeded
        if (audioUrl != null && podcast['id'] != null) {
          await supabase
              .from('podcasts')
              .update({'audio_url': audioUrl}).eq('id', podcast['id']);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Podcast created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      backgroundColor: ColorsManager.mainColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFE0DDFE),
                        child: Icon(Icons.person,
                            color: Colors.deepPurple, size: 32),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 350.w,
                        child: Text(
                          'Got something valuable to say?',
                          style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Start writing your article',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  // Title Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFD9D4F8), width: 1.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter title...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  verticalSpace(16),
                  // Article Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFD9D4F8), width: 1.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _articleController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Write your article here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  verticalSpace(16),
                  // Type Selection
                  Text(
                    'Select Type',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  verticalSpace(8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _typeMapping.keys.map((type) {
                      final isSelected = type == _selectedType;
                      return FilterChip(
                        selected: isSelected,
                        label: Text(type),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedType = selected ? type : null;
                          });
                        },
                        backgroundColor: isSelected
                            ? ColorsManager.mainColor
                            : Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  verticalSpace(32),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      myText: _isLoading ? 'Creating...' : 'Create Podcast',
                      onPressed: _isLoading ? null : _createPodcast,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _articleController.dispose();
    super.dispose();
  }
}
