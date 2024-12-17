// feature/auth/login/presentation/view/login_view.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/enums/user_type_enum.dart';
import 'package:flutter_application/core/functions/dialogs.dart';
import 'package:flutter_application/core/functions/email_validate.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/functions/password_validation.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/feature/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application/feature/auth/login/presentation/view/signup_view.dart';
import 'package:flutter_application/feature/home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.userType});
  final UserType userType;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isVisable = true;

  String handleUserType() {
    return widget.userType == UserType.doctor ? 'دكتور' : 'مريض';
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginLoadingstate) {
              showLoadingDialog(context);
            } else if (state is LoginSuccessstate) {
              Navigator.pop(context);
              log("success");
            } else if (state is AuthErrorState) {
              Navigator.pop(context);
              showErrorDialog(context, state.error);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سجل دخول الان كـ "${handleUserType()}"',
                      style: getTitleStyle(),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        labelText: 'الايميل',
                      ),
                      textInputAction: TextInputAction.next,
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
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.blackColor,
                      ),
                      obscureText: isVisable,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة السر',
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
                      controller: passwordController,
                      validator: (value) {
                        if (!passwordValidation(value)) {
                          return 'كلمة السر غير صحيحة';
                        }
                        if (value!.isEmpty) return 'من فضلك ادخل كلمة السر';
                        return null;
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(top: 5, right: 10),
                      child: Text(
                        'نسيت كلمة السر ؟',
                        style: getSmallStyle(),
                      ),
                    ),
                    const Gap(20),
                    CustomButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(loginEvent(
                              email: emailController.text,
                              password: passwordController.text));
                        //push(context, const HomeView());
                        }
                      },
                      text: "تسجيل الدخول",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لدي حساب ؟',
                            style: getBodyStyle(
                              color: AppColors.blackColor,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                pushReplacement(
                                  context,
                                  SignupView(
                                    userType: widget.userType,
                                  ),
                                );
                              },
                              child: Text(
                                'سجل الان',
                                style: getBodyStyle(
                                  color: AppColors.blueColor,
                                ),
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
