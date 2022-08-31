import 'package:path_provider/path_provider.dart';

class DirectoryManager {
  static const String _imagesPath = 'closet_images';

  static Future<String> get applicationDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<String> get imagesDirectory async {
    final appDir = await applicationDirectory;
    return '$appDir/$_imagesPath';
  }


}