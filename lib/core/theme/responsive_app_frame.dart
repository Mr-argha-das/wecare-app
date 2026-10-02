import 'package:flutter/material.dart';

class ResponsiveAppFrame extends StatelessWidget {
  final Widget? child;

  const ResponsiveAppFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (child == null) return const SizedBox.shrink();
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;

    return ColoredBox(
      color: const Color(0xFFEAF2EF),
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: isWide ? 1180 : double.infinity),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8F7),
              boxShadow: isWide
                  ? const [
                      BoxShadow(
                        color: Color(0x180D3329),
                        blurRadius: 34,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.textScalerOf(context).clamp(
                  minScaleFactor: 0.9,
                  maxScaleFactor: 1.25,
                ),
              ),
              child: child!,
            ),
          ),
        ),
      ),
    );
  }
}
