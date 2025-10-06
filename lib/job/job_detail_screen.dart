import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/screens/messages/chat_screen.dart';
import 'package:employee_portal/screens/messages/conversation_screens.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobDetailsScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    final job = jobData["job"];
    final customer = jobData["customer"];
    final service = job["service"];
    final jobCategories = job["job_categories"] ?? [];

    final userProvider = Provider.of<UserProvider>(context);
    final provider = userProvider.user['provider'] ?? {};

    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("job details sai customer ka data $customer");
    print("job details sai provider ka data $provider");
    print("job details sai job ka data $job");

    return MainLayout(
      title: "Job Details",
      isBackAction: true,
      currentIndex: 2,
      showBottomNav: false,
      isNotificationIconShown: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Info
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: service?["main_service_name"] ?? "Service",
                    size: CustomTextSize.lg,
                    fontWeight: FontWeight.bold,
                    color: CustomTextColor.text,
                  ),
                  AppSpacing.vsm,
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18.sp,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: CustomText(
                          text: job["customer_location"],
                          size: CustomTextSize.base,
                          color: CustomTextColor.text,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vxs,
                  Row(
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 18.sp,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: "PKR ${job["amount"] ?? 0}",
                        color: CustomTextColor.text,
                        size: CustomTextSize.base,
                      ),
                    ],
                  ),
                  AppSpacing.vsm,
                  CustomText(
                    text:
                        "Scheduled: ${job["scheduled_date"] ?? "-"} at ${job["scheduled_time"] ?? "-"}",
                    size: CustomTextSize.sm,
                    color: CustomTextColor.textSecondary,
                  ),
                  if (job["description"] != null &&
                      job["description"].toString().isNotEmpty) ...[
                    AppSpacing.vxs,
                    CustomText(
                      text: "Description: ${job["description"]}",
                      size: CustomTextSize.sm,
                      color: CustomTextColor.textSecondary,
                    ),
                  ],
                  AppSpacing.vsm,
                  CustomText(
                    text: "Customer Info",
                    size: CustomTextSize.md,
                    fontWeight: FontWeight.w600,
                    color: CustomTextColor.text,
                  ),
                  AppSpacing.vxs,
                  CustomText(
                    text: "Customer Name: ${customer?["name"] ?? "-"}",
                    size: CustomTextSize.sm,
                    color: CustomTextColor.textSecondary,
                  ),
                  AppSpacing.vxs,
                  CustomText(
                    text: "Customer Email: ${customer?["email"] ?? "-"}",
                    size: CustomTextSize.sm,
                    color: CustomTextColor.textSecondary,
                  ),
                  AppSpacing.vxs,
                  CustomText(
                    text: "Customer Phone Number: ${customer?["phone"] ?? "-"}",
                    size: CustomTextSize.sm,
                    color: CustomTextColor.textSecondary,
                  ),
                ],
              ),
            ),

            AppSpacing.vlg,

            if (jobCategories.isNotEmpty) ...[
              CustomText(
                text: "Services Included",
                size: CustomTextSize.md,
                fontWeight: FontWeight.w600,
                color: CustomTextColor.text,
              ),
              AppSpacing.vsm,
              ...jobCategories.map((cat) {
                final serviceCat = cat["service_category"];
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text:
                              "${serviceCat?["service_cat_name"] ?? "Service"} (x${cat["qty"]})",
                          size: CustomTextSize.base,
                          color: CustomTextColor.text,
                        ),
                      ),
                      CustomText(
                        text: "PKR ${cat["amount"]}",
                        size: CustomTextSize.base,
                        color: CustomTextColor.textSecondary,
                      ),
                    ],
                  ),
                );
              }).toList(),
              AppSpacing.vlg,
            ],

            AppSpacing.vlg,
            // Accept Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Accept",
                onPressed: () {
                  print("Navigating to conversation screen");
                  CustomNavigation.push(
                    context,
                    ConversationScreen(
                      customer: {
                        "id": customer['id'].toString(),
                        "name": customer['name'],
                        "role": "customer",
                      },
                      jobId: job['id'].toString(),
                      provider: {
                        "id": provider['id'].toString(),
                        "name": provider['name'],
                        "role": "provider",
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
