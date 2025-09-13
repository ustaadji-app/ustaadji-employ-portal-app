import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/screens/messages/conversation_screens.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> users = [
    {
      "id": "wqknd21kn",
      "name": "Aisha Khan",
      "avatarUrl": "https://i.pravatar.cc/150?img=3",
      "lastMessage":
          "Hey! How are you?House cleaning completed.This phrase is used...",
      "isSeen": true,
    },
    {
      "id": "mx92nd82as",
      "name": "Rohan Mehta",
      "avatarUrl": "",
      "lastMessage": "Let's meet tomorrow.",
      "isSeen": false,
    },
    {
      "id": "plqk18zm5v",
      "name": "Sara Ali",
      "avatarUrl": "https://i.pravatar.cc/150?img=7",
      "lastMessage": "Check your email, please.",
      "isSeen": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: 'Chats',
      currentIndex: 1,
      isSidebarEnabled: true,
      body: Column(
        children: [
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12.r),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    size: 24.sp,
                  ),
                  hintText: "Search",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
          AppSpacing.vmd,
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, __) => AppSpacing.vxs,
              itemBuilder: (context, index) {
                final user = users[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      debugPrint("Tapped on ${user['name']}");
                      CustomNavigation.push(
                        context,
                        ConversationScreen(user: user),
                      );
                    },
                    splashColor: AppColors.lightPrimary.withValues(alpha: 0.3),
                    highlightColor: AppColors.lightPrimary.withValues(
                      alpha: 0.3,
                    ),
                    child: ListTile(
                      leading:
                          user["avatarUrl"] != ""
                              ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user["avatarUrl"],
                                ),
                                radius: 25.r,
                              )
                              : CircleAvatar(
                                radius: 25.r,
                                backgroundColor:
                                    isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary,
                                child: CustomText(
                                  text: user["name"][0],
                                  size: CustomTextSize.md,
                                  fontWeight: FontWeight.bold,
                                  color: CustomTextColor.btnText,
                                ),
                              ),
                      title: CustomText(
                        text: user["name"],
                        size: CustomTextSize.md,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        color: CustomTextColor.text,
                      ),
                      subtitle: CustomText(
                        maxLines: 1,
                        text: user["lastMessage"],
                        overflow: TextOverflow.ellipsis,
                        size: CustomTextSize.sm,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal,
                        color: CustomTextColor.textSecondary,
                      ),
                      trailing:
                          user["isSeen"]
                              ? null
                              : Container(
                                width: 8.r, // radius ke hisaab se circular
                                height: 8.r,
                                decoration: BoxDecoration(
                                  color: AppColors.lightPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
