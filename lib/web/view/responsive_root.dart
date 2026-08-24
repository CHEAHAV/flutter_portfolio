import 'package:flutter/material.dart';
import '../web.dart';
import '../../navigation/navigation.dart';
import '../../shared/shared.dart';

/// Entry point for every screen size: the phone keeps the bottom-navigation
/// layout it already has, tablet and desktop get the web shell.
class ResponsiveRoot extends StatefulWidget {
  const ResponsiveRoot({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ResponsiveRoot> createState() => _ResponsiveRootState();
}

class _ResponsiveRootState extends State<ResponsiveRoot> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _onIndexChanged(int index) => _index = index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final device = Breakpoints.of(constraints.maxWidth);

        if (device == DeviceType.mobile) {
          return BottomNav(
            initialIndex  : _index,
            onIndexChanged: _onIndexChanged,
          );
        }

        return WebShell(
          initialIndex  : _index,
          onIndexChanged: _onIndexChanged,
        );
      },
    );
  }
}
