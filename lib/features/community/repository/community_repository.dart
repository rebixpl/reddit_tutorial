import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/community_model.dart';

/// --------------- COMMUNITY REPOSITORY PROVIDER -----------------------------
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

/// ------------------------ COMMUNITY REPOSITORY ----------------------------
class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists';
        // since we have thrown it, this text will go to the catch block below
        // and will be wrapped in a Failure object and returned to the UI layer
        // with left()
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities => _firestore.collection(
        FirebaseConstants.communitiesCollection,
      );
}
