// feature/doctor/presentation/profile/page/profile_view.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/feature/doctor/presentation/appointments/appointments_list.dart';
import 'package:flutter_application/feature/doctor/presentation/profile/widgets/text_widget.dart';
import 'package:flutter_application/feature/doctor/presentation/profile/page/user_setting.dart';
import 'package:flutter_application/feature/patient/presentation/views/search/widget/tile_widget.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfile extends StatefulWidget {
  DoctorProfile({
    super.key,
  });

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  String? _imagePath;
  File? file;
  String? profileUrl;
  String? userId;

  Future<void> _getUser() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    setState(() {
      userId = userID;
    });
  }

  Future<String> uploadImageToFirebaseStorage(File image) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://se7ety-119.appspot.com')
            .ref()
            .child('doctors/$userId');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blueColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الحساب الشخصي',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.settings,
              color: AppColors.whiteColor,
            ),
            onPressed: () {
              push(context, const UserSettings());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('doctors')
              .doc(userId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('حدث خطأ أثناء تحميل البيانات.'),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text('البيانات غير موجودة.'),
              );
            }

            var userData = snapshot.data!.data();
            print(userData?.update('uid', (value) => userId,
                ifAbsent: () => userId));

            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.whiteColor,
                              child: CircleAvatar(
                                backgroundColor: AppColors.whiteColor,
                                radius: 60,
                                backgroundImage: (userData?['image'] != null &&
                                        userData?['image'] != '')
                                    ? NetworkImage(userData?['image'])
                                    : (_imagePath != null)
                                        ? FileImage(File(_imagePath!))
                                            as ImageProvider
                                        : const AssetImage('assets/doc.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _pickImage();
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['name'] ?? 'غير معروف',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getTitleStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              (userData?['address'] == '')
                                  ? CustomButton(
                                      text: 'تعديل الحساب',
                                      height: 40,
                                      onPressed: () {},
                                    )
                                  : Text(
                                      userData?['address'] ?? 'غير معروف',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: getBodyStyle(),
                                    ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextWidget(
                      text: 'نبذه تعريفيه',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData?['bio'] == '' ? 'لم تضاف' : userData?['bio'],
                      style: getSmallStyle(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: "معلومات التواصل",
                    ),
                    const Gap(20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.accentColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TileWidget(
                              text: userData?['email'] ?? 'لم تضاف',
                              icon: Icons.email),
                          const Gap(15),
                          TileWidget(
                              text: userData?['phone1'] == ''
                                  ? 'لم تضاف'
                                  : userData?['phone2'] ?? 'لم تضاف',
                              icon: Icons.call),
                        ],
                      ),
                    ),
                    const Gap(30),
                    TextWidget(text: 'حجوزاتي'),
                    const Gap(30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 500, child: MyAppointmentList()),
                      ],
                    ),

                    //    const MyAppointmentList()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
