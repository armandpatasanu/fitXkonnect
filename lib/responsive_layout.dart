import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget wSLayout;
  final Widget mSLayout;
  const ResponsiveLayout({
    Key? key,
    required this.wSLayout,
    required this.mSLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return wSLayout;
        } else {
          return mSLayout;
        }
      },
    );
  }
}
