import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/repository/auth_repository.dart';
import 'package:reddit_tutorial/models/user_model.dart';

// ------------------- USER PROVIDER -----------------------------------
final userProvider = StateProvider<UserModel?>((ref) => null);

// ------------------- AUTH CONTROLLER PROVIDER ------------------------
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

// ------------------- AUTH STATE CHANGE PROVIDER ---------------------
final authStateChangeProvider = StreamProvider<User?>(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
  },
);

// ------------------- GET USER DATA PROVIDER ------------------------
final getUserDataProvider = StreamProvider.family<UserModel, String>(
  (ref, String uid) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getUserData(uid);
  },
);

// ------------------- AUTH CONTROLLER -------------------------------
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading is false by default

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true; // loading is true when we start the request
    final user = await _authRepository.signInWithGoogle();
    state = false; // loading is false when we finish the request
    // Left is an error, Right is a success (userModel)
    user.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (userModel) => _ref.read(userProvider.notifier).update(
            (state) => userModel,
          ),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
