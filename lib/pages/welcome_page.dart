import 'package:flutter/material.dart';
import 'package:learn_english_app/pages/home_page.dart';
import 'package:learn_english_app/values/app_assets.dart';
import 'package:learn_english_app/values/app_colors.dart';
import 'package:learn_english_app/values/app_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        //padding left and right 16px
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Welcome to',
                style: AppStyles.h3,
              ),
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('English',
                    style: AppStyles.h2.copyWith(
                        color: AppColors.blackGray,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(
                    'Quotes"',
                    textAlign: TextAlign.right,
                    style: AppStyles.h4.copyWith(height: 0.7),
                  ),
                )
              ],
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 84),
              child: RawMaterialButton(
                //set circle shape for button
                shape: const CircleBorder(),
                fillColor: AppColors.white,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false);
                },
                child: Image.asset(AppAssets.rightArrow),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
