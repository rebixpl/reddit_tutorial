import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/post/screen/widgets/single_card.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleCard(
          icon: Icons.image_outlined,
          onTap: () => navigateToType(context, 'image'),
        ),
        SingleCard(
          icon: Icons.font_download_outlined,
          onTap: () => navigateToType(context, 'text'),
        ),
        SingleCard(
          icon: Icons.link_outlined,
          onTap: () => navigateToType(context, 'link'),
        ),
      ],
    );
  }
}
