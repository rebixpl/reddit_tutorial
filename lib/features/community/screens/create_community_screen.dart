import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/features/user_profile/screens/widgets/rounded_text_field.dart';
import 'package:reddit_tutorial/responsive/responsive.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Community Name'),
                    ),
                    const SizedBox(height: 10.0),
                    RoundedTextField(
                      controller: communityNameController,
                      hintText: 'r/CommunityName',
                      maxLength: 21,
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () => createCommunity(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Create Community',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
