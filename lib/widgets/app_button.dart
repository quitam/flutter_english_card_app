import 'package:flutter/material.dart';
import 'package:learn_english_app/values/app_colors.dart';
import 'package:learn_english_app/values/app_styles.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const AppButton({super.key, required this.label, required this.onTap});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onHighlightChanged: (value) {
        setState(() {
          isPressed = value;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 22),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
            color: isPressed ? Colors.grey : Colors.white,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(4, 4), color: Colors.black45, blurRadius: 3)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Text(
          widget.label,
          style: AppStyles.h5.copyWith(color: AppColors.textColor),
        ),
      ),
    );
  }
}
