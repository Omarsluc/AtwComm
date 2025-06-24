import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  const FilterChipWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      onDeleted: () {},
      backgroundColor: const Color(0xFFEAE5F3),
      labelStyle: const TextStyle(color: Color(0xFF6F35A5)),
      deleteIconColor: const Color(0xFF6F35A5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    );
  }
}