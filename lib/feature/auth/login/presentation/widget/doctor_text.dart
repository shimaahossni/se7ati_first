// feature/auth/login/presentation/widget/doctor_text.dart
// feature/auth/login/presentation/widget/doctor_text.dartst
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';

class DoctorText extends StatelessWidget {
   DoctorText({super.key,required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getBodyStyle(
          color: AppColors.blackColor, fontWeight: FontWeight.bold),
    );
  }
}
