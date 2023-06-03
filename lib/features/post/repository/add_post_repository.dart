import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';

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
      return right(_posts.doc(post.id).set(post.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);
}
