import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_closet/database/db.dart';
import 'package:my_closet/models/Indumento.dart';
import 'package:my_closet/utils/StaggeredGridGenerator.dart';
import 'package:my_closet/widgets/ImageCarousel.dart';

import '../models/Outfit.dart';

class Home extends StatefulWidget {
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Center(child: Text('OUTFIT CONSIGLIATI', style: TextStyle(fontWeight: FontWeight.bold),)),
              ),
              ImageCarousel(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Aggiunti di recente'),
                    RichText(
                      text: TextSpan(
                          text: 'Vedi tutti...',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed('/', arguments: 1);
                            }
                      ),
                    ),
                  ],
                ),
              ),
            FutureBuilder(
              future: get(),
              builder: (BuildContext context, AsyncSnapshot<List<Indumento>> snapshot) {
                Widget child;
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return GridView.count(
                    mainAxisSpacing: 3.5,
                    crossAxisSpacing: 3.5,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: snapshot.data!.map((e) => Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/detail', arguments: e.id);
                        },
                        child: Image.file(
                          File(e.imgPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )).toList(),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  child = const Text('Nessun vestito aggiunto di recente', textAlign: TextAlign.center,);
                } else {
                  child = const Text('no data');
                }
                return child;
              },

            )
          ],
        ),
      );
  }

  Future<List<Indumento>> get() async {
    return await OutfitDatabase.outfitDatabase.getLastThreeVestiti();
  }






}