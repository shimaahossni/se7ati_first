// feature/auth/login/presentation/view/signup_view.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application/core/enums/user_type_enum.dart';
import 'package:flutter_application/core/functions/dialogs.dart';
import 'package:flutter_application/core/functions/email_validate.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/feature/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application/feature/auth/login/presentation/view/doctor_register_view.dart';
import 'package:flutter_application/feature/auth/login/presentation/view/login_view.dart';
import 'package:flutter_application/feature/patient/presentation/views/nav_bar/nav_bar_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key, required this.userType});
  final UserType userType;

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisable = true;

  String handleUserType() {
    return widget.userType == UserType.doctor ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessstate) {
            if (widget.userType == UserType.doctor) {
              pushAndRemoveUntil(context, const DoctorRegisterView());
            } else {
              pushReplacement(context, const NavBarScreen());
            }
          } else if (state is AuthErrorState) {
            Navigator.pop(context);
            showErrorDialog(context, state.error);
          } else if (state is RegisterLoadingstate) {
            showLoadingDialog(context);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سجل حساب جديد كـ "${handleUserType()}"',
                      style: getTitleStyle(),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _displayName,
                      style: const TextStyle(
                        color: AppColors.blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'الاسم',
                        hintStyle: getBodyStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل الاسم';
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: 'user@example.com',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل الايميل';
                        } else if (!emailValidate(value)) {
                          return 'من فضلك ادخل الايميل صحيحا';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: AppColors.blackColor),
                      obscureText: isVisable,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: '********',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisable = !isVisable;
                              });
                            },
                            icon: Icon((isVisable)
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_rounded)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل كلمة السر';
                        return null;
                      },
                    ),
                    const Gap(30),
                    CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(RegisterEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _displayName.text,
                              userType: widget.userType));
                        }
                      },
                      text: "تسجيل حساب",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لدي حساب ؟',
                            style: getBodyStyle(color: AppColors.blackColor),
                          ),
                          TextButton(
                              onPressed: () {
                                pushReplacement(context,
                                    LoginView(userType: widget.userType));
                              },
                              child: Text(
                                'سجل دخول',
                                style: getBodyStyle(color: AppColors.blueColor),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
