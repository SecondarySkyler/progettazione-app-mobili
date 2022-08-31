import 'dart:io';

import 'package:flutter/material.dart';
import '../models/Indumento.dart';
import '../screens/VestitoDetail.dart';

class ListaVestitoItem extends StatelessWidget {
  final List<Indumento> listaVestiti;
  final Function refreshList;
  const ListaVestitoItem({Key? key, required this.listaVestiti, required this.refreshList}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5
        ),
        itemCount: listaVestiti.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              child: Image.file(File(listaVestiti[index].imgPath), fit: BoxFit.cover,),
            ),
            onTap: () async {
              await Navigator.of(context).pushNamed('/detail', arguments: listaVestiti[index].id);
              refreshList();
            },
          );
        }
    );
  }

}