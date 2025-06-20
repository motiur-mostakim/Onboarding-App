import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_app/common_widgets/alarm_card_widget.dart';
import 'package:onboarding_app/common_widgets/custom_button_widget.dart';
import 'package:onboarding_app/helpers/alarm_permission_helper.dart';
import 'package:onboarding_app/helpers/app_assets.dart';
import 'package:onboarding_app/helpers/app_colors.dart';

import '../../constants/local_storage_manager.dart';
import '../../networks/notification_services.dart';

class HomeScreen extends StatefulWidget {
  final String? location;
  const HomeScreen({super.key, this.location});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    AlarmPermissionHelper().requestNotificationPermission();
    NotificationServices.init();
    loadAlarms();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  List<DateTime> alarms = [];

  void _setAlarm() async {
    if (selectedDate != null && selectedTime != null) {
      DateTime alarmDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      setState(() {
        alarms.add(alarmDateTime);
      });
      await saveAlarms();

      NotificationServices.scheduleNotification(
        '🔔 Alarm',
        'Your alarm is set for ${DateFormat('hh:mm a').format(alarmDateTime)}',
        alarmDateTime,
      );
    }
  }

  Future<void> saveAlarms() async {
    await LocalStorageManager().saveAlarms(alarms);
  }

  Future<void> loadAlarms() async {
    alarms = await LocalStorageManager().loadAlarms();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 75.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Location",
                      style: GoogleFonts.oxygen(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.homeLocationIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        Expanded(
                          child: Text(
                            widget.location.toString(),
                            maxLines: 2,
                            style: GoogleFonts.oxygen(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomButtonWidget(
                      btnHeight: 48.h,
                      btnBorderRadius: 4.r,
                      isBtnImage: false,
                      btnImage: null,
                      btnText: "Add Alarm",
                      btnFunc: () async {
                        await _selectTime(context);
                        await _selectDate(context);
                        if (selectedDate != null && selectedTime != null) {
                          _setAlarm();
                        }
                      },
                      btnTextFontWeight: FontWeight.w500,
                      btnColor: AppColors.secondaryBtnColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 34.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alarms",
                      style: GoogleFonts.oxygen(
                        fontSize: 18.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    ListView.builder(
                      itemCount: alarms.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        DateTime alarmTime = alarms[index];
                        String formattedTime =
                            DateFormat('hh:mm a').format(alarmTime);
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(alarmTime);
                        return alarms.isNotEmpty
                            ? AlarmCardWidget(
                                timeText: formattedTime,
                                dateText: formattedDate,
                              )
                            : const Text("No data");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
