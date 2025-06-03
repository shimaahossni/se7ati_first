// ../../../../git_app/se7ati_first/lib/feature/doctor/presentation/profile/page/user_details.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:gap/gap.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  List labelName = ["الاسم", "رقم الهاتف", "المدينة", "نبذه تعريفية", "التخصص"];

  List value = ["name", "phone2", "address", "bio", "specialization"];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.blueColor,
        foregroundColor: AppColors.whiteColor,
        title: const Text('اعدادات الحساب',
            style: TextStyle(color: AppColors.whiteColor)),
      ),
      
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var userData = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: labelName.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      var con = TextEditingController(
                          text: userData?[value[index]] == '' ||
                                  userData?[value[index]] == null
                              ? 'لم تضاف'
                              : userData?[value[index]]);
                      var form = GlobalKey<FormState>();
                      return SimpleDialog(
                        alignment: Alignment.center,
                        contentPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),),
                        children: [
                          Form(
                            key: form,
                            child: Column(
                              children: [
                                Text(
                                  'ادخل ${labelName[index]}',
                                  style:
                                      getBodyStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: con,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.whiteColor),
                                  // decoration: InputDecoration(
                                  //     hintText: value[index]),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'من فضلك ادخل ${labelName[index]}.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomButton(
                                  text: 'حفظ التعديل',
                                  onPressed: () {
                                    if (form.currentState!.validate()) {
                                      updateData(value[index], con.text);
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.accentColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labelName[index],
                        style: getBodyStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Gap(20),
                      Flexible(
                        child: Text(
                          userData?[value[index]] == '' ||
                                  userData?[value[index]] == null
                              ? 'Not Added'
                              : userData?[value[index]],
                          style: getBodyStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateData(String key, value) async {
    FirebaseFirestore.instance.collection('doctors').doc(user!.uid).update({
      key: value,
    });
    if (key == "name") {
      await user?.updateDisplayName(value);
    }
    Navigator.pop(context);
  }
}
