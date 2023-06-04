import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:reddit_tutorial/models/post_model.dart';

// ------------------- ADD POST REPOSITORY PROVIDER ------------------------
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firebaseFirestore: ref.watch(firestoreProvider));
});

// ------------------- ADD POST REPOSITORY ------------------------
class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);
}
