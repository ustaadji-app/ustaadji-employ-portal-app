import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/screens/auth/register_screen.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    final Map<String, dynamic> user = {
      'avatarUrl': '',
      'name': 'Ali Khan',
      'phone_number': '+92 300 1234567',
      'email': 'ali.khan@example.com',
      'address': '123, Gulshan-e-Iqbal, Karachi',
      'created_at': '2023-08-21T14:35:00Z',
    };

    print(user);
    final String avatarUrl = user['avatarUrl'] ?? '';
    final String fullName = user['name'] ?? "";
    final String phoneNumber = user['phone_number'] ?? "";
    final String mail = user['email'] ?? "";
    final String address = user['address'] ?? "";
    final rawCreatedAt = user['created_at'] ?? "";
    String createdAt = "";

    if (rawCreatedAt.isNotEmpty) {
      final parsedDate = DateTime.tryParse(rawCreatedAt);
      if (parsedDate != null) {
        // Sirf date part yyyy-MM-dd
        createdAt =
            "${parsedDate.year.toString().padLeft(4, '0')}-"
            "${parsedDate.month.toString().padLeft(2, '0')}-"
            "${parsedDate.day.toString().padLeft(2, '0')}";
      }
    }

    // Future<void> _handleLogout(BuildContext context) async {
    //   try {
    //     final token = await StorageHelper.getToken();
    //     if (token == null) {
    //       AppToast.show(
    //         context,
    //         message: "No token found",
    //         variant: ToastVariant.error,
    //       );
    //       return;
    //     }

    //     showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (_) => const Center(child: CircularProgressIndicator()),
    //     );

    //     // ✅ API call
    //     final apiService = ApiService();
    //     final result = await apiService.postRequest(
    //       endpoint: "logout",
    //       body: {}, // logout API me usually body empty hoti hai
    //       token: token,
    //     );

    //     Navigator.of(context).pop(); // hide loader

    //     if (result["success"] == true) {
    //       // ✅ Storage clear
    //       await StorageHelper.clearAll();

    //       // ✅ UserProvider clear
    //       if (context.mounted) {
    //         Provider.of<UserProvider>(context, listen: false).clearUser();
    //       }

    //       // ✅ Success Toast
    //       AppToast.show(
    //         context,
    //         message: result["data"]["message"] ?? "Logged out successfully",
    //         variant: ToastVariant.success,
    //       );

    //       // ✅ Navigate to PhoneNumberScreen
    //       if (context.mounted) {
    //         Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(builder: (_) => const PhoneNumberScreen()),
    //           (route) => false,
    //         );
    //       }
    //     } else {
    //       AppToast.show(
    //         context,
    //         message: result["message"] ?? "Logout failed",
    //         variant: ToastVariant.error,
    //       );
    //     }
    //   } catch (e) {
    //     Navigator.of(context).pop();
    //     AppToast.show(
    //       context,
    //       message: "Logout error: $e",
    //       variant: ToastVariant.error,
    //     );
    //   }
    // }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final String firstLetter =
        fullName.isNotEmpty
            ? fullName.trim().split(' ')[0][0].toUpperCase()
            : "";

    final bool hasAvatar = avatarUrl.length > 3;

    return MainLayout(
      title: 'Profile',
      currentIndex: 4,
      isSidebarEnabled: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor:
                      hasAvatar ? Colors.transparent : primaryColor,
                  backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                  child:
                      !hasAvatar
                          ? CustomText(
                            text: firstLetter,
                            size: CustomTextSize.xxxl,
                            fontWeight: FontWeight.bold,
                            color: CustomTextColor.alwaysWhite,
                          )
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 4.w,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4.r),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        color:
                            isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.vlg,
            CustomText(
              text: fullName,
              size: CustomTextSize.xl,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color: CustomTextColor.text,
            ),
            AppSpacing.vmd,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(
                  Icons.calendar_today,
                  'Joined: $createdAt',
                  primaryColor,
                  CustomTextColor.textSecondary,
                ),
              ],
            ),
            AppSpacing.vlg,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black54 : Colors.grey.shade200,
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.phone_outlined,
                    phoneNumber,
                    CustomTextColor.textSecondary,
                  ),
                  Divider(height: 32.h, color: Colors.grey),
                  _buildDetailRow(
                    Icons.mail_outline,
                    mail,
                    CustomTextColor.textSecondary,
                  ),
                  Divider(height: 32.h, color: Colors.grey),
                  _buildDetailRow(
                    Icons.location_on_outlined,
                    address,
                    CustomTextColor.textSecondary,
                  ),
                ],
              ),
            ),
            AppSpacing.vlg,
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Logout',
                // onPressed: () => _handleLogout(context),
                onPressed: () {
                  CustomNavigation.push(context, RegisterScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String value,
    CustomTextColor valueColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: Colors.grey),
        AppSpacing.hsm,
        Expanded(
          child: CustomText(
            text: value,
            size: CustomTextSize.md,
            fontWeight: FontWeight.normal,
            fontFamily: "Roboto",
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    Color bgColor,
    CustomTextColor textColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: bgColor),
          AppSpacing.hsm,
          CustomText(
            text: label,
            size: CustomTextSize.sm,
            fontWeight: FontWeight.w600,
            fontFamily: "Roboto",
            color: CustomTextColor.text,
          ),
        ],
      ),
    );
  }
}
