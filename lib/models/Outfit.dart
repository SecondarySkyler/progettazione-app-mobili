class Outfit {

  static final List<String> tipo = ['Casual', 'Elegante', 'Sportivo', 'Vintage', 'Streetwear'];
  static final List<String> stagioni = ['Primavera', 'Estate', 'Autunno', 'Inverno'];

  final int? id;
  final String tipoOutfit;
  final String stagioneOutfit;
  final List<String> imgsOutfit;

  const Outfit({
    this.id,
    required this.tipoOutfit,
    required this.stagioneOutfit,
    required this.imgsOutfit
  });

  Map<String, Object?> toJson() {
    _listFiller();
    Map<String, Object?> map = {};
    map['id'] = id;
    map['tipoOutfit'] = tipoOutfit;
    map['stagioneOutfit'] = stagioneOutfit;
    int counter = 1;
    imgsOutfit.forEach((image) {
      map['image$counter'] = image;
      counter++;
    });
    return map;
  }

  static Outfit fromJson(Map<String, Object?> json) {
    int? id = json['id'] as int;
    String tipoOutfit = json['tipoOutfit'] as String;
    String stagioneOutfit = json['stagioneOutfit'] as String;
    List<String> imagesPath = [];
    const String baseName = 'image';
    for (var i = 1; i <= 4; i++) {
      imagesPath.add(json['$baseName$i'] as String);
    }
    return Outfit(id: id, tipoOutfit: tipoOutfit, stagioneOutfit: stagioneOutfit, imgsOutfit: imagesPath);
  }

  /// Dato che uso un database SQL dove i record hanno un numero fissato di colonne
  /// Assumo che un outfit può avere al massimo 4 indumenti (da me rappresentati come path di immagini)
  /// Uso questo metodo per riempire di stringhe vuote la lista, nel caso in cui l'utente inserisca meno di
  /// 4 immagini
  void _listFiller() {
    int length = imgsOutfit.length;
    if (length == 4) return;
    int numberOfFiller = 4 - length;
    for (var i = 0; i < numberOfFiller; i++) {
      imgsOutfit.add(' ');
    }
  }

  Outfit copy({
    int? id,
    String? tipoOutfit,
    String? stagioneOutfit,
    List<String>? imgsOutfit
  }) => Outfit(
    id: id ?? this.id,
    tipoOutfit: tipoOutfit ?? this.tipoOutfit,
    stagioneOutfit: stagioneOutfit ?? this.stagioneOutfit,
    imgsOutfit: imgsOutfit ?? this.imgsOutfit
  );

  @override
  String toString() {
    _listFiller();
    return 'Tipo outfit: $tipoOutfit \n'
        'Stagione outfit: $stagioneOutfit \n';
  }
}