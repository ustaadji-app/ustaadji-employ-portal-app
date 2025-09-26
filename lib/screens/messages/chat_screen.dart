import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/screens/messages/conversation_screens.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/utils/firebase_helper.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final userProvider = Provider.of<UserProvider>(context);
    final provider = userProvider.user['provider'] ?? {};

    final currentUserId = provider['id'].toString();

    return MainLayout(
      title: 'Chats',
      currentIndex: 1,
      isSidebarEnabled: true,
      body: Column(
        children: [
          // 🔎 Search Box
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12.r),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    searchText = val.trim().toLowerCase();
                  });
                },
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

          // 💬 Chat List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirebaseHelper.instance.getChatsForUser(
                userId: currentUserId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: CustomText(
                      text: "Error loading chats",
                      size: CustomTextSize.md,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                }

                final chats = snapshot.data ?? [];

                print("ye chats hain ${chats}");

                if (chats.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: "No chats available",
                      size: CustomTextSize.md,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                }

                // 🔎 Filter by search
                final filteredChats =
                    chats.where((chat) {
                      final lastMsg =
                          (chat['lastMessage'] ?? "").toString().toLowerCase();
                      return lastMsg.contains(searchText);
                    }).toList();

                if (filteredChats.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: "No chats found",
                      size: CustomTextSize.md,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                }

                // 📌 Sort chats: unread first, then by lastMessageTime desc
                filteredChats.sort((a, b) {
                  final aUnread =
                      (a['lastMessageRead'] == false &&
                          a['lastMessageSenderId'] != currentUserId);
                  final bUnread =
                      (b['lastMessageRead'] == false &&
                          b['lastMessageSenderId'] != currentUserId);

                  if (aUnread && !bUnread) return -1;
                  if (!aUnread && bUnread) return 1;

                  final aTime = a['lastMessageTime'] as Timestamp?;
                  final bTime = b['lastMessageTime'] as Timestamp?;

                  if (aTime == null && bTime == null) return 0;
                  if (aTime == null) return 1;
                  if (bTime == null) return -1;
                  return bTime.compareTo(aTime);
                });

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredChats.length,
                  separatorBuilder: (_, __) => AppSpacing.vxs,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];

                    // ✅ Participants safe cast
                    final participants = List<String>.from(
                      chat['participants'] ?? [],
                    );
                    // Get the other user's ID
                    final otherUserId = participants.firstWhere(
                      (id) => id != currentUserId,
                      orElse: () => "",
                    );
                    // ✅ Safe map cast
                    final participantDetails = Map<String, dynamic>.from(
                      chat['participantDetails'] ?? {},
                    );

                    final otherUserName =
                        participantDetails[otherUserId] ?? "User";

                    final isUnread =
                        (chat['lastMessageRead'] == false &&
                            chat['lastMessageSenderId'] != currentUserId);

                    print("ye chat ka data h ${chat}");

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final jobId = chat['id'].toString();
                          final otherUserId = participants.firstWhere(
                            (id) => id != currentUserId,
                            orElse: () => "",
                          );
                          final otherUserName =
                              participantDetails[otherUserId] ?? "User";

                          final isProvider =
                              userProvider.user['provider'] != null;

                          CustomNavigation.push(
                            context,
                            ConversationScreen(
                              user:
                                  isProvider
                                      ? userProvider.user['provider'] ?? {}
                                      : userProvider.user['customer'] ?? {},

                              jobId: jobId,
                              currentUserId: currentUserId,

                              // agar provider login hai to customer ka name otherUserName hoga
                              customerName:
                                  isProvider
                                      ? otherUserName
                                      : userProvider
                                              .user['customer']?['name'] ??
                                          "Customer",

                              providerName: provider['name'],
                            ),
                          );
                        },

                        splashColor: AppColors.lightPrimary.withValues(
                          alpha: 0.3,
                        ),
                        highlightColor: AppColors.lightPrimary.withValues(
                          alpha: 0.3,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.r,
                            backgroundColor:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                            child: CustomText(
                              text: otherUserName[0].toUpperCase(),
                              size: CustomTextSize.md,
                              fontWeight: FontWeight.bold,
                              color: CustomTextColor.btnText,
                            ),
                          ),
                          title: CustomText(
                            text: otherUserName,
                            size: CustomTextSize.md,
                            fontWeight: FontWeight.w600,
                            color: CustomTextColor.text,
                          ),
                          subtitle: CustomText(
                            maxLines: 1,
                            text: chat['lastMessage'] ?? "",
                            overflow: TextOverflow.ellipsis,
                            size: CustomTextSize.sm,
                            color: CustomTextColor.textSecondary,
                          ),
                          trailing:
                              isUnread
                                  ? Container(
                                    width: 10.r,
                                    height: 10.r,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
