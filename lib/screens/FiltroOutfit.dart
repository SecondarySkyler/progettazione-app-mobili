import 'package:flutter/material.dart';

import '../models/Outfit.dart';

class FiltroOutfit extends StatefulWidget {
  final Function updateFiltro;
  final Map<String, List<String>> selectedFilters;

  const FiltroOutfit({Key? key, required this.updateFiltro, required this.selectedFilters}) : super(key: key);
  
  @override
  State<FiltroOutfit> createState() => _FiltroOutfitState();
}

class _FiltroOutfitState extends State<FiltroOutfit> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtro outfit'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              widget.updateFiltro(widget.selectedFilters);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check)
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text('Tipo outfit'),
            ),
            Center(
              child: Wrap(
                spacing: 5.0,
                alignment: WrapAlignment.center,
                children: _tipoFilter().toList()
              ),
            ),
            const SizedBox(height: 20),
            const Text('Stagione'),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _stagioneFilter().toList()),
            )
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _tipoFilter() {
    return Outfit.tipo.map((tipo) {
      return FilterChip(
          label: Text(tipo),
          showCheckmark: false,
          selectedColor: Colors.blue,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.grey),
          selected: widget.selectedFilters['tipoOutfit'] == null ? false : widget.selectedFilters['tipoOutfit']!.contains(tipo),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (widget.selectedFilters['tipoOutfit'] == null) {
                  widget.selectedFilters['tipoOutfit'] = [];
                }
                widget.selectedFilters['tipoOutfit']?.add(tipo);
              } else {
                widget.selectedFilters['tipoOutfit']?.remove(tipo);
                if (widget.selectedFilters['tipoOutfit']!.isEmpty) {
                  widget.selectedFilters.remove('tipoOutfit');
                }
              }
            });
          }
      );
    });
  }

  Iterable<Widget> _stagioneFilter() {
    return Outfit.stagioni.map((stagione) {
      return FilterChip(
        label: Text(stagione),
        showCheckmark: false,
        selectedColor: Colors.blue,
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        selected: widget.selectedFilters['stagioneOutfit'] == null ? false : widget.selectedFilters['stagioneOutfit']!.contains(stagione),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              if (widget.selectedFilters['stagioneOutfit'] == null) {
                widget.selectedFilters['stagioneOutfit'] = [];
              }
              widget.selectedFilters['stagioneOutfit']?.add(stagione);
            } else {
              widget.selectedFilters['stagioneOutfit']?.remove(stagione);
              if (widget.selectedFilters['stagioneOutfit']!.isEmpty) {
                widget.selectedFilters.remove('stagioneOutfit');
              }
            }
          });
        }
      );
    });
  }
}