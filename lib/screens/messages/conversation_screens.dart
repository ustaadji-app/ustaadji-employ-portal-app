import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/utils/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_text.dart';

class ConversationScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ConversationScreen({super.key, required this.user});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String chatId;
  final String jobId = "job_123"; // abhi temporary
  final String customerId = "cust_1"; // abhi temporary
  final String providerId = "prov_1"; // abhi temporary

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  Future<void> _setupChat() async {
    chatId = await FirebaseHelper.instance.getOrCreateChat(
      jobId: jobId,
      customerId: customerId,
      providerId: providerId,
    );
    setState(() {}); // refresh UI
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || chatId.isEmpty) return;

    // Firestore pe send
    await FirebaseHelper.instance.sendMessage(
      chatId: chatId,
      senderId: customerId, // abhi hardcoded, baad me current user
      text: text,
    );

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return MainLayout(
      title: widget.user['name'],
      currentIndex: 1,
      isAvatarShow: false,
      showBottomNav: false,
      body:
          chatId.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: FirebaseHelper.instance.listenMessages(
                        chatId: chatId,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final messages = snapshot.data!;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isSent = message["senderId"] == customerId;
                            final isLastSentMessage =
                                isSent &&
                                messages.lastIndexWhere(
                                      (msg) => msg["senderId"] == customerId,
                                    ) ==
                                    index;

                            return _buildMessageBubble(
                              message,
                              isSent,
                              isLastSentMessage,
                              isDark,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt,
                            color:
                                isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.mic,
                            color:
                                isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide.none,
                              ),
                              fillColor:
                                  isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightSurface,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md.w,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _sendMessage(_controller.text),
                          icon: Icon(
                            Icons.send,
                            color:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildMessageBubble(
    Map<String, dynamic> message,
    bool isSent,
    bool isLastSentMessage,
    bool isDark,
  ) {
    final maxWidth = (MediaQuery.of(context).size.width * 0.7).clamp(
      200.0,
      500.0,
    );

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.sm.h,
                horizontal: AppSpacing.md.w,
              ),
              decoration: BoxDecoration(
                color:
                    isSent
                        ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(isSent ? 12.r : 0),
                  bottomRight: Radius.circular(isSent ? 0 : 12.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.4)
                            : Colors.grey.withOpacity(0.3),
                    blurRadius: 6.r,
                    spreadRadius: 1.r,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: CustomText(
                text: message["text"] ?? "",
                size: CustomTextSize.base,
                fontFamily: "Roboto",
                fontWeight: FontWeight.normal,
                color:
                    isSent ? CustomTextColor.alwaysWhite : CustomTextColor.text,
              ),
            ),
          ),
          if (isLastSentMessage && isSent)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs.h),
              child: CustomText(
                text: message["read"] == true ? "Seen" : "Sent",
                size: CustomTextSize.xs,
                fontFamily: "Roboto",
                fontWeight: FontWeight.normal,
                color: CustomTextColor.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
