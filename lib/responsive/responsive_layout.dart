import 'package:flutter/widgets.dart';

import '../utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webLayout;
  final Widget appLayout;
  const ResponsiveLayout({
    super.key,
    required this.webLayout,
    required this.appLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return webLayout;
        }
        return appLayout;
      }),
    );
  }
}
