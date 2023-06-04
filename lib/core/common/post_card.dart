import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';

    return Container(
      child: Text(post.communityName),
    );
  }
}
