import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'custom_popup.dart';

class LocationPermissionPopup {
  static Future<bool?> show(BuildContext context) async {
    return await CustomPopup.show<bool>(
      context,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "Location Permission Required",
            size: CustomTextSize.lg,
            fontWeight: FontWeight.bold,
            color: CustomTextColor.text,
            textAlign: TextAlign.left,
          ),
          AppSpacing.vxs,
          CustomText(
            text:
                "Please allow location access to fetch your current location.",
            size: CustomTextSize.sm,
            color: CustomTextColor.textSecondary,
          ),
          AppSpacing.vlg,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CustomButton(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context, false),
                  variant: ButtonVariant.outline,
                ),
              ),
              AppSpacing.hsm,
              Expanded(
                child: CustomButton(
                  text: "Allow",
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
