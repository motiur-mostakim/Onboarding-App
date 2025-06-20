import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/app_colors.dart';

class AlarmCardWidget extends StatefulWidget {
  final String? timeText;
  final String? dateText;
  const AlarmCardWidget({super.key, this.timeText, this.dateText});

  @override
  State<AlarmCardWidget> createState() => _AlarmCardWidgetState();
}

class _AlarmCardWidgetState extends State<AlarmCardWidget> {
  bool isAlarm = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 84,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: AppColors.secondaryBtnColor,
          borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        children: [
          Text(
            widget.timeText!,
            style: GoogleFonts.oxygen(
              fontSize: 24.sp,
              color: AppColors.whiteColor,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                widget.dateText!,
                style: GoogleFonts.oxygen(
                  fontSize: 14.sp,
                  color: AppColors.whiteColor,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Switch(
                activeTrackColor: AppColors.primaryColor,
                value: isAlarm,
                onChanged: (newValue) {
                  setState(() {
                    isAlarm = newValue;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
