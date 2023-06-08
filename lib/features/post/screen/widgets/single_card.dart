import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class SingleCard extends ConsumerWidget {
  const SingleCard({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = kIsWeb ? 360.0 : 120.0;
    double iconSize = kIsWeb ? 120.0 : 60.0;
    final currentTheme = ref.watch(themeNotifierProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: onTap,
      child: SizedBox(
        height: cardHeightWidth,
        width: cardHeightWidth,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 16.0,
          color: currentTheme.colorScheme.background,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
