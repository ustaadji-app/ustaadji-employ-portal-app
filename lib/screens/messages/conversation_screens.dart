import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/utils/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_text.dart';

class ConversationScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final String jobId;
  final String currentUserId;
  final String customerName;
  final String providerName;

  const ConversationScreen({
    super.key,
    required this.user,
    required this.jobId,
    required this.currentUserId,
    required this.customerName,
    required this.providerName,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? chatId;
  bool _isChatReady = false;

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  Future<void> _setupChat() async {
    try {
      final createdChatId = await FirebaseHelper.instance.getOrCreateChat(
        customerName: widget.customerName,
        providerName: widget.providerName,
        jobId: widget.jobId,
        customerId:
            (widget.user["role"] == "customer"
                    ? widget.user["id"]
                    : widget.currentUserId)
                .toString(), // ensure string
        providerId:
            (widget.user["role"] == "provider"
                    ? widget.user["id"]
                    : widget.currentUserId)
                .toString(), // ensure string
      );

      if (mounted) {
        setState(() {
          chatId = createdChatId.toString(); // ensure string
          _isChatReady = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Chat setup error: $e");
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || chatId == null) return;

    await FirebaseHelper.instance.sendMessage(
      chatId: chatId!,
      senderId: widget.currentUserId,
      senderName: widget.user['name']?.toString() ?? "Unknown",
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

    return MainLayout(
      title: widget.user['name']?.toString() ?? "Chat",
      currentIndex: 1,
      isAvatarShow: false,
      showBottomNav: false,
      body:
          !_isChatReady || chatId == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // ✅ Messages Area
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: FirebaseHelper.instance.listenMessages(
                        chatId: chatId!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No messages yet"));
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
                            final isSent =
                                message["senderId"].toString() ==
                                widget.currentUserId;
                            final isLastSentMessage =
                                isSent &&
                                messages.lastIndexWhere(
                                      (msg) =>
                                          msg["senderId"].toString() ==
                                          widget.currentUserId,
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

                  // ✅ Input Field
                  SafeArea(
                    child: SizedBox(
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
                                  vertical: 10.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () => _sendMessage(_controller.text),
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isSent)
              Padding(
                padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
                child: CustomText(
                  text: message["senderName"]?.toString() ?? "",
                  size: CustomTextSize.xs,
                  fontWeight: FontWeight.bold,
                  color: CustomTextColor.textSecondary,
                ),
              ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color:
                      isSent
                          ? (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r),
                    bottomLeft: Radius.circular(isSent ? 14.r : 0),
                    bottomRight: Radius.circular(isSent ? 0 : 14.r),
                  ),
                ),
                child: CustomText(
                  text: message["text"]?.toString() ?? "",
                  size: CustomTextSize.base,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  color:
                      isSent
                          ? CustomTextColor.alwaysWhite
                          : CustomTextColor.text,
                ),
              ),
            ),
            if (isLastSentMessage && isSent)
              Padding(
                padding: EdgeInsets.only(top: 2.h, right: 6.w),
                child: CustomText(
                  text: message["read"] == true ? "Seen" : "Sent",
                  size: CustomTextSize.xs,
                  color: CustomTextColor.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
