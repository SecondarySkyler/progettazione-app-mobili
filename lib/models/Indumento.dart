import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Indumento {

  static final List<String> tipo = ['T-shirt', 'Pantalone', 'Gonna', 'Camicia', 'Maglione', 'Scarpe', 'Intimo'];
  static final List<String> taglie = ['XS', 'S', 'M', 'L', 'XL'];
  static final List<String> numeroScarpa = ['36', '36.5', '37', '37.5', '38', '38.5', '39', '39.5', '40', '40.5', '41', '41.5', '42', '42.5',];

  final int? id;
  final String nomeBrand;
  final String prezzo;
  final String colore;
  final String tipoAbbigliamento;
  final String taglia;
  final String imgPath;

  const Indumento({
    this.id,
    required this.nomeBrand,
    required this.prezzo,
    required this.colore,
    required this.tipoAbbigliamento,
    required this.taglia,
    required this.imgPath
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'brand': nomeBrand,
    'prezzo' : prezzo,
    'colore' : colore,
    'tipo': tipoAbbigliamento,
    'taglia': taglia,
    'immagine': imgPath
  };

  static Indumento fromJson(Map<String, Object?> json) => Indumento(
      id: json['id'] as int?,
      nomeBrand: json['brand'] as String,
      prezzo: json['prezzo'] as String,
      colore: json['colore'] as String,
      tipoAbbigliamento: json['tipo'] as String,
      taglia: json['taglia'] as String,
      imgPath: json['immagine'] as String
  );

  Indumento copy({
    int? id,
    String? nomeBrand,
    String? prezzo,
    String? colore,
    String? tipoAbbigliamento,
    String? taglia,
    String? imgPath
  }) => Indumento(
      id: id ?? this.id,
      nomeBrand: nomeBrand ?? this.nomeBrand,
      prezzo: prezzo ?? this.prezzo,
      colore: colore ?? this.colore,
      tipoAbbigliamento: tipoAbbigliamento ?? this.tipoAbbigliamento,
      taglia: taglia ?? this.taglia,
      imgPath: imgPath ?? this.imgPath
  );


  @override
  String toString() {
    return nomeBrand +
        prezzo.toString() +
        colore +
        tipoAbbigliamento +
        taglia +
        imgPath;
  }

}