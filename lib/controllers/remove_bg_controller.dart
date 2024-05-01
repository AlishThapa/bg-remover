import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../components/snackbar.dart';

class RemoveBgController extends GetxController {
  Rxn<Uint8List> imageFile = Rxn<Uint8List>();
  String? imagePath;
  ScreenshotController controller = ScreenshotController();
  RxBool isLoading = false.obs;

  Future<void> removeBg(String imagePath) async {
    isLoading(true);
    BotToast.showLoading();
    var request = http.MultipartRequest("POST", Uri.parse("https://api.remove.bg/v1.0/removebg"));
    request.files.add(await http.MultipartFile.fromPath("image_file", imagePath));
    request.headers.addAll({"X-API-Key": 'sWYNJDSSPf4DQc2Yk6sCkFHG'});
    final response = await request.send();
    isLoading(false);
    BotToast.closeAllLoading();
    if (response.statusCode == 200) {
      http.Response imgRes = await http.Response.fromStream(response);
      imageFile(imgRes.bodyBytes);
    } else {
      throw Exception("Failed to remove background");
    }
  }

  void pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      imagePath = pickedImage.path;
      imageFile(await pickedImage.readAsBytes());
    } else {
      imageFile(null);
    }
  }

  void cleanUp() {
    imageFile(null);
    update();
  }

  Future<String> getSavePath() async {
    final directory = await getExternalStorageDirectory();
    return "${directory!.path}/SavedImages";
  }

  void saveImage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      try {
        final path = await getSavePath();
        final directory = Directory(path);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        String fileName = "${DateTime.now().microsecondsSinceEpoch}.png";
        final filePath = '$path/$fileName';
        await controller.captureAndSave(directory.path, fileName: fileName);
        showSnackBar("Success", "Image saved successfully", false);
        if (Platform.isAndroid) {
          await ImageGallerySaver.saveFile(filePath);
        }
      } catch (e) {
        showSnackBar("Error", "Failed to save image: $e", false);
        print('Failed to save image: $e');
      }
    } else {
      showSnackBar("Error", "Storage permission denied\nPlease give the permission from the settings of your phone", false);
    }
  }
}
