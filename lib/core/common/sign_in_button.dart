import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(context, ref),
      icon: Image.asset(
        Constants.googlePath,
        width: 35.0,
      ),
      label: const Text(
        'Continue with Google',
        style: TextStyle(
          fontSize: 18.0,
          color: Pallete.whiteColor,
        ),
      ),
      style: signInButtonStyle(),
    );
  }

  ButtonStyle signInButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Pallete.greyColor,
      minimumSize: const Size(
        double.infinity,
        50.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
