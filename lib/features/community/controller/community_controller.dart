import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/repository/community_repository.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

// ------------------- USER COMMUNITIES PROVIDER -----------------------------
final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

// --------------- COMMUNITY CONTROLLER PROVIDER -----------------------------
final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

// ------------------- GET COMMUNITY BY NAME PROVIDER ------------------------
final getCommunityByNameProvider =
    StreamProvider.family<Community, String>((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

// ------------------- SEARCH COMMUNITY PROVIDER ------------------------------
final searchCommunityProvider =
    StreamProvider.family<List<Community>, String>((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

// ------------------------ COMMUNITY CONTROLLER ----------------------------
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
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

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, 'You left r/${community.name}.');
        } else {
          showSnackBar(context, 'You joined r/${community.name}.');
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required Community community,
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
  }) async {
    state = true;

    //------- profileFile -------
    if (profileFile != null) {
      // FOR EXAMPLE:
      // communities/profile/siweKlapkiFanclub
      // preexisting file will be deleted and replaced with new one
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    //------- bannerFile -------
    if (bannerFile != null) {
      // FOR EXAMPLE:
      // communities/banner/siweKlapkiFanclub
      // preexisting file will be deleted and replaced with new one
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
    String communityName,
    List<String> modsUids,
    BuildContext context,
  ) async {
    final res = await _communityRepository.addMods(communityName, modsUids);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
