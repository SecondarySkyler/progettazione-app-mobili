import 'package:flutter/material.dart';
import 'package:my_closet/database/db.dart';
import 'package:my_closet/utils/PaletteColori.dart';

class UsedColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colori usati'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Colore'),
                  Text('Numero capi'),
                ],
              ),
            ),
            const Divider(color: Colors.grey,),
            _buildColorList()
          ],
        ),
      ),
    );
  }

  Future<Map<String, double>> _getNumColor() async {
    var res = await OutfitDatabase.outfitDatabase.getCountColori();

    for (var key in PaletteColori.colors.keys) {
      if (!res.keys.contains(key)) {
        res[key] = 0;
      }
    }

    var sortedKeys = res.keys.toList(growable: false)..sort(
            (k1, k2) => res[k2]!.compareTo(res[k1]!)
    );

    Map<String, double> sorted = { for (var k in sortedKeys) k : res[k]! };
    return sorted;

  }

  Widget _buildColorList() {
    return FutureBuilder(
      future: _getNumColor(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, double>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              String key = snapshot.data!.keys.elementAt(index);
              return ListTile(
                minLeadingWidth: 5,
                leading: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: PaletteColori.colors[key],
                      shape: BoxShape.circle
                  ),
                ),
                title: Text(key),
                trailing: Text(snapshot.data![key]!.toStringAsFixed(0)),
              );
            },
          );
        } else {
          child = const Text('no data');
        }
        return child;
      },

    );
  }

  // Widget _buildColorList() {
  //   return FutureBuilder(
  //     future: _getNumColor(),
  //     builder: (BuildContext context, AsyncSnapshot<Map<String, double>> snapshot) {
  //       Widget child;
  //       if (snapshot.hasData) {
  //         child = ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: PaletteColori.colors.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             // per ogni chiave della palette colori
  //             String key = PaletteColori.colors.keys.elementAt(index);
  //             /*
  //               controllo se lo snapshot contiene quel colore
  //               se true: il colore è usato, allora ci sono dei capi di quel colore
  //               se false: il colore non è usato allora ci sarà un list tile con valore 0
  //              */
  //             PaletteColori.colors.keys.contains(key) ?
  //             ListTile(
  //               minLeadingWidth: 5,
  //               leading: Container(
  //                 width: 25,
  //                 height: 25,
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.black),
  //                     color: PaletteColori.colors[key],
  //                     shape: BoxShape.circle
  //                 ),
  //               ),
  //               title: Text(key),
  //               trailing: Text(snapshot.data![key]!.toStringAsFixed(0)),
  //             )
  //             :
  //             ListTile();
  //           },
  //         );
  //       } else {
  //         child = const Text('no data');
  //       }
  //       return child;
  //     },
  //
  //   );
  // }
  
}