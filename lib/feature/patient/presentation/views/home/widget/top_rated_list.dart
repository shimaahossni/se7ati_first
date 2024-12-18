// feature/patient/presentation/views/home/widget/top_rated_list.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/widgets/doctor_card.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_model.dart';

class TopRatedList extends StatelessWidget {
  const TopRatedList({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                value: .9,
                color: Colors.black12,
              ),
            );
          } else {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DoctorModel doctor = DoctorModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );
                if (doctor.specialization == '') {
                  return const SizedBox();
                }
                return DoctorCard(
                  doctor: doctor,
                );
              },
            );
          }
        },
      ),
    );
  
  }
}