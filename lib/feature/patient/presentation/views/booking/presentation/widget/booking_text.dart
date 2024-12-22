// feature/patient/presentation/views/booking/presentation/widget/booking_text.dart
import 'package:flutter/material.dart';

class BookingText extends StatelessWidget {
  const BookingText({super.key,required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            text,
            style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
