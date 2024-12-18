// feature/patient/presentation/views/profile/presentation/views/patient_profile_screen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/feature/patient/presentation/views/profile/presentation/widget/appointment_history.dart';
import 'package:flutter_application/feature/patient/presentation/views/profile/presentation/views/user_setting.dart';
import 'package:flutter_application/feature/patient/presentation/views/search/widget/tile_widget.dart';
import 'package:image_picker/image_picker.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  String? _imagePath;
  File? file;
  String? profileUrl;
  String? userId;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
        print(userId);
      });
    }
  }

  uploadImageToFireStore(File image, String imageName) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://se7ety-119.appspot.com')
            .ref()
            .child('patients/${FirebaseAuth.instance.currentUser!.uid}');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
          file = File(pickedFile.path);
        });

        if (file != null) {
          profileUrl = await uploadImageToFireStore(file!, 'doc');
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(userId)
              .update({'image': profileUrl});
        }
      }
    } catch (e) {
      debugPrint("Error while picking or uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueColor,
        elevation: 0,
        title: const Text(
          'الحساب الشخصي',
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
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('patients')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
             //   print(snapshot.data);
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userData = snapshot.data;
              print(userData);
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
                                    radius: 55,
                                    backgroundImage:
                                        (userData?['image'] != null &&
                                                userData?['image'] != '')
                                            ? NetworkImage(userData!['image'])
                                            : (_imagePath != null)
                                                ? FileImage(File(_imagePath!))
                                                    as ImageProvider
                                                : const AssetImage(
                                                    'assets/doc.png'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _pickImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 20,
                                      // color: AppColors.color1,
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
                                    "${userData!['name']}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTitleStyle(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  (userData['city'] == '')
                                      ? CustomButton(
                                          text: 'تعديل الحساب',
                                          height: 40,
                                          onPressed: () {},
                                        )
                                      : Text(
                                          userData['city'],
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
                        Text(
                          "نبذه تعريفيه",
                          style: getBodyStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          userData['bio'] == '' ? 'لم تضاف' : userData['bio'],
                          style: getSmallStyle(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "معلومات التواصل",
                          style: getBodyStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                                  text: userData['email'] ?? 'لم تضاف',
                                  icon: Icons.email),
                              const SizedBox(
                                height: 15,
                              ),
                              TileWidget(
                                  text: userData['phone'] == ''
                                      ? 'لم تضاف'
                                      : userData['phone'],
                                  icon: Icons.call),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "حجوزاتي",
                          style: getBodyStyle(fontWeight: FontWeight.w600),
                        ),
                        const MyAppointmentsHistory()
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
