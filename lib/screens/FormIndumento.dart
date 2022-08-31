import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:my_closet/utils/DirectoryManager.dart';
import 'package:my_closet/utils/PaletteColori.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import '/database/db.dart';
import '/models/Indumento.dart';

class FormIndumento extends StatefulWidget {
  final Indumento? vestito;
  final XFile? img;
  const FormIndumento({Key? key, this.vestito, this.img}) : super(key: key);


  @override
  State<FormIndumento> createState() => _FormIndumentoState();
}

class _FormIndumentoState extends State<FormIndumento> {

  final _formKey = GlobalKey<FormState>();

  late String nomeBrand;
  late String prezzo;
  late String colore;
  late String tipo;
  late String tagliaVestito;
  late String numeroScarpe;
  late String immagineVestito;
  
  
  void _changeSelectedColor(String newColor) {
    setState(() {
      colore = newColor;
    });
  }

  @override
  void initState() {
    super.initState();

    nomeBrand = widget.vestito?.nomeBrand ?? '';
    prezzo = widget.vestito?.prezzo ?? '';
    colore = widget.vestito?.colore ?? PaletteColori.colors.keys.first;
    tipo = widget.vestito?.tipoAbbigliamento ?? Indumento.tipo[0];
    tagliaVestito = widget.vestito?.taglia ?? Indumento.taglie[0];
    numeroScarpe = widget.vestito?.taglia ?? Indumento.numeroScarpa[0];
    if (widget.img != null) {
      immagineVestito = (widget.img!.path);
    } else {
      immagineVestito = widget.vestito?.imgPath ?? '';
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: widget.vestito != null ? const Text('Modifica vestito') : const Text("Nuovo vestito"),
          actions: [_submitButton()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.file(File(immagineVestito), width: 250, height: 250, fit: BoxFit.cover),
              Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: <Widget>[
                        // BRAND
                        TextFormField(
                          initialValue: nomeBrand,
                          decoration: const InputDecoration(
                            labelText: 'Nome Brand'
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please insert some text';
                            }
                            return null;
                          },
                          onChanged: (newBrand) {
                            setState(() {
                              nomeBrand = newBrand;
                            });
                          },
                        ),
                        // PREZZO
                        TextFormField(
                          initialValue: prezzo,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Prezzo'
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please insert some text';
                            }
                            return null;
                          },
                          onChanged: (newPrezzo) {
                            setState(() {
                              prezzo = newPrezzo;
                            });
                          },
                        ),
                        // COLORE
                        DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Colore'
                            ),
                            value: colore,
                            items: PaletteColori.colors.entries.map((e) => DropdownMenuItem(
                                value: e.key,
                                child: Row(
                                  children: [
                                    Text(e.key),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black26),
                                          color: e.value,
                                          shape: BoxShape.circle
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )).toList(),
                            onChanged: (String? newColore) {
                              setState(() {
                                colore = newColore!;
                              });
                            }
                        ),
                        const SizedBox(height: 10),
                        // TIPO ABBIGLIAMENTO
                        DropdownButtonFormField <String>(
                            decoration: const InputDecoration(
                                labelText: "Tipo abbigliamento"
                            ),
                            value: tipo,
                            items: Indumento.tipo.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e)
                            )).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                tipo = newValue!;
                              });
                            }
                        ),
                        const SizedBox(height: 10), // create a gap between fields
                        // TAGLIA
                        tipo != 'Scarpe'
                        ? DropdownButtonFormField<String>(
                          hint: const Text('Seleziona una taglia'),
                          decoration: const InputDecoration(
                              labelText: "Taglia"
                          ),
                          value: tagliaVestito,
                          items: Indumento.taglie.map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e)
                          )).toList(),
                          onChanged: (item) => setState(() => tagliaVestito = item!),
                        )
                        : DropdownButtonFormField<String>(
                          hint: const Text('Seleziona una taglia'),
                          decoration: const InputDecoration(
                            labelText: 'Taglia'
                          ),
                          value: numeroScarpe,
                          items: Indumento.numeroScarpa.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                          )).toList(),
                          onChanged: (item) => setState(() => numeroScarpe = item!),
                          ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _submitButton() {
    return IconButton(onPressed: addOrUpdateIndumento, icon: const Icon(Icons.check));
  }


  void addOrUpdateIndumento() async {
    final isUpdating = widget.vestito != null;

    if (isUpdating) {
      await updateIndumento();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
              content: Text('Indumento aggiornato')
          )
      );
      Navigator.of(context).pop();
    } else {
      await addIndumento();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Indumento salvato!')
          )
      );
      // ritorna al main cosi da renderizzare anche la bottombar
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments: 1);
    }
  }

  Future updateIndumento() async {
    // non considero la possibilita' di aggiornare l'immagine
    // ancora da capire
    final updatedIndumento = widget.vestito!.copy(
        nomeBrand: nomeBrand,
        prezzo: prezzo,
        colore: colore,
        tipoAbbigliamento: tipo,
        taglia: tagliaVestito
    );

    await OutfitDatabase.outfitDatabase.updateVestito(updatedIndumento);
  }

  Future addIndumento() async {
    final fullImagesDirPath = await DirectoryManager.imagesDirectory;
    final newDir = await Directory(fullImagesDirPath).create();

    File imgToSave = File(immagineVestito);
    // imgName e' solo il nome finale, escludo il path
    String imgName = imgToSave.path.split('/').last;
    await imgToSave.copy('${newDir.path}/$imgName');

    Indumento newIndumento = Indumento(
        nomeBrand: nomeBrand,
        prezzo: prezzo,
        colore: colore,
        tipoAbbigliamento: tipo,
        taglia: tipo != 'Scarpe' ? tagliaVestito : numeroScarpe,
        imgPath: '${newDir.path}/$imgName'
    );

    await OutfitDatabase.outfitDatabase.insertIndumento(newIndumento);
  }

}