// feature/patient/presentation/views/home/widget/specailize_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/feature/patient/presentation/views/home/data/cart_list.dart';
import 'package:flutter_application/feature/patient/presentation/views/home/widget/item_card_widget.dart';
import 'package:flutter_application/feature/patient/presentation/views/home/widget/specialization_search_screen.dart';

class SpecialistsBanner extends StatelessWidget {
  const SpecialistsBanner({super.key});

  @override
  Widget build(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("التخصصات", style: getTitleStyle(fontSize: 16)),
        SizedBox(
          height: 230,
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  push(
                      context,
                      SpecializationSearchScreen(
                        specialization: cards[index].specialization,
                      ));
                },
                child: ItemCardWidget(model: 
                    cards[index]),
              );
            },
          ),
        ),
      ],
    );
 
  }
}