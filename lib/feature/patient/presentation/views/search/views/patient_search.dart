// feature/patient/presentation/views/search/views/patient_search.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/feature/patient/presentation/views/search/widget/search_list.dart';
import 'package:gap/gap.dart';

class PatientSearch extends StatefulWidget {
  const PatientSearch({super.key});

  @override
  State<PatientSearch> createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.blueColor,
        title: const Text(
          'ابحث عن دكتور',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  )
                ],
              ),
              child: TextField(
                cursorHeight: 20,
                onChanged: (searchKey) {
                  setState(
                    () {
                      search = searchKey;
                    },
                  );
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.blue[50],
                  filled: true,
                  border: InputBorder.none,
                  hintText: "البحث",
                  hintStyle:
                      getBodyStyle(fontSize: 20, color: AppColors.grayColor),
                  suffixIcon: const SizedBox(
                      width: 50,
                      child: Icon(Icons.search, color: AppColors.blueColor)),
                ),
              ),
            ),
            const Gap(15),
            Expanded(
              child: SearchList(
                searchKey: search,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
