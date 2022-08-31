import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_closet/utils/DirectoryManager.dart';
import 'package:my_closet/utils/PaletteColori.dart';
import '../models/Outfit.dart';
import '/database/db.dart';
import '/models/Indumento.dart';

class VestitoDetail extends StatefulWidget {
  const VestitoDetail({super.key, required this.vestitoId});
  final int vestitoId;

  @override
  State<VestitoDetail> createState() => _VestitoDetailState();
}

class _VestitoDetailState extends State<VestitoDetail> {

  @override
  void initState() {
    super.initState();
  }

  Future<Indumento> _getIndumento(int id) async {
    var indumento  = await OutfitDatabase.outfitDatabase.getIndumento(id);
    return indumento;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getIndumento(widget.vestitoId),
      builder: (BuildContext context, AsyncSnapshot<Indumento> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = _buildIndumentoWidget(snapshot.data!);
        } else {
          child = const Text("no data");
        }
        return child;
      },

    );

  }

  Widget _buildIndumentoWidget(Indumento indumento) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli'),
        actions: <Widget>[editButton(indumento), deleteButton(indumento)],
      ),
      body: Column(
        children: [
              Row(
                children: [
                  Expanded(child: Image.file(File(indumento.imgPath), height: 250, fit: BoxFit.contain)),
                ],
              ),
              const Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(indumento.tipoAbbigliamento.toLowerCase(), style: const TextStyle(color: Colors.grey)),
                        Text(indumento.nomeBrand)
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Prezzo: ',
                          style: const TextStyle(color: Colors.grey),
                          children: [
                          TextSpan(text: '${indumento.prezzo}\$', style: const TextStyle(color: Colors.black))
                          ]
                      ),
                    )
                  ],
                ),
              ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Colore ', style: TextStyle(color: Colors.grey),),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: PaletteColori.colors[indumento.colore],
                              shape: BoxShape.circle
                            ),
                          ),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: RichText(
                            text: TextSpan(
                                text: 'Taglia: ',
                                style: const TextStyle(color: Colors.grey),
                                children: [
                                  TextSpan(text: indumento.taglia, style: const TextStyle(color: Colors.black))
                                ]
                            )
                        ),
                      )
                    ],
                  ),
                ),

              ],
            )
        ],
      ),
    );
  }

  Widget editButton(Indumento indumento) => IconButton(
      onPressed: () async {
        await Navigator.of(context).pushNamed('/form', arguments: indumento);
        setState(() {});
      },
      icon: const Icon(Icons.edit)
  );

  /// quando l'utente elimina un vestito che è presente in uno o più
  /// outfit, vado a eliminare anche gli outfit per evitare problemi path delle immagini
  Widget deleteButton(Indumento indumento) => IconButton(
      onPressed: () => _delete(context, indumento),
      icon: const Icon(Icons.delete)
  );

  void _delete(BuildContext context, Indumento indumento) async {
    List<Outfit> relatedOutfit = await OutfitDatabase.outfitDatabase.getLinkedOutfit(indumento.imgPath);
    showDialog(
        context: context,
        builder: (BuildContext ctx) {

          return AlertDialog(
            content: relatedOutfit.isEmpty? Text('Sei sicuro di voler rimuovere il vestito ${indumento.nomeBrand}? \n') :
                                            Text('Sei sicuro di voler rimuovere il vestito? \nIl vestito è presente in ${relatedOutfit.length} outfit, questi verranno rimossi, vuoi procedere?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      await _deleteImage(indumento);
                    } catch (e) {
                      throw Exception();
                    }
                    await OutfitDatabase.outfitDatabase.deleteVestito(indumento.id!);
                    if (relatedOutfit.isNotEmpty) {
                      for (Outfit outfit in relatedOutfit) {
                        await OutfitDatabase.outfitDatabase.deleteOutfit(outfit.id!);
                      }
                    }
                    Navigator.of(context).pushReplacementNamed('/', arguments: 1);
                  },
                  child: const Text("SI", style: TextStyle(color: Colors.red))
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("NO")
              )
            ],
          );
        }
    );
  }

  /// Method used to delete the image from fs
  Future<void> _deleteImage(Indumento indumento) async {
    File imgToDelete = File(indumento.imgPath);
    imgToDelete.delete();
  }

}