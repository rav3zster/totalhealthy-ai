import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final String? loadingText;

  const LoadingStateWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? _buildDefaultLoading();
    }
    return child;
  }

  Widget _buildDefaultLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFC2D86A),
            strokeWidth: 3,
          ),
          if (loadingText != null) ...[
            const SizedBox(height: 16),
            Text(
              loadingText!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFF2A2A2A),
              const Color(0xFF3A3A3A),
              _animation.value,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

class ListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const ListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SkeletonLoader(
                width: 60,
                height: 60,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(width: double.infinity, height: 16),
                    const SizedBox(height: 8),
                    const SkeletonLoader(width: 120, height: 14),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SkeletonLoader(width: 40, height: 12),
                        const SizedBox(width: 12),
                        const SkeletonLoader(width: 40, height: 12),
                        const SizedBox(width: 12),
                        const SkeletonLoader(width: 40, height: 12),
                      ],
                    ),
                  ],
                ),
              ),
              const SkeletonLoader(
                width: 32,
                height: 32,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ],
          ),
        );
      },
    );
  }
}
