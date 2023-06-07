import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/models/post_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) {
    ref.read(postControllerProvider.notifier).deletePost(
          context: context,
          post: post,
        );
  }

// ---------- NAVIGATION ----------
  void upvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }
  // ---------- NAVIGATION ----------

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        post.communityProfilePic,
                                      ),
                                      radius: 16.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              navigateToCommunity(context),
                                          child: Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            'u/${post.username}',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 6.0,
                            ),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (isTypeLink)
                            SizedBox(
                              width: double.infinity,
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Text(
                              post.description!,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upvotePost(ref),
                                    icon: Icon(
                                      Constants.up,
                                      size: 30.0,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => downvotePost(ref),
                                    icon: Icon(
                                      Constants.down,
                                      size: 30.0,
                                      color: post.downvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(
                                      Icons.comment,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => navigateToComments(context),
                                    child: Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ),
                                  ref
                                      .watch(getCommunityByNameProvider(
                                          post.communityName))
                                      .when(
                                        data: (community) {
                                          if (community.mods
                                              .contains(user.uid)) {
                                            return IconButton(
                                              onPressed: () =>
                                                  deletePost(ref, context),
                                              icon: const Icon(
                                                Icons.admin_panel_settings,
                                              ),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                        loading: () => const Loader(),
                                        error: (error, stackTrace) => ErrorText(
                                          error: error.toString(),
                                        ),
                                      ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                              ),
                                              itemCount: user.awards.length,
                                              itemBuilder: (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                final award =
                                                    user.awards[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 16.0,
                                                  ),
                                                  child: Image.asset(
                                                    Constants.awards[award]!,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.card_giftcard_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(height: 10.0),
      ],
    );
  }
}
