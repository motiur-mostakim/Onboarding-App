import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding_app/common_widgets/custom_button_widget.dart';
import 'package:onboarding_app/features/welcome_screen/welcome_screen.dart';
import 'package:onboarding_app/helpers/alarm_permission_helper.dart';
import 'package:onboarding_app/helpers/app_assets.dart';
import 'package:onboarding_app/helpers/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  int currentPage = 0;

  List<String> pageTitle = [
    "Sync with Nature’s Rhythm",
    "Effortless & Automatic",
    "Relax & Unwind",
  ];
  List<String> images = [
    AppAssets.natureRhythmImage,
    AppAssets.effortLessAutomaticImage,
    AppAssets.relaxUnwindImage,
  ];
  List<String> pageSubTitle = [
    "Experience a peaceful transition into the evening with an alarm that aligns with the sunset. Your perfect reminder, always 15 minutes before sundown",
    "No need to set alarms manually. Wakey calculates the sunset time for your location and alerts you on time.",
    "hope to take the courage to pursue your dreams.",
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: 3,
            controller: pageController,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        images[index],
                        height: 429.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          pageTitle[index],
                          style: GoogleFonts.oxygen(
                            fontWeight: FontWeight.w500,
                            fontSize: 28.sp,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          pageSubTitle[index],
                          style: GoogleFonts.oxygen(
                            fontSize: 14.sp,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        DotsIndicator(
                          dotsCount: 3,
                          position: currentPage.toDouble(),
                          decorator: const DotsDecorator(
                            color: AppColors
                                .inActiveIndicatorColor, // Inactive color
                            activeColor: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 34.h,
                        ),
                        CustomButtonWidget(
                          btnColor: AppColors.primaryColor,
                          btnFunc: () {
                            if (currentPage < 2) {
                              pageController.animateToPage(
                                currentPage + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            } else {
                              AlarmPermissionHelper().requestPermission();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomeScreen()));
                            }
                          },
                          btnText: "Next",
                        ),
                        SizedBox(
                          height: 40.h,
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
              top: 60,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()));
                  AlarmPermissionHelper().requestPermission();
                },
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: AppColors.whiteColor,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
