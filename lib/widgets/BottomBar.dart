import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_closet/utils/OutfitIcon.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> updateIndex;

  BottomBar({required this.currentIndex, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => updateIndex(index),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.shirt),
              label: "Vestiti"
          ),
          BottomNavigationBarItem(
              icon: Icon(OutfitIcon.outfit),
              label: "Outfit"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profilo"
          )
        ]
    );
  }


}