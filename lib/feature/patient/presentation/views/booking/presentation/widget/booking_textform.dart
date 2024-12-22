// feature/patient/presentation/views/booking/presentation/widget/booking_textform.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';

class BookingTextform extends StatelessWidget {
  const BookingTextform({
    super.key,
    required this.nameController,
    required this.validator,
    required this.text,
    this.keyboardType,
    this.contentPadding,
    this.readonly = false,
  });
  final TextEditingController? nameController;
  final String? Function(String?)? validator;
  final String text;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      readOnly: readonly,
      keyboardType: keyboardType ?? TextInputType.name,
      controller: nameController,
      validator: validator,
      style: getBodyStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: text,
        filled: true,
        fillColor: AppColors.grayColor.withOpacity(.2),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
