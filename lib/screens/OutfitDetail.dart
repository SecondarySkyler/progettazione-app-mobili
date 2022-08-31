import 'package:flutter/material.dart';
import 'package:my_closet/database/db.dart';
import 'package:my_closet/utils/StaggeredGridGenerator.dart';
import '../models/Indumento.dart';
import '../models/Outfit.dart';


class OutfitDetail extends StatefulWidget {
  final int outfitId;
  const OutfitDetail({Key? key, required this.outfitId}) : super(key: key);
  
  @override
  State<OutfitDetail> createState() => _OutfitDetailState();
}

class _OutfitDetailState extends State<OutfitDetail> {
  late Future<Outfit> outfit;

  @override
  void initState() {
    outfit = _getOutfit(widget.outfitId);
    super.initState();
  }
  
  Future<Outfit> _getOutfit(int id) async {
    var outfit = await OutfitDatabase.outfitDatabase.getOutfit(id);
    return outfit;
  }

  Future<List<Indumento>> _getLinkedIndumenti(int id) async {
    var currentOutfit = await _getOutfit(id);
    List<Indumento> relatedIndumenti = await OutfitDatabase.outfitDatabase.getRelatedIndumenti(currentOutfit.imgsOutfit);
    return relatedIndumenti;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getOutfit(widget.outfitId),
      builder: (BuildContext context, AsyncSnapshot<Outfit> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = _buildDetail(snapshot.data!);
        } else {
          child = const Text('no data');
        }
        return child;
      },

    );
  }

  Widget _buildDetail(Outfit outfit) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli outfit'),
        actions: [editButton(outfit), deleteButton(outfit)],
      ),
      body: Column(
        children: [
          StaggeredGridGenerator.generateGrid(outfit),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Tipo outfit', style: TextStyle(color: Colors.grey)),
                    Text(outfit.tipoOutfit)
                  ],
                ),
                Column(
                  children: [
                    const Text('Stagione outfit', style: TextStyle(color: Colors.grey)),
                    Text(outfit.stagioneOutfit)
                  ],
                )
              ],
            ),
          ),
          // qua dovrebbe essere inserito il metodo per creare il widget degli indumenti correlati
        ],
      ),
    );
  }
  

  Widget editButton(Outfit outfit) {
    return IconButton(
      onPressed: () async {
        await Navigator.of(context).pushNamed('/formOutfit', arguments: outfit);
        setState(() {});
      },
      icon: const Icon(Icons.edit)
    );
  }

  Widget deleteButton(Outfit outfit) {
    return IconButton(
        onPressed: () => _deleteOutfit(context, outfit),
        icon: const Icon(Icons.delete)
    );
  }

  void _deleteOutfit(BuildContext context, Outfit outfit) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: const Text("Sei sicuro di voler rimuovere l'outfit?"),
          actions: [
            TextButton(
              onPressed: () async {
                await OutfitDatabase.outfitDatabase.deleteOutfit(outfit.id!);
                Navigator.of(context).pushNamed('/', arguments: 2);
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

}