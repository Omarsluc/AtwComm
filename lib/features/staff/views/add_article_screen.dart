import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:atw_comm/core/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/helpers/spacing.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({Key? key}) : super(key: key);

  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final List<String> _labels = ['UI/UX', 'Development', 'Design'];
  String? _selectedPhoto;
  String? _selectedVideo;
  String? _selectedFile;

  void _showAddLabelDialog() {
    final TextEditingController labelController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add New Label'),
            content: TextField(
              controller: labelController,
              decoration: const InputDecoration(hintText: 'Enter label...'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (labelController.text.isNotEmpty) {
                    setState(() {
                      _labels.add(labelController.text);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      backgroundColor: ColorsManager.mainColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFE0DDFE),
                        child: Icon(Icons.person,
                            color: Colors.deepPurple, size: 32),
                      ),
                      const SizedBox(height: 8),
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
                  verticalSpace(10),
                  // Media/File Attach Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo, color: Colors.deepPurple),
                        tooltip: 'Add Photo',
                        onPressed: () async {
                          // TODO: Implement image picker
                          setState(() {
                            _selectedPhoto = 'photo_example.jpg';
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.videocam,
                            color: Colors.deepPurple),
                        tooltip: 'Add Video',
                        onPressed: () async {
                          // TODO: Implement video picker
                          setState(() {
                            _selectedVideo = 'video_example.mp4';
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file,
                            color: Colors.deepPurple),
                        tooltip: 'Add File',
                        onPressed: () async {
                          // TODO: Implement file picker
                          setState(() {
                            _selectedFile = 'file_example.pdf';
                          });
                        },
                      ),
                    ],
                  ),
                  // Preview selected files
                  if (_selectedPhoto != null ||
                      _selectedVideo != null ||
                      _selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (_selectedPhoto != null)
                            Chip(
                              avatar: const Icon(Icons.photo,
                                  color: Colors.deepPurple),
                              label: Text(_selectedPhoto!),
                              onDeleted: () =>
                                  setState(() => _selectedPhoto = null),
                            ),
                          if (_selectedVideo != null)
                            Chip(
                              avatar: const Icon(Icons.videocam,
                                  color: Colors.deepPurple),
                              label: Text(_selectedVideo!),
                              onDeleted: () =>
                                  setState(() => _selectedVideo = null),
                            ),
                          if (_selectedFile != null)
                            Chip(
                              avatar: const Icon(Icons.attach_file,
                                  color: Colors.deepPurple),
                              label: Text(_selectedFile!),
                              onDeleted: () =>
                                  setState(() => _selectedFile = null),
                            ),
                        ],
                      ),
                    ),
                  // Text Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFD9D4F8), width: 1.5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'write here',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Labels
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ..._labels
                          .map((label) => FilterChipWidget(label: label))
                          .toList(),
                      InkWell(
                        onTap: _showAddLabelDialog,
                        borderRadius: BorderRadius.circular(20),
                        child: Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          avatar: const Icon(Icons.add,
                              size: 18, color: Colors.deepPurple),
                          label: const Text('Add Label',
                              style: TextStyle(color: Colors.deepPurple)),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                          child: AppButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              myText: 'My Articles')),
                      horizontalSpace(20),
                      Expanded(
                          child: AppButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        myText: 'Staff Articles',
                        isSecondary: true,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
