// feature/intro/onboard/presentation/onboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/core/functions/navigation.dart';
import 'package:flutter_application/core/services/local_storage/local_storage.dart';
import 'package:flutter_application/core/utils/colors.dart';
import 'package:flutter_application/core/utils/text_style.dart';
import 'package:flutter_application/core/widgets/custom_button.dart';
import 'package:flutter_application/feature/intro/onboard/data/model/onboard_model.dart';
import 'package:flutter_application/feature/intro/welcome/presentation/welcome_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  var pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        actions: [
          if (currentPage != pages.length - 1)
            TextButton(
              onPressed: () {
                AppLocalStorage.cacheData(
                    key: AppLocalStorage.onboarding, value: true);
                pushReplacement(context, const WelcomeView());
              },
              child: Text(
                'تخطي',
                style: getBodyStyle(color: AppColors.blueColor),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // pageview
          Expanded(
              child: PageView.builder(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            itemBuilder: (context, index) {
              return Column(children: [
                // image
                const Spacer(),
                SvgPicture.asset(
                  pages[index].image,
                  width: 300,
                ),
                const Spacer(),
                // title
                Text(
                  pages[index].title,
                  style: getTitleStyle(color: AppColors.blueColor),
                ),
                const Gap(20),
                Text(
                  pages[index].body,
                  textAlign: TextAlign.center,
                  style: getBodyStyle(),
                ),
                const Spacer(
                  flex: 3,
                ),
              ]);
            },
            itemCount: pages.length,
          )),
          // footer
          SizedBox(
            height: 70,
            child: Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: pages.length,
                  effect: const SlideEffect(
                      spacing: 8.0,
                      radius: 15,
                      dotWidth: 24.0,
                      dotHeight: 13,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: AppColors.blueColor),
                ),
                const Spacer(),
                if (currentPage == pages.length - 1)
                  CustomButton(
                      height: 45,
                      text: 'هيا بنا',
                      onPressed: () {
                        AppLocalStorage.cacheData(
                            key: AppLocalStorage.onboarding, value: true);
                        pushReplacement(context, const WelcomeView());
                      },
                      width: 100)
              ],
            ),
          )
        ]),
      ),
    );
  }
}
