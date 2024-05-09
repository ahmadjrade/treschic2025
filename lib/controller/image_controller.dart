import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  RxString imagePath = ''.obs;

  Future<void> getImageFromCamera() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        imagePath.value = image.path;
      }
    } catch (e) {
      // Handle error
      print('Error picking image from camera: $e');
    }
  }

  Future<void> getImageFromGallery() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        imagePath.value = image.path;
      }
    } catch (e) {
      // Handle error
      print('Error picking image from gallery: $e');
    }
  }
}
