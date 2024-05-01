import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../components/choose_image.dart';
import '../components/primary_button.dart';
import '../components/snackbar.dart';
import '../controllers/remove_bg_controller.dart';

class RemoveBackgroundScreen extends StatelessWidget {
  const RemoveBackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final RemoveBgController controller = Get.put(RemoveBgController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 10,
        title: const Text('Remove Background', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.imageFile.value == null) ...[
                    const WelcomeTxt(
                      text: 'Hi welcome to remove background app.',
                    ),
                    const WelcomeTxt(text: 'Here you can select image from your camera or from gallery directly.'),
                    const WelcomeTxt(text: 'Select an image to proceed further.'),
                    const SizedBox(height: 40),
                  ],
                  controller.imageFile.value != null
                      ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                        child: Screenshot(
                          controller: controller.controller,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              controller.imageFile.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      : Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    childText: controller.imageFile.value != null ? "Remove Background" : "Select Image",
                    textColor: Colors.white,
                    buttonColor: theme.cardColor,
                    onPressed: () async {
                      if (controller.imageFile.value == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return imageSourceDialog(controller, context);
                          },
                        );
                      } else {
                        await controller.removeBg(controller.imagePath!);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (controller.imageFile.value != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PrimaryButton(
                            childText: "Save Image",
                            textColor: Colors.white,
                            buttonColor: theme.cardColor,
                            onPressed: () async {
                              if (controller.imageFile.value != null) {
                                controller.saveImage();
                              } else {
                                showSnackBar("Error", "Please select an image", true);
                              }
                            }),
                        PrimaryButton(
                            childText: "Add New Image",
                            textColor: Colors.white,
                            buttonColor: theme.cardColor,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return imageSourceDialog(controller, context);
                                },
                              );
                            }),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class WelcomeTxt extends StatelessWidget {
  const WelcomeTxt({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold));
  }
}
