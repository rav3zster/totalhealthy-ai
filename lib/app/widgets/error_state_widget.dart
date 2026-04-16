import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryText;
  final Widget? customAction;

  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.icon,
    this.retryText,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (customAction != null)
              customAction!
            else if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: Text(
                  retryText ?? 'Retry',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2D86A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorWidget({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      error:
          message ??
          'Network connection failed.\nPlease check your internet connection.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      retryText: 'Try Again',
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;
  final String? imagePath;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.actionText,
    this.onAction,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                color: Colors.white54,
                size: 64,
              ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2D86A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class InlineErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final bool compact;

  const InlineErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: compact ? 16 : 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: compact ? 12 : 14),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  color: const Color(0xFFC2D86A),
                  fontSize: compact ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
