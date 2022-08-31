import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_closet/database/db.dart';
import 'package:my_closet/models/Outfit.dart';
import 'package:my_closet/utils/StaggeredGridGenerator.dart';

class ImageCarousel extends StatefulWidget {
  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int activePage = 1;
  late Future<List<Outfit>> listaOutfit;
  late int listaLength;

  @override
  void initState() {
    listaOutfit = _fillDailyOutfit();
    super.initState();
  }

  Future<List<Outfit>> _getOutfit() async {
    var listaOutfit = await OutfitDatabase.outfitDatabase.getAllOutfit();
    return listaOutfit;
  }

  // con meno di tre foto non worka bene
  /// Metodo mockup per simulare la funzionalità di consiglio degli outfit
  /// nella teoria dovrebbe usare qualche tecnica di IA
  /// oppure collegarsi a una API del meteo per suggerire gli outfit basandosi sulla stagione
  /// nella pratica sceglie 3 outfit random.
  Future<List<Outfit>> _fillDailyOutfit() async {
    List<Outfit> savedOutfit = await _getOutfit();
    List<Outfit> daily = [];
    if (savedOutfit.length < 3) {
      return daily;
    } else {
      var counter = 0;
      while (counter < 3) {
        int r = Random().nextInt(savedOutfit.length);
        daily.add(savedOutfit[r]);
        savedOutfit.removeAt(r);
        counter++;
      }
      return daily;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildCarousel(),
          _buildIndicators()
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return FutureBuilder(
      future: listaOutfit,
      builder: (BuildContext context, AsyncSnapshot<List<Outfit>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = CarouselSlider(
              items: _buildGrid(snapshot.data!),
              options: CarouselOptions(
                viewportFraction: 0.6,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    activePage = index;
                  });
                }
              ),
          );
        } else {
          child = const Text('no data');
        }
        return child;
      },

    );
  }

  Widget _buildIndicators() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicators(3, activePage)
      ),
    );
  }


  List<Widget> _buildGrid(List<Outfit> outfits) {
    List<Widget> result = [];
    for (var outfit in outfits) {
      result.add(GestureDetector (
        onTap: () => Navigator.of(context).pushNamed('/outfitDetail', arguments: outfit.id),
        child: StaggeredGridGenerator.generateGrid(outfit),
      ));
    }
    return result;
  }



  List<Widget> indicators(imagesLength,currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}