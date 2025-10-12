import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/utils/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_text.dart';

class ConversationScreen extends StatefulWidget {
  final Map<String, dynamic> customer;
  final Map<String, dynamic> provider;
  final String jobId;

  const ConversationScreen({
    super.key,
    required this.customer,
    required this.provider,
    required this.jobId,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? chatId;
  bool _isChatReady = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  Future<void> _initializeChat() async {
    try {
      // 🔍 Check if chat exists for this job and both participants
      final existingChat = await FirebaseHelper.instance.findChatByParticipants(
        jobId: widget.jobId,
        customerId: widget.customer['id'],
        providerId: widget.provider['id'],
      );

      if (existingChat == null) {
        debugPrint(
          "⚠️ No existing chat found for this job. It should be created by provider.",
        );
      } else {
        await FirebaseHelper.instance.markAllMessagesAsRead(
          chatId: existingChat.id,
          currentUserId: widget.customer['id'],
        );
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("❌ Error initializing chat: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setupChat() async {
    try {
      // ✅ Step 1: Check if chat already exists
      final existingChat = await FirebaseHelper.instance.findChatByParticipants(
        jobId: widget.jobId,
        customerId: widget.customer['id'],
        providerId: widget.provider['id'],
      );

      String createdChatId;
      bool isNew = false;

      if (existingChat != null) {
        // Chat mil gayi → use karo
        createdChatId = existingChat.id;
      } else {
        // ✅ Step 2: Chat nahi mili → create nayi
        final result = await FirebaseHelper.instance.getOrCreateChat(
          customerName: widget.customer['name'],
          providerName: widget.provider['name'],
          jobId: widget.jobId,
          customerId: widget.customer['id'],
          providerId: widget.provider['id'],
        );
        createdChatId = result['chatId'];
        isNew = result['isNew'] ?? false;
      }

      // ✅ Mark all messages as read for provider
      await FirebaseHelper.instance.markAllMessagesAsRead(
        chatId: createdChatId,
        currentUserId: widget.provider['id'],
      );

      if (mounted) {
        setState(() {
          chatId = createdChatId;
          _isChatReady = true;
        });
      }

      // ✅ Send auto message only if new chat created
      if (isNew) {
        await FirebaseHelper.instance.sendMessage(
          chatId: createdChatId,
          senderId: widget.provider['id'],
          senderName: widget.provider['name'],
          text:
              "Hi, I have accepted your job request. My name is ${widget.provider['name']}, and I will be there at the scheduled time. If you have any questions or special instructions, feel free to message me here. I’m happy to help!",
        );
      }
    } catch (e) {
      debugPrint("❌ Chat setup error: $e");
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || chatId == null) return;

    await FirebaseHelper.instance.sendMessage(
      chatId: chatId!,
      senderId: widget.provider['id'],
      senderName: widget.provider['name'],
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
      title: widget.customer['name'],
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

                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          FirebaseHelper.instance.markAllMessagesAsRead(
                            chatId: chatId!,
                            currentUserId: widget.provider['id'],
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
                            final isSent =
                                message["senderId"].toString() ==
                                widget.provider['id'];
                            final isLastSentMessage =
                                isSent &&
                                messages.lastIndexWhere(
                                      (msg) =>
                                          msg["senderId"].toString() ==
                                          widget.provider['id'],
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
