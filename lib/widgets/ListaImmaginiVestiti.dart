import 'dart:io';

import 'package:flutter/material.dart';

class ListaImmaginiVestiti extends StatefulWidget {
  final List<String> listaPathImmagini;
  final Function updateListOfSelectedItems;
  final List<String> pathOfSelectedItems;
  const ListaImmaginiVestiti({Key? key, required this.listaPathImmagini, required this.updateListOfSelectedItems, required this.pathOfSelectedItems}) : super(key: key);

  @override
  State<ListaImmaginiVestiti> createState() => _ListaImmaginiVestitiState();
}

class _ListaImmaginiVestitiState extends State<ListaImmaginiVestiti> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pathOfSelectedItems.length} selezionati'),
        actions: [
          IconButton(
            onPressed: () {
              widget.updateListOfSelectedItems(widget.pathOfSelectedItems);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check)
          )
        ],
      ),
      body: _buildGrid(),
    );

  }

  Widget _buildGrid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
            crossAxisCount: 3
        ),
        itemCount: widget.listaPathImmagini.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (widget.pathOfSelectedItems.length == 4) {
                // se la lista è piena ma l'utente clicca su un item selezionato, lo rimuovo
                if (widget.pathOfSelectedItems.contains(widget.listaPathImmagini[index])) {
                  setState(() {
                    widget.pathOfSelectedItems.remove(widget.listaPathImmagini[index]);
                  });

                } else {
                  // altrimenti gli dico errore
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                          'Non puoi selezionare più di 4 elementi'))
                  );
                }
              } else {
                setState(() {
                      // se la lista dei selezionati contiene gia' l'elemento, allora lo rimuovo
                      if (widget.pathOfSelectedItems.contains(widget.listaPathImmagini[index])) {
                        widget.pathOfSelectedItems.remove(widget.listaPathImmagini[index]);
                      } else {
                        // se la lista dei selezionati NON contiene l'elemento, allora lo aggiungo
                        widget.pathOfSelectedItems.add(widget.listaPathImmagini[index]);
                      }
                    });
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(widget.listaPathImmagini[index]),
                  fit: BoxFit.cover,
                ),
                if (widget.pathOfSelectedItems.contains(widget.listaPathImmagini[index])) const Icon(Icons.check, color: Colors.white,)
              ],
            ),
          );
        }
    );
  }
}