import 'package:flutter/material.dart';
import 'package:gwenchana/common/helpers/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? height;
  final String title;
  final bool isEnabled;
  const BasicAppButton({
    super.key,
    required this.onPressed,
    this.height,
    required this.title,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((state) {
          if (state.contains(WidgetState.disabled)) {
            return AppColors.disableButton;
          }
          return AppColors.enableButton;
        }),
        minimumSize: WidgetStatePropertyAll<Size>(
          Size(double.infinity, height ?? 50),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isEnabled ? AppColors.white : AppColors.grey,
          fontSize: 18,
        ),
      ),
    );
  }
}
