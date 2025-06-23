import 'package:flutter/material.dart';
import 'package:gwenchana/common/helpers/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? height;
  final String title;
  final double? elevation;

  const BasicAppButton({
    super.key,
    required this.onPressed,
    this.height,
    this.elevation,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.disableButton,
          backgroundColor: AppColors.enableButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: elevation,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
