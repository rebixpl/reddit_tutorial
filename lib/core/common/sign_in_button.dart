import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
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
