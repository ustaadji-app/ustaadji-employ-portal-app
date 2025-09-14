import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/auth_layout.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_input_fields.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String? selectedCategory;

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      Navigator.pushReplacementNamed(context, "/profile");
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Widget _buildUploadField(String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 65.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: primary, width: 1.5),
          color: Colors.white.withValues(alpha: 0.05),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.upload_file, color: primary),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 1
  Widget _buildStepOne() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Personal Information",
          color: CustomTextColor.text,
          fontWeight: FontWeight.w600,
          size: CustomTextSize.lg,
          fontFamily: "Poppins",
        ),
        AppSpacing.vmd,
        CustomTextField(label: "Full Name", icon: Icons.person_outline),
        AppSpacing.vsm,
        CustomTextField(label: "CNIC Number", icon: Icons.credit_card_outlined),
        AppSpacing.vsm,
        _buildUploadField("Upload CNIC Image"),
        AppSpacing.vsm,
        CustomPhoneField(),
        AppSpacing.vsm,
        CustomTextField(label: "Address", icon: Icons.home_outlined),
        AppSpacing.vsm,
        _buildUploadField("Upload Bill Image"),
      ],
    );
  }

  // Step 2
  Widget _buildStepTwo() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Guarantor Details",
          color: CustomTextColor.text,
          fontWeight: FontWeight.w600,
          size: CustomTextSize.lg,
        ),
        AppSpacing.vmd,
        CustomTextField(label: "Guarantor Name", icon: Icons.person_outline),
        AppSpacing.vsm,
        CustomTextField(label: "G. CNIC", icon: Icons.credit_card_outlined),
        AppSpacing.vsm,
        _buildUploadField("Upload G. CNIC Image"),
        AppSpacing.vsm,
        CustomPhoneField(),
        AppSpacing.vsm,
        CustomTextField(label: "G. Address", icon: Icons.home_outlined),
        AppSpacing.vsm,
        _buildUploadField("Upload G. Bill Image"),
      ],
    );
  }

  // Step 3
  Widget _buildStepThree() {
    final categories = [
      {"icon": Icons.plumbing, "label": "Plumber"},
      {"icon": Icons.electrical_services, "label": "Electrician"},
      {"icon": Icons.format_paint, "label": "Painter"},
      {"icon": Icons.chair, "label": "Carpenter"},
      {"icon": Icons.local_taxi, "label": "Driver"},
      {"icon": Icons.cleaning_services, "label": "Maid"},
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Select Your Category",
          color: CustomTextColor.text,
          fontWeight: FontWeight.w600,
          size: CustomTextSize.lg,
        ),
        AppSpacing.vmd,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14.h,
            crossAxisSpacing: 14.w,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = selectedCategory == cat["label"];

            return GestureDetector(
              onTap: () {
                setState(() => selectedCategory = cat["label"] as String);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  // ✅ Use different background color
                  color:
                      isSelected
                          ? primary.withValues(alpha: 0.15)
                          : textColor.withValues(alpha: 0.08),

                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: isSelected ? primary : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [],
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat["icon"] as IconData,
                      color:
                          isSelected
                              ? primary
                              : textColor.withValues(alpha: 0.7),
                      size: 32.sp,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: cat["label"] as String,
                      color:
                          isSelected
                              ? CustomTextColor.primary
                              : CustomTextColor.text,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      size: CustomTextSize.md,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = [_buildStepOne(), _buildStepTwo(), _buildStepThree()];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return AuthLayout(
      title: "Register",
      isBackAction: true,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 3,
              minHeight: 8.h,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(primary),
            ),
          ),
          AppSpacing.vmd,
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: steps[_currentStep],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: CustomButton(text: "Back", onPressed: _prevStep),
                    ),
                  if (_currentStep > 0) SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      text: _currentStep == 2 ? "Finish" : "Next",
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
