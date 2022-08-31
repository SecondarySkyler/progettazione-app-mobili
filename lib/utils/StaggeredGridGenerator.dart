import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_closet/models/Outfit.dart';

class StaggeredGridGenerator {


  static Widget generateGrid(Outfit outfit) {
    int numOfImages = 0;
    Widget grid;
    for (var img in outfit.imgsOutfit) {
      if (img != " ") numOfImages++;
    }

    switch (numOfImages) {
      case 1:
        grid = StaggeredGrid.count(
          crossAxisCount: 1,
          children: [
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[0]))
            )
          ],
        );
        return grid;
      case 2:
        grid = StaggeredGrid.count(
          crossAxisCount: 2,
          children: [
            StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[0]), fit: BoxFit.cover)
            ),
            StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[1]), fit: BoxFit.cover)
            )
          ],
        );
        return grid;
      case 3:
        grid = StaggeredGrid.count(
          crossAxisCount: 2,
          children: [
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[0]), fit: BoxFit.cover,)
            ),
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[1]), fit: BoxFit.cover)
            ),
            StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[2]), fit: BoxFit.cover)
            ),
          ],
        );
        return grid;
      case 4:
        grid = StaggeredGrid.count(
          crossAxisCount: 2,
          children: [
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[0]), fit: BoxFit.cover,)
            ),
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[1]), fit: BoxFit.cover)
            ),
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[2]), fit: BoxFit.cover)
            ),
            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Image.file(File(outfit.imgsOutfit[3]), fit: BoxFit.cover)
            ),
          ],
        );
        return grid;

      default:
        return const Text('non dovrebbe uscire mai');

    }
  }
}