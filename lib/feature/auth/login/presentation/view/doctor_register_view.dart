// feature/auth/login/presentation/view/doctor_register_view.dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/core/functions/dialogs.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_model.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_specialization_list.dart';
import 'package:flutter_application/feature/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application/feature/auth/login/presentation/widget/doctor_container.dart';
import 'package:flutter_application/feature/auth/login/presentation/widget/doctor_dropdownlist.dart';
import 'package:flutter_application/feature/auth/login/presentation/widget/doctor_register_button.dart';
import 'package:flutter_application/feature/auth/login/presentation/widget/doctor_text.dart';
import 'package:flutter_application/feature/doctor/presentation/doctor_home_reg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DoctorRegisterView extends StatefulWidget {
  const DoctorRegisterView({super.key});

  @override
  State<DoctorRegisterView> createState() => _DoctorRegisterViewState();
}

class _DoctorRegisterViewState extends State<DoctorRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone1 = TextEditingController();
  final TextEditingController _phone2 = TextEditingController();
  String _specialization = specialization[0];

  late String _startTime =
      DateFormat('hh').format(DateTime(2023, 9, 7, 12, 00));
  late String _endTime = DateFormat('hh').format(DateTime(2023, 9, 7, 23, 00));

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  File? file;
  String? profileUrl;

  String? userID;

  Future<void> _getUser() async {
    userID = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String> uploadImageToFirebaseStorage(File image) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://se7ety-119.appspot.com')
            .ref()
            .child('doctors/$userID');
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DoctorRegisterationSuccessstate) {
          Navigator.pop(context);
          pushReplacement(context, const DoctorHomeReg());
        } else if (state is AuthErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.error);
        } else if (state is DoctorRegisterationLoadingstate) {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: AppColors.blueColor,
          title: const Text('إكمال عملية التسجيل',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          //-------------------------------------------upload image
                          CircleAvatar(
                            radius: 50,
                            child: CircleAvatar(
                              backgroundColor: AppColors.accentColor,
                              radius: 60,
                              backgroundImage: (file != null)
                                  ? FileImage(file!) as ImageProvider
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        child: Row(
                          children: [
                            //-------------------------------------------التخصص
                            DoctorText(text: "التخصص"),
                          ],
                        ),
                      ),
                      DoctorDropDownList(
                        value: _specialization,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _specialization = newValue ?? specialization[0];
                          });
                        },
                        items: specialization.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      //-------------------------------------------النبذة التعريفية
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            DoctorText(text: 'نبذة تعريفية'),
                          ],
                        ),
                      ),

                      DoctorContainer(
                        bioController: _bio,
                        hinttext:
                            'سجل المعلومات الطبية العامة مثل تعليمك الأكاديمي وخبراتك السابقة...',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل النبذة التعريفية';
                          } else {
                            return null;
                          }
                        },
                        maxlines: 5,
                      ),

                      //-------------------------------------------عنوان العيادة
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            DoctorText(text: 'عنوان العيادة'),
                          ],
                        ),
                      ),
                      DoctorContainer(
                        bioController: _address,
                        hinttext: ' شارع ابي رضا المقري - الرياض - الرياض',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل عنوان العيادة';
                          } else {
                            return null;
                          }
                        },
                      ),

                      //------------------------------------------- ساعات العمل
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  DoctorText(text: 'ساعات العمل من'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  DoctorText(text: 'الي'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //  Start Time
                          Expanded(
                            child: DoctorContainer(
                              hinttext: _startTime,
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    await showStartTimePicker();
                                  },
                                  icon: const Icon(
                                    Icons.watch_later_outlined,
                                    color: AppColors.blueColor,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          //  End Time
                          Expanded(
                            child: DoctorContainer(
                              hinttext: _endTime,
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    await showStartTimePicker();
                                  },
                                  icon: const Icon(
                                    Icons.watch_later_outlined,
                                    color: AppColors.blueColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            DoctorText(text: 'رقم الهاتف 1'),
                          ],
                        ),
                      ),
                      DoctorContainer(
                        bioController: _phone1,
                        hinttext: '20xxxxxxxxxx+',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(12),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الرقم';
                          } else {
                            return null;
                          }
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            DoctorText(text: 'رقم الهاتف 2 (اختياري)'),
                          ],
                        ),
                      ),
                      DoctorContainer(
                        bioController: _phone2,
                        hinttext: '20xxxxxxxxxx+',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(12),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الرقم';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: DoctorRegisterButton(
          text: 'تسجيل',
          onPressed: () async {
            if (_formKey.currentState!.validate() && file != null) {
              profileUrl = await uploadImageToFirebaseStorage(file!);
              context.read<AuthBloc>().add(UpdateDoctorDataEvent(
                      doctorModel: DoctorModel(
                    uid: userID ?? '',
                    image: profileUrl ?? '',
                    phone1: _phone1.text,
                    phone2: _phone2.text,
                    address: _address.text,
                    specialization: _specialization,
                    openHour: _startTime,
                    closeHour: _endTime,
                    bio: _bio.text,
                  )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('من فضلك قم بتحميل صورة الملف الشخصي'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  showStartTimePicker() async {
    final datePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (datePicked != null) {
      setState(() {
        _startTime = datePicked.hour.toString();
        print(_startTime);
      });
    }
  }

  showEndTimePicker() async {
    final timePicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );

    if (timePicker != null) {
      setState(() {
        _endTime = timePicker.hour.toString();
      });
    }
  }
}
