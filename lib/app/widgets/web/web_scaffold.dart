import 'package:flutter/material.dart';
import '../../core/theme/theme_helper.dart';
import 'web_sidebar.dart';
import 'web_topbar.dart';

class WebScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? topbarActions;
  final double maxContentWidth;

  const WebScaffold({
    super.key,
    required this.title,
    required this.body,
    this.topbarActions,
    this.maxContentWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Row(
        children: [
          const WebSidebar(),
          Expanded(
            child: Column(
              children: [
                WebTopbar(title: title, actions: topbarActions),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: context.backgroundGradient,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                        child: body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
