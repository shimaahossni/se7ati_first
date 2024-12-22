// core/widgets/textfieldflorm_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';

@immutable
class TextfieldflormWidget extends StatelessWidget {
  TextfieldflormWidget({
    super.key,
    this.hinttext,
    this.fontsize,
    //this.prefixicon,
    this.labeltext,
    this.suffixIcon,
    this.isobsecure,
    this.validator,
    this.onChanged,
    this.controller,
    this.onTap,
    this.keyboardType,
    this.maxLength,
    this.suffixIconHeight,
    this.fillColor,
    this.readOnly,
    this.border,
  });

  final String? hinttext;
  final String? labeltext;
  final Widget? suffixIcon;
  final double? fontsize;
  //final IconData? prefixicon;
  final bool? isobsecure;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool? readOnly;
  final double? suffixIconHeight;
  final Color? fillColor;
  final InputBorder? border;

  @override
  Widget build(BuildContext context) {
    Size mediaquery = MediaQuery.of(context).size;

    return TextFormField(
      
      readOnly: readOnly ?? false,
      maxLength: maxLength,
      obscureText: isobsecure!,
      validator: validator,
      onChanged: (value) => onChanged!(value),
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: fontsize ?? 15,
      ),
      decoration: InputDecoration(
        
          filled: true,
          fillColor: fillColor,
          hintText: hinttext,
          labelText: labeltext,
          contentPadding: const EdgeInsets.all(20.0),
          suffixIcon: suffixIcon,
          suffixIconConstraints:
              BoxConstraints(maxHeight: suffixIconHeight ?? 40),
          labelStyle:
              TextStyle(fontSize: mediaquery.height * 0.02, color: Colors.grey),
          border: border ??
              const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: mediaquery.height * 0.017,
          )),
    );
  }
}
