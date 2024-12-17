// feature/auth/login/presentation/widget/doctor_register_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';

class DoctorRegisterButton extends StatelessWidget {
  DoctorRegisterButton({super.key, required this.onPressed,required this.text});
  Function()? onPressed;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 25.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blueColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: getTitleStyle(fontSize: 16, color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
