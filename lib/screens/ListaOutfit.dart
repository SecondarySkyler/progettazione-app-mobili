import 'package:flutter/material.dart';
import 'package:my_closet/screens/FiltroOutfit.dart';
import 'package:my_closet/widgets/ListaOutfitItem.dart';

import '../database/db.dart';
import '../models/Outfit.dart';

class ListaOutfit extends StatefulWidget {
  @override
  State<ListaOutfit> createState() => _ListaOutfitState();
}

class _ListaOutfitState extends State<ListaOutfit> {
  late List<Outfit> outfit;
  Map<String, List<String>> filters = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadOutfit();
  }

  @override
  void dispose() {
    OutfitDatabase.outfitDatabase.close();
    super.dispose();
  }

  Future loadOutfit() async {
    setState(() => isLoading = true);
    outfit = await OutfitDatabase.outfitDatabase.getAllOutfit();
    setState(() => isLoading = false);
  }

  void _updateFilter(Map<String, List<String>> newFilter) {
    setState(() {
      filters = newFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _outfitAppBar(),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : outfit.isEmpty
            ? const Text('Non ci sono outfit :(')
            : filters.isEmpty
            ? ListaOutfitItem(listaOutfit: outfit)
            : ListaOutfitItem(listaOutfit: _applyFilter()),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/formOutfit');
        },

      ),
    );
  }

  PreferredSizeWidget _outfitAppBar() {
    return AppBar(
      title: const Text('Outfit'),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FiltroOutfit(updateFiltro: _updateFilter, selectedFilters: filters,))
              );
            },
            icon: const Icon(Icons.filter_alt_rounded)
        )
      ],
    );
  }

  List<Outfit> _applyFilter() {
    List<Outfit> filteredOutfits = [];
    var keys = filters.keys;
    for (Outfit outfit in outfit) {
      bool isCorrect = false;
      var mappedOutfit = outfit.toJson();
      for (var key in keys) {
        if (filters[key]!.contains(mappedOutfit[key])) {
          isCorrect = true;
        }
      }
      if (isCorrect) filteredOutfits.add(outfit);
    }
    return filteredOutfits;
  }


}