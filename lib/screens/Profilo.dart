import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_closet/database/db.dart';
import 'package:my_closet/screens/stats/UsedColor.dart';
import 'package:my_closet/utils/PaletteColori.dart';
import 'package:pie_chart/pie_chart.dart';

class Profilo extends StatefulWidget {


  @override
  State<Profilo> createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            const Center(child: Text('Statistiche armadio', style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 7),
            _rowStats(),
            const Divider(color: Colors.grey),
            // il rendering del grafico si bugga passando da vestiti - profilo e da outfit - profilo
            // funziona invece da home - profilo
            _color(),
            const Divider(color: Colors.grey),
            _otherFeatures(context)
          ],
        ),
      ),
    );
  }

  Widget _rowStats() {
    return FutureBuilder(
      future: _getArmadioStats(),
      builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        const Text('Numero vestiti'),
                        Text(snapshot.data![0].toStringAsFixed(0))
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(width: 1, color: Colors.grey),
                            right: BorderSide(width: 1, color: Colors.grey)
                        )
                    ),
                    child: Column(
                      children: [
                        const Text('Numero outfit'),
                        Text(snapshot.data![1].toStringAsFixed(0))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        const Text('Costo totale'),
                        Text(snapshot.data![2].toStringAsFixed(2))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          child = const Text('Il tuo armadio è vuoto');
        }
        return child;
      },

    );
  }

  Future<List<double>> _getArmadioStats() async {
    List<double> result = [];
    var numVestiti = await OutfitDatabase.outfitDatabase.getNumeroVestiti();
    var numOutfit = await OutfitDatabase.outfitDatabase.getNumeroOutfit();
    var costo = await OutfitDatabase.outfitDatabase.getPrezzoVestiti();
    result.add(numVestiti.toDouble());
    result.add(numOutfit.toDouble());
    result.add(costo);
    return result;
  }

  Widget _color() {
    return FutureBuilder(
      future: _numColor(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, double>> snapshot) {
        Widget child;
        /*
         nel caso in cui l'app non abbia dati, la future ritorna una mappa vuota
         perciò hasData è true ma l'asserzione isEmpty su dataMap solleva eccezione
         quindi nell'if controllo se la mappa ha dei dati
         */

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          child = Column(
            children: [
              const Text('Colori più usati', style: TextStyle(fontWeight: FontWeight.bold),),
              PieChart(
                dataMap: snapshot.data!,
                colorList: _mapColor(snapshot.data!.keys),
                legendOptions: const LegendOptions(
                  legendPosition: LegendPosition.left,
                  legendTextStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)
                ),
                chartValuesOptions: const ChartValuesOptions(decimalPlaces: 0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Vedi tutti...',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => UsedColor())
                            );
                          }
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          child = const Text('Aggiungi vestiti per visionare le statistiche \n relative ai colori', textAlign: TextAlign.center,);
        } else {
          child = const Text('bug del grafico \n Home -> Profilo funziona \n Vestiti/Outfit -> Profilo no');
        }
       return child;
      },

    );
  }

  Future<Map<String, double>> _numColor() async {
    var res = await OutfitDatabase.outfitDatabase.getCountColori();
    // in base ai value faccio il sort delle chiavi
    var sortedKeys = res.keys.toList(growable: false)..sort(
            (k1, k2) => res[k2]!.compareTo(res[k1]!)
    );
    // se ci sono al massimo 5 colori usati, ritorno la mappa ordinata in maniera decrescente
    if (res.length <= 5) {
      Map<String, double> sorted = { for (var k in sortedKeys) k : res[k]! };
      return sorted;
    } else {
      // altrimenti se ci sono piu' di 5 colori usati, recupero i primi 5
      var sorted = { for (var k in sortedKeys) k : res[k] };
      int counter = 0;
      Map<String, double> result = {};
      for (var k in sorted.entries) {
        if (counter != 5) {
          result[k.key] = k.value!;
          counter++;
        } else {
          break;
        }
      }
      return result;
    }
  }

  List<Color> _mapColor(Iterable<String> keys) {
    List<Color> colorList = [];
    for (var color in keys) {
      colorList.add(PaletteColori.colors[color]!);
    }
    return colorList;
  }

  Widget _otherFeatures(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: ListTile(
            leading: Icon(Icons.edit),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            title: Text('Personalizza'),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey
              )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: ListTile(
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            title: Text('Impostazioni'),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey)
            ),
          ),
        )
      ],
    );
  }
}