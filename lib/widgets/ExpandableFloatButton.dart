import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_closet/utils/ImageManager.dart';

class ExpandableFloatButton extends StatelessWidget {
  final ImagePicker _imagePicker = ImagePicker();
  late XFile? img;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close_rounded,
      // childrenButtonSize: const Size(40, 40), disallinea e icone restano grandi
      children: [
        SpeedDialChild(
          child: const Icon(Icons.image),
          label: "Gallery",
          onTap: () async => {
            img = await ImageManager.getImage(ImageSource.gallery),
            if (img != null) {
              Navigator.of(context).pushNamed('/form', arguments: img)
            }
          }
        ),
        SpeedDialChild(
          child: const Icon(Icons.camera_alt),
          label: "Camera",
          onTap: () async => {
            img = await ImageManager.getImage(ImageSource.camera),
            if (img != null) {
              Navigator.of(context).pushNamed('/form', arguments: img)
            }
          }
        ),
      ],
    );
  }

}
