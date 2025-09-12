import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';

Center bottomText() {
  return Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text:
            'By creating or logging into an account you are agreeing\nwith our ',
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
        children: [
          TextSpan(
            text: 'Terms and Conditions',
            style: TextStyle(
              color: ColorConfig.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: ColorConfig.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class TapGestureRecognizer {}
