import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../theme/app_theme.dart';

/// Chat bubble widget with typewriter effect for AI messages
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool showTypewriter;
  final VoidCallback? onTypewriterComplete;
  final Color? tierColor;
  
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.showTypewriter = false,
    this.onTypewriterComplete,
    this.tierColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: isUser ? 50 : 16,
          right: isUser ? 16 : 50,
          top: 8,
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser 
              ? AppTheme.oxidizedCopper.withOpacity(0.15)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: Border.all(
            color: isUser 
                ? AppTheme.oxidizedCopper.withOpacity(0.3)
                : (tierColor ?? AppTheme.textMuted).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: showTypewriter && !isUser
            ? AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    message,
                    textStyle: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    speed: const Duration(milliseconds: 30),
                  ),
                ],
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
                onFinished: onTypewriterComplete,
              )
            : Text(
                message,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
      ),
    );
  }
}

/// Typing indicator for AI
class TypingIndicator extends StatefulWidget {
  final Color? tierColor;
  
  const TypingIndicator({
    super.key,
    this.tierColor,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 50, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: (widget.tierColor ?? AppTheme.textMuted).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final delay = index * 0.2;
                final progress = (_controller.value + delay) % 1.0;
                final yOffset = -4 * (progress < 0.5 
                    ? progress * 2 
                    : (1 - progress) * 2);
                return Transform.translate(
                  offset: Offset(0, yOffset),
                  child: child,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: widget.tierColor ?? AppTheme.oxidizedCopper,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
