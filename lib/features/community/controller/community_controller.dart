import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/repository/community_repository.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

/// --------------- COMMUNITY CONTROLLER PROVIDER -----------------------------
final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);

  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
  );
});

/// ------------------------ COMMUNITY CONTROLLER ----------------------------
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        super(false); // initially false because we are not loading anything

  void createCommunity(String name, BuildContext context) async {
    // set state to true to show loading indicator, because user
    // will have to wait for the community to be created
    state = true;

    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      name: name,
      id: name,
      avatar: Constants.avatarDefault,
      banner: Constants.bannerDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);

    // set state to false to hide loading indicator, we got the result
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message), // FAILURE IN CREATING COMMUNITY
      (r) {
        // SUCCESS IN CREATING COMMUNITY
        showSnackBar(context, 'Community created successfully');
        Routemaster.of(context).pop();
      },
    );
  }
}
