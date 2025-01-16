import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/arrow_back.dart';
import 'package:flutter/material.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ArrowBackCustom(),
            ],
          ),
        ),
      ),
    );
  }
}
