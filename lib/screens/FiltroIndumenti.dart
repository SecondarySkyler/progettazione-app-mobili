import 'package:flutter/material.dart';
import 'package:my_closet/models/Indumento.dart';
import 'package:my_closet/utils/PaletteColori.dart';
import 'package:my_closet/widgets/CustomColorChip.dart';


class FiltroIndumenti extends StatefulWidget {
  final Function updateFiltro;
  final Map<String, List<String>> selectedFilters;
  const FiltroIndumenti({Key? key, required this.updateFiltro, required this.selectedFilters }) : super(key: key);

  @override
  State<FiltroIndumenti> createState() => _FiltroIndumentiState();
}

class _FiltroIndumentiState extends State<FiltroIndumenti> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filtro vestiti'),
          actions: [
            IconButton(
              onPressed: () {
                widget.updateFiltro(widget.selectedFilters);
                Navigator.of(context).pop();
              },
                icon: const Icon(Icons.check)
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                const SizedBox(height: 10),
                const Text('Colori'),
                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: _colorFilter().toList())),
                const SizedBox(height: 20),
                const Text('Tipo abbigliamento'),
                Center(
                   child: Wrap(
                     spacing: 5.0,
                     alignment: WrapAlignment. center,
                     children: _tipoFilter().toList()
                   ),
                ),
                const SizedBox(height: 20),
                const Text('Taglia'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: _tagliaFilter().toList()),
              ]
          ),
        ),
      ),
    );
  }

  Iterable<Widget> _colorFilter() {
    return PaletteColori.colors.entries.map((entry) {
      bool isCurrentlySelected = widget.selectedFilters['colore'] == null ? false : widget.selectedFilters['colore']!.contains(entry.key);
      return CustomColorChip(chipColor: entry, updateFilter: updateColoreToFilter, isCurrentlySelected: isCurrentlySelected);
    });
  }

  void updateColoreToFilter(String colore, bool toInsert) {
    if (toInsert) {
      if (widget.selectedFilters['colore'] == null) widget.selectedFilters['colore'] = [];
      widget.selectedFilters['colore']!.add(colore);
    } else {
      widget.selectedFilters['colore']!.remove(colore);
      if (widget.selectedFilters['colore']!.isEmpty) widget.selectedFilters.remove('colore');
    }

  }

  Iterable<Widget> _tipoFilter() {
    return Indumento.tipo.map((tipo) {
      return FilterChip(
        label: Text(tipo),
        showCheckmark: false,
        selectedColor: Colors.blue,
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        selected:  widget.selectedFilters['tipo'] == null ? false : widget.selectedFilters['tipo']!.contains(tipo),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              if (widget.selectedFilters['tipo'] == null) {
                widget.selectedFilters['tipo'] = [];
              }
              widget.selectedFilters['tipo']?.add(tipo);
            } else {
              widget.selectedFilters['tipo']?.remove(tipo);
              if (widget.selectedFilters['tipo']!.isEmpty) {
                widget.selectedFilters.remove('tipo');
              }
            }
          });
        }
      );
    });
  }

  Iterable<Widget> _tagliaFilter() {
    return Indumento.taglie.map((taglia) {
      return FilterChip(
        label: Text(taglia),
        showCheckmark: false,
        selectedColor: Colors.blue,
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        shape: const CircleBorder(),
        selected:  widget.selectedFilters['taglia'] == null ? false : widget.selectedFilters['taglia']!.contains(taglia),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              if (widget.selectedFilters['taglia'] == null) {
                widget.selectedFilters['taglia'] = [];
              }
              widget.selectedFilters['taglia']?.add(taglia);
            } else {
              widget.selectedFilters['taglia']?.remove(taglia);
              if (widget.selectedFilters['taglia']!.isEmpty) {
                widget.selectedFilters.remove('taglia');
              }
            }
          });
        }
      );
    });
  }

  Widget _colorFilterOptions() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: PaletteColori.colors.length,
      itemBuilder: (context, index) {
        String key = PaletteColori.colors.keys.elementAt(index);
        return CheckboxListTile(
          title: Row(
            children: [
              Container(decoration: ShapeDecoration(shape: Border.all(color: PaletteColori.colors[key]!, width: 12)),),
              const SizedBox(width: 10),
              Text(key)
            ],
          ),
          value: widget.selectedFilters['colore'] == null ? false : widget.selectedFilters['colore']?.contains(key),
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                if (widget.selectedFilters['colore'] == null) {
                  widget.selectedFilters['colore'] = [];
                }
                widget.selectedFilters['colore']?.add(key);
              } else {
                widget.selectedFilters['colore']?.remove(key);
                if (widget.selectedFilters['colore']!.isEmpty) {
                  widget.selectedFilters.remove('colore');
                }
              }
            });
          }
        );
      }
    );
  }

  Widget _tipoAbbigliamentoFilterOptions() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Indumento.tipo.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(Indumento.tipo[index]),
          value: widget.selectedFilters['tipo'] == null ? false : widget.selectedFilters['tipo']?.contains(Indumento.tipo[index]),
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                if (widget.selectedFilters['tipo'] == null) {
                  widget.selectedFilters['tipo'] = [];
                }
                widget.selectedFilters['tipo']?.add(Indumento.tipo[index]);
              } else {
                widget.selectedFilters['tipo']?.remove(Indumento.tipo[index]);
                if (widget.selectedFilters['tipo']!.isEmpty) {
                  widget.selectedFilters.remove('tipo');
                }
              }
            });
          }
        );
      }
    );
  }
}