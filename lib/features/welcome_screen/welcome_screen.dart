import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as loc;
import 'package:onboarding_app/common_widgets/custom_button_widget.dart';
import 'package:onboarding_app/features/home_screen/home_screen.dart';
import 'package:onboarding_app/helpers/alarm_permission_helper.dart';
import 'package:onboarding_app/helpers/app_assets.dart';
import 'package:onboarding_app/helpers/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final loc.Location _location = loc.Location();
  String _currentLocation = 'Not Available';
  String _address = 'Location name not available';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final loc.LocationData locationData = await _location.getLocation();

    double? lat = locationData.latitude;
    double? lon = locationData.longitude;

    setState(() {
      _currentLocation = 'Lat: $lat, Lng: $lon';
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lon!);
    Placemark place = placemarks[0];

    setState(() {
      _address =
          "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 124.h,
            ),
            Text(
              "Welcome! Your Personalized Alarm",
              style: GoogleFonts.oxygen(
                fontSize: 28.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              "Allow us to sync your sunset alarm based on your location.",
              style: GoogleFonts.oxygen(
                fontSize: 16.sp,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            Image.asset(
              AppAssets.sunsetAlarmImage,
              height: 309.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomButtonWidget(
              isBtnImage: true,
              btnImage: AppAssets.locationIcon,
              btnText: "Use Current Location",
              btnFunc: () {
                _getCurrentLocation();
              },
              btnTextFontWeight: FontWeight.w500,
              btnColor: AppColors.secondaryColor,
            ),
            SizedBox(
              height: 7.h,
            ),
            CustomButtonWidget(
              isBtnImage: false,
              btnImage: null,
              btnText: "Home",
              btnFunc: () async {
                await _getCurrentLocation();
                await AlarmPermissionHelper.requestExactAlarmPermission();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              location: _address,
                            )));
              },
              btnTextFontWeight: FontWeight.w500,
              btnColor: AppColors.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
