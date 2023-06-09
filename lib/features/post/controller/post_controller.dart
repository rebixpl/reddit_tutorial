import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/post/repository/post_repository.dart';
import 'package:reddit_tutorial/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_tutorial/models/comment_model.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:reddit_tutorial/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

// ------------------- GET POST COMMENTS PROVIDER ------------------------
final getPostCommentsProvider =
    StreamProvider.family<List<Comment>, String>((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

// ------------------- GET POST BY ID PROVIDER ------------------------
final getPostByIdProvider =
    StreamProvider.family<Post, String>((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

// ------------------- POST CONTROLLER PROVIDER ------------------------
final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

// ------------------- USER POSTS PROVIDER ------------------------
final userPostsProvider = StreamProvider.family<List<Post>, List<Community>>(
    (ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

// ------------------- GUEST POSTS PROVIDER ------------------------
final guestPostsProvider = StreamProvider<List<Post>>((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

// ------------------- POST CONTROLLER ------------------------
class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true; // show loader
    String postId = const Uuid().v4();

    final user = _ref.read(userProvider)!;

    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);

    state = false; // hide loader
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Posted Successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true; // show loader
    String postId = const Uuid().v4();

    final user = _ref.read(userProvider)!;

    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);

    state = false; // hide loader
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Posted Successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
    required Uint8List? webFile,
  }) async {
    state = true; // show loader
    String postId = const Uuid().v4();

    final user = _ref.read(userProvider)!;

    final imgResult = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
      webFile: webFile,
    );

    imgResult.fold(
      (l) => showSnackBar(context, l.message),
      (downloadUrl) async {
        final post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: downloadUrl,
        );

        final res = await _postRepository.addPost(post);

        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.imagePost);

        state = false; // hide loader
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, 'Posted Successfully!');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  void deletePost({
    required BuildContext context,
    required Post post,
  }) async {
    state = true; // show loader

    final res = await _postRepository.deletePost(post);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);

    state = false; // hide loader
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Post Deleted Successfully!');
      },
    );
  }

  void upvote(Post post) async {
    final user = _ref.read(userProvider)!;
    _postRepository.upvote(post, user.uid);
  }

  void downvote(Post post) async {
    final user = _ref.read(userProvider)!;
    _postRepository.downvote(post, user.uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    } else {
      return Stream.value([]);
    }
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;

    String commentId = const Uuid().v4();

    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
    );

    final res = await _postRepository.addComment(comment);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.awardPost);

        _ref.read(userProvider.notifier).update(
          (state) {
            state!.awards.remove(award);
            return state;
          },
        );

        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
