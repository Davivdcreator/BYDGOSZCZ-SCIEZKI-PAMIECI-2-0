import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../models/monument.dart';
import '../models/user_profile.dart';
import '../services/ai_chat_service.dart';
import '../widgets/chat_bubble.dart';

/// Screen 5: AI Chat - Clean modern design
class ChatScreen extends StatefulWidget {
  final Monument monument;

  const ChatScreen({
    super.key,
    required this.monument,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isShowingTypewriter = false;

  late AnimationController _avatarController;

  @override
  void initState() {
    super.initState();

    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Add greeting message
    _addAIMessage(AIChatService.getGreeting(widget.monument));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _addAIMessage(String content) {
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isShowingTypewriter = true;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
      _isShowingTypewriter = false;
    });
    _messageController.clear();
    _scrollToBottom();

    _avatarController.repeat(reverse: true);

    final response = await AIChatService.generateResponse(
      monument: widget.monument,
      userMessage: text,
      history: _messages,
    );

    _avatarController.stop();
    _avatarController.reset();

    setState(() {
      _isTyping = false;
      _addAIMessage(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tier = widget.monument.tier;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Header
          _buildHeader(tier),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return TypingIndicator(tierColor: tier.color);
                }

                final message = _messages[index];
                final isLastAI =
                    !message.isUser && index == _messages.length - 1;

                return ChatBubble(
                  message: message.content,
                  isUser: message.isUser,
                  showTypewriter: isLastAI && _isShowingTypewriter,
                  tierColor: tier.color,
                  onTypewriterComplete: () {
                    setState(() => _isShowingTypewriter = false);
                  },
                );
              },
            ),
          ),

          // Sample questions
          if (_messages.length <= 1 &&
              widget.monument.sampleQuestions.isNotEmpty)
            _buildSampleQuestions(),

          // Input
          _buildInputArea(tier),
        ],
      ),
    );
  }

  Widget _buildHeader(MonumentTier tier) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 8,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.surfaceSecondary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: AppTheme.textPrimary,
          ),

          // Avatar
          AnimatedBuilder(
            animation: _avatarController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_avatarController.value * 0.05),
                child: child,
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tier.lightColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: tier.color,
                  width: 2,
                ),
              ),
              child: Icon(
                _getAvatarIcon(),
                color: tier.color,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.monument.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  tier.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: tier.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleQuestions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.monument.sampleQuestions.map((question) {
          return GestureDetector(
            onTap: () {
              _messageController.text = question;
              _sendMessage();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.surfaceSecondary,
                ),
              ),
              child: Text(
                question,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea(MonumentTier tier) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(
          top: BorderSide(color: AppTheme.surfaceSecondary),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Napisz wiadomość...',
                  hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isTyping ? null : _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAvatarIcon() {
    switch (widget.monument.tier) {
      case MonumentTier.tierC:
        return Icons.article_outlined;
      case MonumentTier.tierB:
        return Icons.visibility_outlined;
      case MonumentTier.tierA:
        return Icons.person_outline;
      case MonumentTier.tierS:
        return Icons.auto_awesome;
      case MonumentTier.tierUnique:
        return Icons.diamond_outlined;
    }
  }
}
