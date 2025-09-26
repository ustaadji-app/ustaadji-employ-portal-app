import 'dart:developer';
import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/job/job_detail_screen.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/screens/messages/chat_screen.dart';
import 'package:employee_portal/screens/messages/conversation_screens.dart';
import 'package:employee_portal/services/api_services.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/utils/storage_helper.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_full_screen_loader.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final ApiService apiService = ApiService();

  List<dynamic> jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingJobs();
  }

  Future<void> _fetchPendingJobs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = await StorageHelper.getToken();
      print("Token:$token");
      if (token == null) {
        log("⚠️ Token not found");
        return;
      }

      final response = await apiService.getRequest(
        endpoint: "provider/jobs/pending",
        token: token,
      );

      log("📌 API Response: ${response.toString()}");

      if (response["success"] == true) {
        setState(() {
          jobs = response["data"]["jobs"];
        });
      }
    } catch (e, st) {
      log("❌ Error fetching jobs: $e", stackTrace: st);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final date = DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now());
    final userProvider = Provider.of<UserProvider>(context);
    final provider = userProvider.user['provider'] ?? {};

    return Stack(
      children: [
        MainLayout(
          title: "Home",
          currentIndex: 0,
          isAvatarShow: true,
          isNotificationIconShown: true,
          isSidebarEnabled: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.md.h,
                ),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor:
                              isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                          backgroundImage:
                              (provider?['avatarUrl'] != null &&
                                      (provider?['avatarUrl'] as String)
                                          .isNotEmpty)
                                  ? NetworkImage(provider?['avatarUrl'])
                                  : null,
                          child:
                              (provider?['avatarUrl'] == null ||
                                      (provider?['avatarUrl'] as String)
                                          .isEmpty)
                                  ? Text(
                                    provider?['name'] != null &&
                                            (provider?['name'] as String)
                                                .isNotEmpty
                                        ? (provider!['name'] as String)[0]
                                            .toUpperCase()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                  : null,
                        ),
                        AppSpacing.hmd,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: provider?['name'] ?? '',
                              size: CustomTextSize.lg,
                              fontWeight: FontWeight.bold,
                              color: CustomTextColor.text,
                            ),
                            CustomText(
                              text: date,
                              size: CustomTextSize.sm,
                              color: CustomTextColor.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppSpacing.vmd,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat("Total Jobs", "30", textColor),
                        _buildStat("Completed", "20", textColor),
                        _buildStat("Pending", "3", textColor),
                        _buildStat("Cancelled", "2", textColor),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.vmd,
              CustomText(
                text: "Available Jobs",
                size: CustomTextSize.md,
                fontWeight: FontWeight.w600,
                color: CustomTextColor.text,
              ),
              AppSpacing.vmd,
              Expanded(
                child:
                    isLoading
                        ? const SizedBox()
                        : jobs.isEmpty
                        ? Center(
                          child: CustomText(
                            text: "No jobs available",
                            size: CustomTextSize.base,
                            color: CustomTextColor.textSecondary,
                          ),
                        )
                        : ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final jobData = jobs[index];
                            return _buildJobCard(
                              context,
                              textColor,
                              isDark,
                              jobData,
                            );
                          },
                        ),
              ),
            ],
          ),
        ),

        // 👇 Loader overlay
        if (isLoading) FullScreenLoader(),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color textColor) {
    return Column(
      children: [
        CustomText(
          text: value,
          size: CustomTextSize.lg,
          fontWeight: FontWeight.bold,
          color: CustomTextColor.text,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          size: CustomTextSize.sm,
          color: CustomTextColor.textSecondary,
        ),
      ],
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    Color textColor,
    bool isDark,
    dynamic jobData, // 👈 Ab yahan job data milega
  ) {
    final job = jobData["job"];
    final service = job["service"];
    final customer = jobData["customer"];
    print("ye job Data h${jobData}");
    print("ye service wala h${service}");
    print("ye customer wala h${customer}");

    final userProvider = Provider.of<UserProvider>(context);
    final provider = userProvider.user['provider'] ?? {};

    print("${provider} check");

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.work_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    CustomText(
                      text: service?["main_service_name"] ?? "Service",
                      color: CustomTextColor.text,
                      fontWeight: FontWeight.w600,
                      size: CustomTextSize.md,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    job["status"] ?? "Pending",
                    style: TextStyle(
                      fontSize: AppFonts.xs,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.vsm,
            Row(
              children: [
                Icon(Icons.location_on, size: 18.sp, color: Colors.redAccent),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    job["customer_location"] ?? "No location",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      color: CustomTextColor.textSecondary,
                      size: CustomTextSize.base,
                    ),
                  ],
                ),
                Text(
                  job["scheduled_date"] ?? "",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            AppSpacing.vlg,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: "Message",
                  onPressed: () {
                    CustomNavigation.push(
                      context,
                      ConversationScreen(
                        user: {
                          "id": customer["id"],
                          "name": customer["name"],
                          "role": "customer",
                        },
                        jobId: job["id"].toString(),
                        currentUserId: provider["id"].toString(),
                        customerName: customer["name"] ?? "Customer",
                        providerName: provider["name"] ?? "Provider",
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: "View Details",
                  onPressed: () {
                    CustomNavigation.push(
                      context,
                      JobDetailsScreen(jobData: jobData),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
