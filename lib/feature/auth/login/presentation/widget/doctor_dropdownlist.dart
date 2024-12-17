// feature/auth/login/presentation/widget/doctor_dropdownlist.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';

class DoctorDropDownList extends StatelessWidget {
  DoctorDropDownList({super.key,required this.onChanged,required this.value,required this.items});
  Function(dynamic)? onChanged;
  String? value;
  List<DropdownMenuItem<String>>? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(20)),
      child: DropdownButton(
        isExpanded: true,
        iconEnabledColor: AppColors.blueColor,
        icon: const Icon(Icons.expand_circle_down_outlined),
        value: value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
