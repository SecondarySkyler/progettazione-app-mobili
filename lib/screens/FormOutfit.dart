import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_closet/database/db.dart';
import 'package:my_closet/models/Outfit.dart';
import 'package:my_closet/utils/DirectoryManager.dart';
import 'package:my_closet/utils/StaggeredGridGenerator.dart';

import '../widgets/ListaImmaginiVestiti.dart';

class FormOutfit extends StatefulWidget {
  final Outfit? outfitToUpdate;

  const FormOutfit({Key? key, this.outfitToUpdate}) : super(key: key);


  @override
  State<FormOutfit> createState() => _FormOutfitState();
}

class _FormOutfitState extends State<FormOutfit> {
  List<String> pathImmagini = [];
  List<String> selectedItems = [];
  bool isLoading = false;

  late String tipo;
  late String stagione;

  @override
  void initState() {
    super.initState();
    tipo = widget.outfitToUpdate?.tipoOutfit ?? Outfit.tipo[0];
    stagione = widget.outfitToUpdate?.stagioneOutfit ?? Outfit.stagioni[0];
    _loadPathImmagini();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _loadPathImmagini() async {
    setState(() => isLoading = true);
    String p = await _getImagesPath();
    await _fillList(Directory(p));
    setState(() => isLoading = false);
  }

  Future<void> _fillList (Directory dir) async {
    await for (var file in
    dir.list(recursive: true, followLinks: false)) {
      pathImmagini.add(file.path);
    }
  }

  Future<String> _getImagesPath() async {
    String p = await DirectoryManager.imagesDirectory;
    return p;
  }


  void addItemToCurrentOutfit(List<String> pathImgSelectedItem) {
    setState(() {
      selectedItems = pathImgSelectedItem;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.outfitToUpdate != null ? const Text('Modifica outfit') : const Text('Nuovo outfit'),
        actions: [_submitButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            photoSelector(),
            Form(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tipo outfit'
                      ),
                        value: widget.outfitToUpdate != null ? widget.outfitToUpdate!.tipoOutfit : null,
                      items: Outfit.tipo.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e)
                      )).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          tipo = newValue!;
                        });
                      }
                    ),
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            labelText: 'Stagione'
                        ),
                        value: widget.outfitToUpdate != null ? widget.outfitToUpdate!.stagioneOutfit : null,
                        items: Outfit.stagioni.map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e)
                        )).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            stagione = newValue!;
                          });
                        }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget photoSelector() {
    return widget.outfitToUpdate != null
    ? StaggeredGridGenerator.generateGrid(widget.outfitToUpdate!)
    : selectedItems.isEmpty
    ? _placeHolderSelector()
    : _selectedImages();
  }

  Widget _placeHolderSelector() {
    return GestureDetector(
      child: Container(
        height: 200,
        color: Colors.grey,
        child: const Center(
            child: Text("Clicca per selezionare gli indumenti \n con cui creare l'outfit", textAlign: TextAlign.center,)
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ListaImmaginiVestiti(listaPathImmagini: pathImmagini, updateListOfSelectedItems: addItemToCurrentOutfit, pathOfSelectedItems: selectedItems,))
        );
      },
    );
  }

  Widget _selectedImages() {
    return StaggeredGrid.count(
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      crossAxisCount: 2,
      children: selectedItems.map((path) => Image.file(
        File(path),
        height: 150,
        fit: BoxFit.cover,
      )).toList(),
    );
  }

  Widget _submitButton() {
    return IconButton(
        onPressed: () async {
          addOrUpdateOutfit();
        },
        icon: const Icon(Icons.check)
    );
  }


  void addOrUpdateOutfit() async {
    final isUpdating = widget.outfitToUpdate != null;

    if (isUpdating) {
      await updateOutfit();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Outfit aggiornato')
          )
      );
      Navigator.of(context).pop();
    } else {
      await addOutfit();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Outfit salvato')
          )
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments: 2);
    }
  }

  Future updateOutfit() async {
    final updatedOutfit = widget.outfitToUpdate!.copy(
      tipoOutfit: tipo,
      stagioneOutfit: stagione
    );

    await OutfitDatabase.outfitDatabase.updateOutfit(updatedOutfit);
  }

  Future addOutfit() async {
    Outfit newOutfit = Outfit(
        tipoOutfit: tipo,
        stagioneOutfit: stagione,
        imgsOutfit: selectedItems
    );

    await OutfitDatabase.outfitDatabase.insertOutfit(newOutfit);
  }

}