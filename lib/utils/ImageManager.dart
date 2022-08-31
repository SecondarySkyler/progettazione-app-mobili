import 'package:image_picker/image_picker.dart';

class ImageManager {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<XFile?> getImage(ImageSource source) async {
    XFile? selectedImage = await _imagePicker.pickImage(source: source);
    if (selectedImage != null) {
      return selectedImage;
    } else {
      return null;
    }
  }

}