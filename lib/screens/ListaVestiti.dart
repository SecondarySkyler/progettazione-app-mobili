import 'package:flutter/material.dart';
import 'package:my_closet/widgets/ExpandableFloatButton.dart';
import '/database/db.dart';
import '/models/Indumento.dart';
import '/widgets/ListaVestitoItem.dart';
import 'FiltroIndumenti.dart';

/**
 * Lo scopo di questa classe e':
 * - accedere al database e reperire tutti i capi d'abbigliamento dell'utente
 * - mostrarli in una lista
 * - permettere all'utente di filtrare i vestiti in base a determinate caratteristiche
 * - aggiungere nuovi capi d'abbigliamento
 * - rimuoverne
 */

class ListaVestiti extends StatefulWidget {

  @override
  State<ListaVestiti> createState() => _ListaVestitiState();
}

class _ListaVestitiState extends State<ListaVestiti> {
  late List<Indumento> vestiti;
  Map<String, List<String>> filters = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadVestiti();
  }

  @override
  void dispose() {
    OutfitDatabase.outfitDatabase.close();
    super.dispose();
  }

  Future loadVestiti() async {
    setState(() => isLoading = true);
    vestiti = await OutfitDatabase.outfitDatabase.getAllVestiti();
    setState(() => isLoading = false);
  }

  void _updateFiltersMap(Map<String, List<String>> f) {
    setState(() {
      filters = f;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _vestitiAppBar(),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : vestiti.isEmpty
            ? const Text("Non ci sono vestiti, clicca sull'icona + \n per aggiungerne di nuovi", textAlign: TextAlign.center,)
            : filters.isEmpty
            ? ListaVestitoItem(listaVestiti: vestiti, refreshList: loadVestiti)
            : ListaVestitoItem(listaVestiti: _applyFilter(), refreshList: loadVestiti),
      ),
      floatingActionButton: ExpandableFloatButton(),
    );
  }

  PreferredSizeWidget _vestitiAppBar() {
    return AppBar(
      title: const Text('Vestiti'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FiltroIndumenti(updateFiltro: _updateFiltersMap, selectedFilters: filters))
              );
            },
            icon: const Icon(Icons.filter_alt_rounded)
        )
      ],
    );
  }

  List<Indumento> _applyFilter() {
    List<Indumento> copy = [];
    var keys = filters.keys;
    for (var vestito in vestiti) {
      bool isCorrect = false;
      var mappedVestito = vestito.toJson();
      for (var key in keys) {
        if (filters[key]!.contains(mappedVestito[key])) {
          isCorrect = true;
        } else {
          isCorrect = false;
        }
      }
      if (isCorrect) copy.add(vestito);
    }

    return copy;
  }

}