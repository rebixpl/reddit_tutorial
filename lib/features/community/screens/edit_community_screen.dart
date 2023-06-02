import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  File? profileFile;
  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          community: community,
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.colorScheme.background,
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200.0,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  radius: const Radius.circular(10.0),
                                  dashPattern: const [10, 4],
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  color:
                                      currentTheme.textTheme.bodyMedium!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40.0,
                                                ),
                                              )
                                            : Image.network(community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20.0,
                                left: 20.0,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              Image.file(profileFile!).image,
                                          radius: 32.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(community.avatar),
                                          radius: 32.0,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
