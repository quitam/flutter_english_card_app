import 'package:flutter/material.dart';
import 'package:learn_english_app/values/app_assets.dart';
import 'package:learn_english_app/values/app_colors.dart';
import 'package:learn_english_app/values/app_styles.dart';
import 'package:learn_english_app/values/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int value = sharedPreferences.getInt(SharedPref.word) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        //remove bottom line of app bar
        elevation: 0,
        title: Text(
          'Your control',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setInt(SharedPref.word, sliderValue.toInt());
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            Text(
              'How much a number word at once?',
              style: AppStyles.h5
                  .copyWith(fontSize: 18, color: AppColors.lightGray),
            ),
            const Spacer(),

            Text(
              sliderValue.toInt().toString(),
              style: AppStyles.h1.copyWith(
                  fontSize: 144,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            //Slider
            Slider(
              value: sliderValue,
              min: 5,
              max: 20,
              divisions: 15,
              //color of slider active
              activeColor: AppColors.primaryColor,
              inactiveColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                'Slide to set',
                style: AppStyles.h5.copyWith(color: AppColors.textColor),
              ),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
