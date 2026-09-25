import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Centers content and limits width so the UI stays readable on web.
class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

bool isWideLayout(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= AppConstants.compactBreakpoint;
}
