import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../models/monument.dart';
import '../models/user_profile.dart';
import '../services/ai_chat_service.dart';
import '../widgets/frosted_glass_panel.dart';
import '../widgets/chat_bubble.dart';

/// Screen 5: "Sweet Spot" - AI Chat Screen
/// Heart of the app - Standardized chat interface with tier-based AI
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
    
    // Add user message
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
    
    // Start avatar animation
    _avatarController.repeat(reverse: true);
    
    // Generate AI response
    final response = await AIChatService.generateResponse(
      monument: widget.monument,
      userMessage: text,
      history: _messages,
    );
    
    // Stop avatar animation
    _avatarController.stop();
    _avatarController.reset();
    
    // Add AI response
    setState(() {
      _isTyping = false;
      _addAIMessage(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tier = widget.monument.tier;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.porcelainWhite,
          image: const DecorationImage(
            image: AssetImage('assets/textures/wooden-floor-background.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Column(
          children: [
            // Header (Frosted glass)
            _buildHeader(tier),
            
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return TypingIndicator(tierColor: tier.color);
                  }
                  
                  final message = _messages[index];
                  final isLastAI = !message.isUser && index == _messages.length - 1;
                  
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
            
            // Sample questions (for first interaction)
            if (_messages.length <= 1 && widget.monument.sampleQuestions.isNotEmpty)
              _buildSampleQuestions(),
            
            // Input area
            _buildInputArea(tier),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(MonumentTier tier) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 12,
            left: 8,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: AppTheme.frostedGlass,
            border: Border(
              bottom: BorderSide(
                color: tier.color.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
                color: AppTheme.textPrimary,
              ),
              
              // Animated avatar (pencil sketch style)
              AnimatedBuilder(
                animation: _avatarController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_avatarController.value * 0.1),
                    child: child,
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: tier.color,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: tier.color.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getAvatarIcon(),
                    color: tier.color,
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Name and tier
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.monument.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 3,
                      width: 60,
                      decoration: BoxDecoration(
                        color: tier.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Tier badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tier.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tier.color.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  tier.displayName,
                  style: TextStyle(
                    color: tier.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                color: AppTheme.frostedGlass,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.monument.tier.color.withOpacity(0.3),
                ),
              ),
              child: Text(
                question,
                style: TextStyle(
                  color: AppTheme.textPrimary,
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
      decoration: BoxDecoration(
        color: AppTheme.frostedGlass,
        border: Border(
          top: BorderSide(
            color: AppTheme.frostedGlassBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Napisz wiadomość...',
                hintStyle: TextStyle(color: AppTheme.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Voice button (for S-tier)
          if (tier.hasVoiceControl)
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tier.color.withOpacity(0.15),
              ),
              child: IconButton(
                onPressed: () {
                  // Voice input would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sterowanie głosem dostępne dla Ikon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(Icons.mic, color: tier.color),
              ),
            ),
          
          // Send button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: tier.gradient ?? LinearGradient(
                colors: [tier.color.withOpacity(0.8), tier.color],
              ),
              boxShadow: [
                BoxShadow(
                  color: tier.color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _isTyping ? null : _sendMessage,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
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
    }
  }
}
