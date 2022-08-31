import 'package:flutter/material.dart';
import 'package:my_closet/utils/StaggeredGridGenerator.dart';
import '../models/Outfit.dart';

class ListaOutfitItem extends StatelessWidget {
  final List<Outfit> listaOutfit;
  const ListaOutfitItem({Key? key, required this.listaOutfit}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: listaOutfit.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: StaggeredGridGenerator.generateGrid(listaOutfit[index]),
            onTap: () {
              Navigator.of(context).pushNamed('/outfitDetail', arguments: listaOutfit[index].id);
            },
          );
        }
    );
  }

}