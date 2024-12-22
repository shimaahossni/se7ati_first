// feature/doctor/presentation/profile/widgets/text_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/text_style.dart';

class TextWidget extends StatelessWidget {
   TextWidget({super.key,required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getBodyStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
