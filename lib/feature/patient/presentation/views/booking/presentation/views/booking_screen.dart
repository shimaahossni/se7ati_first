// feature/patient/presentation/views/booking/presentation/views/booking_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/alert_dialog.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/feature/patient/presentation/views/booking/presentation/widget/booking_text.dart';
import 'package:flutter_application/feature/patient/presentation/views/booking/presentation/widget/booking_textform.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/core/widgets/doctor_card.dart';
import 'package:flutter_application/feature/auth/login/data/doctor_model.dart';
import 'package:flutter_application/feature/patient/presentation/views/booking/data/available_appointments.dart';
import 'package:flutter_application/feature/patient/presentation/views/nav_bar/nav_bar_screen.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final DoctorModel doctor;
  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TimeOfDay currentTime = TimeOfDay.now();
  String? bookingHour;
  int selectedIndex = -1;
  User? user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  List<int> times = [];

  @override
  void initState() {
    super.initState();
    _getUser();
    nameController = TextEditingController(text: user?.displayName);
    phoneController = TextEditingController(text: user?.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.blueColor,
        foregroundColor: AppColors.whiteColor,
        title: const Text(
          'احجز مع دكتورك',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              //doctor card
              DoctorCard(
                doctor: widget.doctor,
                isClickable: false,
              ),
              const Gap(20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      '-- ادخل بيانات الحجز --',
                      style: getTitleStyle(),
                    ),
                    const Gap(20),
                    //name
                    const BookingText(
                      text: 'اسم المريض',
                    ),
                    BookingTextform(
                      nameController: nameController,
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل اسم المريض';
                        return null;
                      },
                      text: 'ادخل اسم المريض',
                    ),
                    const Gap(20),

                    //phone
                    const BookingText(text: 'رقم الهاتف'),
                    BookingTextform(
                        nameController: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل رقم الهاتف';
                          } else if (value.length < 10) {
                            return 'يرجي ادخال رقم هاتف صحيح';
                          }
                          return null;
                        },
                        text: 'ادخل رقم الهاتف'),

                    const Gap(10),

                    //description
                    const BookingText(text: 'وصف الحاله'),
                    BookingTextform(
                      nameController: descriptionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل وصف الحاله';
                        }
                        return null;
                      },
                      text: 'ادخل وصف الحاله',
                    ),

                    const Gap(10),
                    //date
                    const BookingText(text: 'تاريخ الحجز'),

                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        selectDate(context);
                      },
                      controller: dateController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل تاريخ الحجز';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      style: getBodyStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'ادخل تاريخ الحجز',
                        filled: true,
                        fillColor: AppColors.grayColor.withOpacity(.2),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.blueColor,
                            radius: 25,
                            child: Icon(
                              Icons.date_range_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'وقت الحجز',
                            style: getBodyStyle(color: AppColors.blackColor),
                          )
                        ],
                      ),
                    ),
                    Wrap(
                        spacing: 8.0,
                        children: times.map((hour) {
                          return ChoiceChip(
                            backgroundColor: AppColors.accentColor,
                            checkmarkColor: AppColors.whiteColor,
                            selectedColor: AppColors.blueColor,
                            label: Text(
                              '${(hour < 10) ? '0' : ''}${hour.toString()}:00',
                              style: TextStyle(
                                color: hour == selectedIndex
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                              ),
                            ),
                            selected: hour == selectedIndex,
                            onSelected: (selected) {
                              setState(() {
                                selectedIndex = hour;
                                bookingHour =
                                    '${(hour < 10) ? '0' : ''}${hour.toString()}:00'; // hh:mm
                              });
                            },
                          );
                        }).toList()),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: 'تأكيد الحجز',
          onPressed: () {
            if (_formKey.currentState!.validate() && selectedIndex != -1) {
              _createAppointment();

              showAlertDialog(
                context,
                title: 'تم تسجيل الحجز !',
                ok: 'اضغط للانتقال',
                onTap: () {
                  pushAndRemoveUntil(context, const NavBarScreen());
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('pending')
        .doc()
        .set({
      'patientID': user!.email,
      'doctorID': widget.doctor.email,
      'name': nameController.text,
      'phone': phoneController.text,
      'description': descriptionController.text,
      'doctor': widget.doctor.name,
      'location': widget.doctor.address,
      'date': DateTime.parse(
          '${dateController.text} ${bookingHour!}:00'), // yyyy-MM-dd HH:mm:ss
      'isComplete': false,
      'rating': null
    }, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('all')
        .doc()
        .set({
      'patientID': user!.email,
      'doctorID': widget.doctor.email,
      'name': nameController.text,
      'phone': phoneController.text,
      'description': descriptionController.text,
      'doctor': widget.doctor.name,
      'location': widget.doctor.address,
      'date': DateTime.parse('${dateController.text} ${bookingHour!}:00'),
      'isComplete': false,
      'rating': null
    }, SetOptions(merge: true));
  }

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 5)),
    ).then(
      (date) {
        if (date != null) {
          setState(
            () {
              dateController.text = DateFormat('yyyy-MM-dd')
                  .format(date); // to send the date to firebase
              times = getAvailableAppointments(
                  date,
                  widget.doctor.openHour ?? "0",
                  widget.doctor.closeHour ?? "0");
            },
          );
        }
      },
    );
  }
}
