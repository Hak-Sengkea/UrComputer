import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/support_provider.dart';
import '../../theme/theme_extensions.dart';
import '../../models/support_message.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportProvider>().initializeChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final supportProvider = context.read<SupportProvider>();

    final senderName = authProvider.currentUser != null
        ? authProvider.userFullName.isNotEmpty 
            ? authProvider.userFullName 
            : authProvider.userEmail.split('@')[0]
        : 'User';

    supportProvider.sendMessage(text, senderName);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final sizes = Theme.of(context).extension<AppSizesExtension>()!;

    return Scaffold(
      backgroundColor: colors.darkBg,
      appBar: AppBar(
        backgroundColor: colors.darkBg,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(sizes.space8),
              decoration: BoxDecoration(
                gradient: colors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.black,
                size: 20,
              ),
            ),
            SizedBox(width: sizes.space12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UrComputer Support',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: sizes.space4),
                    Text(
                      'AI & Telegram Agent Active',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<SupportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colors.neonCyan),
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Padding(
              padding: EdgeInsets.all(sizes.space24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: colors.neonPink, size: 48),
                    SizedBox(height: sizes.space16),
                    Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: sizes.space8),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          final messages = provider.messages;

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: colors.textSecondary.withOpacity(0.5),
                              size: 64,
                            ),
                            SizedBox(height: sizes.space16),
                            Text(
                              'How can we help you today?',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: sizes.space8),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: sizes.space32),
                              child: Text(
                                'Ask about PC parts, custom builder help, or compatibility queries. Our AI Assistant and Support Team are online!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colors.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(sizes.space16),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          // Display in reverse order (newest at bottom)
                          final message = messages[messages.length - 1 - index];
                          return _buildMessageBubble(message, colors, sizes);
                        },
                      ),
              ),
              _buildInputArea(colors, sizes),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(
    SupportMessage message,
    AppColorsExtension colors,
    AppSizesExtension sizes,
  ) {
    final isMe = message.isFromCustomer;

    return Padding(
      padding: EdgeInsets.only(bottom: sizes.space12),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(left: sizes.space4, bottom: sizes.space4),
              child: Text(
                message.senderName,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colors.cardBg,
                  child: Icon(
                    message.senderName == 'AI Assistant'
                        ? Icons.android
                        : Icons.support_agent,
                    size: 16,
                    color: colors.neonCyan,
                  ),
                ),
                SizedBox(width: sizes.space8),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizes.space16,
                    vertical: sizes.space12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? null : colors.cardBg,
                    gradient: isMe ? colors.primaryGradient : null,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(sizes.radiusMedium),
                      topRight: Radius.circular(sizes.radiusMedium),
                      bottomLeft: Radius.circular(
                        isMe ? sizes.radiusMedium : sizes.radiusSmall,
                      ),
                      bottomRight: Radius.circular(
                        isMe ? sizes.radiusSmall : sizes.radiusMedium,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (isMe) ...[
                SizedBox(width: sizes.space8),
                const Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(AppColorsExtension colors, AppSizesExtension sizes) {
    return Container(
      padding: EdgeInsets.all(sizes.space16),
      color: colors.darkBg,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.cardBg,
                  borderRadius: BorderRadius.circular(sizes.radiusPill),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: sizes.space16),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: sizes.space8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.neonCyan.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}