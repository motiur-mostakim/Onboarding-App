import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color? btnColor;
  final String? btnText;
  final String? btnImage;
  final double? btnHeight;
  final double? btnBorderRadius;
  final bool? isBtnImage;
  final FontWeight? btnTextFontWeight;
  final VoidCallback? btnFunc;

  const CustomButtonWidget(
      {super.key,
      this.btnColor,
      this.btnText,
      this.btnFunc,
      this.btnTextFontWeight,
      this.btnImage,
      this.isBtnImage,
      this.btnHeight,
      this.btnBorderRadius});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: btnHeight ?? 56.h,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(btnBorderRadius ?? 8.r)),
      color: btnColor,
      onPressed: btnFunc,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            btnText!,
            style: GoogleFonts.oxygen(
              fontSize: 16.sp,
              fontWeight: btnTextFontWeight ?? FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          isBtnImage == true
              ? Image.asset(
                  btnImage!,
                  height: 24.h,
                  width: 24.w,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
