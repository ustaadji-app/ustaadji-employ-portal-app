import 'dart:convert';
import 'dart:io';
import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/auth_layout.dart';
import 'package:employee_portal/models/register_model.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/screens/auth/pending_verification.dart';
import 'package:employee_portal/services/register_service.dart';
import 'package:employee_portal/utils/cnic_helper.dart';
import 'package:employee_portal/utils/bill_helper.dart';
import 'package:employee_portal/utils/image_picker_helper.dart';
import 'package:employee_portal/utils/storage_helper.dart';
import 'package:employee_portal/widgets/custom_app_toast.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_full_screen_loader.dart';
import 'package:employee_portal/widgets/custom_input_fields.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String? selectedCategory;

  bool isLoading = false;

  File get dummyFile => File("assets/images/app_logo.png");

  // Controllers
  final _fullNameController = TextEditingController(text: "Muhammad Zain");
  final _cnicController = TextEditingController(text: "1234567891023");
  final _phoneController = TextEditingController(text: "3281447811");
  final _addressController = TextEditingController(text: "Karachi");

  final _gNameController = TextEditingController(text: "Muhammad Ahmed");
  final _gCnicController = TextEditingController(text: "1234567891023");
  final _gPhoneController = TextEditingController(text: "32814478123");
  final _gAddressController = TextEditingController(text: "Karachi");

  // Files
  File? _cnicFront, _cnicBack, _billFront, _billBack;
  File? _gCnicFront, _gCnicBack, _gBillFront, _gBillBack;

  // Image error flags
  bool _cnicFrontError = false;
  bool _cnicBackError = false;
  bool _billFrontError = false;
  bool _billBackError = false;

  bool _gCnicFrontError = false;
  bool _gCnicBackError = false;
  bool _gBillFrontError = false;
  bool _gBillBackError = false;

  List<File> paymentImages = [];

  // Form Key
  final _formKey = GlobalKey<FormState>();
  void _nextStep() async {
    bool isValid = _formKey.currentState?.validate() ?? false;
    bool imagesValid = true;

    if (_currentStep == 0) {
      setState(() {
        _cnicFrontError = _cnicFront == null;
        _cnicBackError = _cnicBack == null;
        _billFrontError = _billFront == null;
        _billBackError = _billBack == null;
      });
      imagesValid =
          !_cnicFrontError &&
          !_cnicBackError &&
          !_billFrontError &&
          !_billBackError;

      if (!isValid || !imagesValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fill all fields and upload all documents"),
          ),
        );
        return;
      }
    }

    // // Step 2: Guarantor Info
    if (_currentStep == 1) {
      setState(() {
        _gCnicFrontError = _gCnicFront == null;
        _gCnicBackError = _gCnicBack == null;
        _gBillFrontError = _gBillFront == null;
        _gBillBackError = _gBillBack == null;
      });
      imagesValid =
          !_gCnicFrontError &&
          !_gCnicBackError &&
          !_gBillFrontError &&
          !_gBillBackError;

      if (!isValid || !imagesValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fill all guarantor fields and upload all docs"),
          ),
        );
        return;
      }
    }

    // // Step 3: Category
    if (_currentStep == 2) {
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a category")),
        );
        return;
      }
    }

    // Step 4: Payment Proof
    if (_currentStep == 3) {
      if (paymentImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please upload at least one payment screenshot"),
          ),
        );
        return;
      }

      final registerData = RegisterModel(
        name: _fullNameController.text,
        phoneNumber: _phoneController.text,
        cnicNumber: _cnicController.text,
        cnicFrontImage: _cnicFront!,
        cnicBackImage: _cnicBack!,
        address: _addressController.text,
        billFrontImage: _billFront!,
        billBackImage: _billBack!,
        gName: _gNameController.text,
        gPhoneNumber: _gPhoneController.text,
        gCnicNumber: _gCnicController.text,
        gCnicFrontImage: _gCnicFront!,
        gCnicBackImage: _gCnicBack!,
        gAddress: _gAddressController.text,
        gBillFrontImage: _gBillFront!,
        gBillBackImage: _gBillBack!,
        paymentImage: paymentImages.first,
        serviceId: 1,
      );

      setState(() => isLoading = true);

      try {
        debugPrint(
          "📤 Sending Register Request with Data: ${registerData.toJson()}",
        );

        final response = await submitRegister(registerData);

        debugPrint("📥 Register API Response: ${jsonEncode(response)}");

        if (response['success'] == true) {
          final provider = response['provider'] as Map<String, dynamic>?;
          final subscriptions =
              response['subscriptions'] as List<dynamic>? ?? [];

          if (provider != null) {
            final userData = {
              "provider": provider,
              "subscriptions": subscriptions,
            };

            await StorageHelper.saveUser(userData);
            debugPrint("✅ User data saved in StorageHelper");

            Provider.of<UserProvider>(context, listen: false).setUser(userData);
            debugPrint("✅ UserProvider updated with new user data");

            AppToast.show(
              context,
              message: response['message'] ?? "Registration Successful!",
              variant: ToastVariant.success,
            );

            await Future.delayed(const Duration(milliseconds: 500));

            if (!mounted) {
              debugPrint("⚠️ Widget not mounted, navigation skipped.");
              return;
            }

            debugPrint("➡️ Navigating to PendingVerificationScreen...");

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const PendingVerificationScreen(),
              ),
              (route) => false,
            );
          } else {
            debugPrint("❌ Provider data missing in response");
            AppToast.show(
              context,
              message: "Provider data missing. Please try again.",
              variant: ToastVariant.error,
            );
          }
        } else {
          debugPrint("❌ Registration failed: ${response['message']}");
          AppToast.show(
            context,
            message: response['message'] ?? "Registration failed",
            variant: ToastVariant.error,
          );
        }
      } catch (e, stack) {
        debugPrint("🔥 Exception during registration: $e");
        debugPrint("Stacktrace: $stack");
        AppToast.show(
          context,
          message: "Something went wrong. Please try again.",
          variant: ToastVariant.error,
        );
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }

      return; // Stop further step increment
    }

    if (_currentStep < 3) setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  Widget _buildCnicUploadField({
    required String label,
    required File? file,
    required Function(File) onFilePicked,
    required CnicSide side,
    bool showError = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        showError
            ? Colors.red
            : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    Future<void> pickCnic() async {
      final picked = await CnicScannerHelper.scanCnic(context, side);
      if (picked != null) onFilePicked(picked);
    }

    return _buildPreviewBox(label, file, onFilePicked, pickCnic, primary);
  }

  Widget _buildBillUploadField({
    required String label,
    required File? file,
    required Function(File) onFilePicked,
    required BillSide side,
    bool showError = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        showError
            ? Colors.red
            : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    Future<void> pickBill() async {
      final picked = await BillScannerHelper.scanBill(context, side);
      if (picked != null) onFilePicked(picked);
    }

    return _buildPreviewBox(label, file, onFilePicked, pickBill, primary);
  }

  Widget _buildPreviewBox(
    String label,
    File? file,
    Function(File) onFilePicked,
    Function pickFn,
    Color primary,
  ) {
    if (file != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(file, height: 120.h, fit: BoxFit.cover),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.refresh, color: primary),
                onPressed: () async => await pickFn(),
              ),
              Text("Retake", style: TextStyle(color: primary)),
            ],
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () async => await pickFn(),
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
              Icon(Icons.camera_alt, color: primary),
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
        ),
        AppSpacing.vmd,
        CustomTextField(
          label: "Full Name",
          icon: Icons.person_outline,
          controller: _fullNameController,
          validator: (v) {
            if (v == null || v.isEmpty) return "Full Name is required";
            if (v.trim().length < 3)
              return "Full Name must be at least 3 characters";
            return null;
          },
        ),
        AppSpacing.vsm,
        CustomTextField(
          label: "CNIC Number",
          icon: Icons.credit_card_outlined,
          controller: _cnicController,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return "CNIC is required";
            if (!RegExp(r'^\d{13}$').hasMatch(v))
              return "CNIC must be exactly 13 digits";
            return null;
          },
        ),
        AppSpacing.vsm,
        _buildCnicUploadField(
          label: "Upload CNIC Front",
          file: _cnicFront,
          onFilePicked: (f) => setState(() => _cnicFront = f),
          side: CnicSide.front,
          showError: _cnicFrontError,
        ),
        AppSpacing.vsm,
        _buildCnicUploadField(
          label: "Upload CNIC Back",
          file: _cnicBack,
          onFilePicked: (f) => setState(() => _cnicBack = f),
          side: CnicSide.back,
          showError: _cnicBackError,
        ),
        AppSpacing.vsm,
        CustomPhoneField(
          controller: _phoneController,
          validator: (v) {
            if (v == null || v.isEmpty) return "Phone is required";
            if (!RegExp(r'^\d{10}$').hasMatch(v))
              return "Phone must be exactly 10 digits";
            if (!v.startsWith('3')) return "Phone number must start with 3";
            return null;
          },
        ),
        AppSpacing.vsm,
        CustomTextField(
          label: "Address",
          icon: Icons.home_outlined,
          controller: _addressController,
          validator:
              (v) => (v == null || v.isEmpty) ? "Address is required" : null,
        ),
        AppSpacing.vsm,
        _buildBillUploadField(
          label: "Upload Bill Front",
          file: _billFront,
          onFilePicked: (f) => setState(() => _billFront = f),
          side: BillSide.front,
          showError: _billFrontError,
        ),
        AppSpacing.vsm,
        _buildBillUploadField(
          label: "Upload Bill Back",
          file: _billBack,
          onFilePicked: (f) => setState(() => _billBack = f),
          side: BillSide.back,
          showError: _billBackError,
        ),
      ],
    );
  }

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
        CustomTextField(
          label: "Guarantor Name",
          icon: Icons.person_outline,
          controller: _gNameController,
          validator: (v) {
            if (v == null || v.isEmpty) return "Guarantor Name is required";
            if (v.trim().length < 3) {
              return "Guarantor Name must be at least 3 characters";
            }
            return null;
          },
        ),
        AppSpacing.vsm,
        CustomTextField(
          label: "G. CNIC",
          icon: Icons.credit_card_outlined,
          controller: _gCnicController,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return "G. CNIC is required";
            if (!RegExp(r'^\d{13}$').hasMatch(v)) {
              return "G. CNIC must be exactly 13 digits";
            }
            if (v == _cnicController.text) {
              return "Guarantor CNIC cannot be same as your CNIC";
            }
            return null;
          },
        ),
        AppSpacing.vsm,
        _buildCnicUploadField(
          label: "Upload G. CNIC Front",
          file: _gCnicFront,
          onFilePicked: (f) => setState(() => _gCnicFront = f),
          side: CnicSide.front,
          showError: _gCnicFrontError,
        ),
        AppSpacing.vsm,
        _buildCnicUploadField(
          label: "Upload G. CNIC Back",
          file: _gCnicBack,
          onFilePicked: (f) => setState(() => _gCnicBack = f),
          side: CnicSide.back,
          showError: _gCnicBackError,
        ),
        AppSpacing.vsm,
        CustomPhoneField(
          controller: _gPhoneController,
          validator: (v) {
            if (v == null || v.isEmpty) return "G. Phone is required";
            if (!RegExp(r'^\d{10}$').hasMatch(v)) {
              return "G. Phone must be exactly 10 digits";
            }
            if (!v.startsWith('3')) return "G. Phone must start with 3";
            if (v == _phoneController.text) {
              return "Guarantor Phone cannot be same as your Phone";
            }
            return null;
          },
        ),
        AppSpacing.vsm,
        CustomTextField(
          label: "G. Address",
          icon: Icons.home_outlined,
          controller: _gAddressController,
          validator:
              (v) => (v == null || v.isEmpty) ? "G. Address is required" : null,
        ),
        AppSpacing.vsm,
        _buildBillUploadField(
          label: "Upload G. Bill Front",
          file: _gBillFront,
          onFilePicked: (f) => setState(() => _gBillFront = f),
          side: BillSide.front,
          showError: _gBillFrontError,
        ),
        AppSpacing.vsm,
        _buildBillUploadField(
          label: "Upload G. Bill Back",
          file: _gBillBack,
          onFilePicked: (f) => setState(() => _gBillBack = f),
          side: BillSide.back,
          showError: _gBillBackError,
        ),
      ],
    );
  }

  Widget _buildStepThree() {
    final categories = [
      {"icon": Icons.plumbing, "label": "Plumber", "fee": 500},
      {"icon": Icons.electrical_services, "label": "Electrician", "fee": 600},
      {"icon": Icons.format_paint, "label": "Painter", "fee": 400},
      {"icon": Icons.chair, "label": "Carpenter", "fee": 700},
      {"icon": Icons.local_taxi, "label": "Driver", "fee": 300},
      {"icon": Icons.cleaning_services, "label": "Maid", "fee": 350},
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
                  color:
                      isSelected
                          ? primary.withOpacity(0.15)
                          : textColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: isSelected ? primary : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: primary.withOpacity(0.3),
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
                    SizedBox(height: 6.h),
                    CustomText(
                      text: "Fee: ${cat['fee']} PKR",
                      color:
                          isSelected
                              ? CustomTextColor.primary
                              : CustomTextColor.textSecondary,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      size: CustomTextSize.sm,
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

  Widget _buildStepFour() {
    final accountNumber = "123456789012";
    final totalFee = "600 PKR";

    return Column(
      key: const ValueKey(4),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Payment Proof",
          color: CustomTextColor.text,
          fontWeight: FontWeight.w600,
          size: CustomTextSize.lg,
        ),
        AppSpacing.vmd,
        CustomText(
          text: "Account Number: $accountNumber\nTotal Fee: $totalFee",
          color: CustomTextColor.textSecondary,
          fontWeight: FontWeight.w500,
          size: CustomTextSize.md,
        ),
        AppSpacing.vmd,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1,
          ),
          itemCount: 3, // Always show 3 placeholders
          itemBuilder: (context, index) {
            final file =
                index < paymentImages.length ? paymentImages[index] : null;

            return GestureDetector(
              onTap: () async {
                // Pick image (using your helper)
                final updatedList = await pickImagesFromGallery(
                  context: context,
                  currentImages: paymentImages,
                  maxImages: 3,
                );

                // Update the specific index if needed
                setState(() {
                  paymentImages = updatedList;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white.withOpacity(0.05),
                ),
                child:
                    file != null
                        ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => paymentImages.removeAt(index));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Text(
                                "Add Screenshot",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
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
    final steps = [
      _buildStepOne(),
      _buildStepTwo(),
      _buildStepThree(),
      _buildStepFour(),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Stack(
      children: [
        AuthLayout(
          title: "Register",
          isBackAction: true,
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / steps.length,
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
                            child: CustomButton(
                              text: "Back",
                              onPressed: _prevStep,
                            ),
                          ),
                        if (_currentStep > 0) SizedBox(width: 12.w),
                        Expanded(
                          child: CustomButton(
                            text: _currentStep == 3 ? "Submit" : "Next",
                            onPressed: _nextStep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading) FullScreenLoader(),
      ],
    );
  }
}
