import 'package:flutter/material.dart';

class CustomColorChip extends StatefulWidget {
  final MapEntry<String, Color> chipColor;
  final Function updateFilter;
  bool isCurrentlySelected;
  CustomColorChip({Key? key, required this.chipColor, required this.updateFilter, required this.isCurrentlySelected}) : super(key: key);


  @override
  State<CustomColorChip> createState() => _CustomColorChipState();
}

class _CustomColorChipState extends State<CustomColorChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: widget.isCurrentlySelected ?
        widget.chipColor.key == 'Nero' ?
            const Icon(Icons.check, color: Colors.white,) :
            const Icon(Icons.check) : Icon(Icons.check, color: widget.chipColor.value,),
      showCheckmark: false,
      selected: widget.isCurrentlySelected,
      backgroundColor: widget.chipColor.value,
      side: const BorderSide(color: Colors.grey),
      shape: const CircleBorder(),
      selectedColor: widget.chipColor.value,
      onSelected: (bool value) {
        setState(() {
          if (value) {
            widget.isCurrentlySelected = true;
          } else {
            widget.isCurrentlySelected = false;
          }
          widget.updateFilter(widget.chipColor.key, value);
        });
      }
    );
  }
}