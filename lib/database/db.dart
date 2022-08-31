

import 'package:my_closet/models/Outfit.dart';
import 'package:path/path.dart';
import '/models/Indumento.dart';
import 'package:sqflite/sqflite.dart';


class OutfitDatabase {
  static final OutfitDatabase outfitDatabase = OutfitDatabase._init();
  static Database? _db;
  OutfitDatabase._init();

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _initDB('mycloset.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 8, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Vestito (id INTEGER PRIMARY KEY AUTOINCREMENT, brand TEXT, prezzo TEXT, colore TEXT, tipo TEXT, taglia TEXT, immagine TEXT)'
    );
    await db.execute(
      'CREATE TABLE Outfit (id INTEGER PRIMARY KEY AUTOINCREMENT, tipoOutfit TEXT, stagioneOutfit TEXT, image1 TEXT, image2 TEXT, image3 TEXT, image4 TEXT)'
    );
  }

  Future<Indumento> insertIndumento(Indumento indumento) async {
    final database = await outfitDatabase.db;
    final id = await database.insert("Vestito", indumento.toJson());
    return indumento.copy(id: id);
  }

  Future<Outfit> insertOutfit(Outfit outfit) async {
    final database = await outfitDatabase.db;
    final id = await database.insert("Outfit", outfit.toJson());
    return outfit.copy(id: id);
  }

  Future<Indumento> getIndumento(int id) async {
    final database = await outfitDatabase.db;
    final maps = await database.query(
        "Vestito",
        where: "id = ?",
        whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Indumento.fromJson(maps.first);
    } else {
      throw Exception('ID not found');
    }

  }

  Future<Outfit> getOutfit(int id) async {
    final database = await outfitDatabase.db;
    final maps = await database.query(
        "Outfit",
        where: "id = ?",
        whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Outfit.fromJson(maps.first);
    } else {
      throw Exception('ID not found');
    }
  }

  Future<Indumento> getIndumentoByPath(String path) async {
    final database = await outfitDatabase.db;
    final map = await database.query(
        "Vestito",
        where: "immagine = ?",
        whereArgs: [path]
    );

    if (map.isNotEmpty) {
      return Indumento.fromJson(map.first);
    } else {
      throw Exception('Path not found');
    }
  }

  Future<List<Indumento>> getRelatedIndumenti(List<String> imgsPath) async {
    List<Indumento> result = [];
    for (String path in imgsPath) {
      if (path != ' ') {
        var relatedIndumento = await getIndumentoByPath(path);
        result.add(relatedIndumento);
      }
    }
    return result;
  }

  Future<List<Indumento>> getAllVestiti() async {
    final database = await outfitDatabase.db;
    final result = await database.query("Vestito");
    return result.map((json) => Indumento.fromJson(json)).toList();
  }

  Future<List<Outfit>> getAllOutfit() async {
    final database = await outfitDatabase.db;
    final result = await database.query("Outfit");
    return result.map((json) => Outfit.fromJson(json)).toList();
  }

  Future<int> updateVestito(Indumento indumento) async {
    final database = await outfitDatabase.db;
    return database.update("Vestito", indumento.toJson(), where: "id = ?", whereArgs: [indumento.id]);
  }

  Future<int> updateOutfit(Outfit outfit) async {
    final database = await outfitDatabase.db;
    return database.update('Outfit', outfit.toJson(), where: "id = ?", whereArgs: [outfit.id]);
  }

  Future<int> deleteVestito(int id) async {
    final database = await outfitDatabase.db;
    return await database.delete("Vestito", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteOutfit(int id) async {
    final database = await outfitDatabase.db;
    return await database.delete("Outfit", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Outfit>> getLinkedOutfit(String imagePath) async {
    final database = await outfitDatabase.db;
    final result = await database.query(
        "Outfit",
        where: 'image1 = ? OR image2 = ? OR image3 = ? OR image4 = ?',
        whereArgs: [imagePath]
    );

    return result.map((e) => Outfit.fromJson(e)).toList();
  }

  Future<List<Indumento>> getLastThreeVestiti () async {
    final database = await outfitDatabase.db;
    final result = await database.query(
      "Vestito",
      orderBy: "id desc",
      limit: 3
    );

    return result.map((e) => Indumento.fromJson(e)).toList();
  }

  Future close() async {
    final database = await outfitDatabase.db;
    _db = null;
    database.close();
  }

  /// STATISTICHE

  Future<int> getNumeroVestiti() async {
    final database = await outfitDatabase.db;
    var res = await database.rawQuery('SELECT COUNT(*) FROM Vestito');
    int count = Sqflite.firstIntValue(res)!;
    return count;
  }

  Future<int> getNumeroOutfit() async {
    final database = await outfitDatabase.db;
    var res = await database.rawQuery('SELECT COUNT(*) FROM Outfit');
    int count = Sqflite.firstIntValue(res)!;
    return count;
  }

  Future<double> getPrezzoVestiti() async {
    final database = await outfitDatabase.db;
    double prezzo = 0.0;
    // Lista di Mappe {prezzo: x}
    var res = await database.rawQuery('SELECT prezzo FROM Vestito');
    for (Map<String, Object?> entry in res) {
      for (Object? value in entry.values) {
        prezzo += double.parse(value as String);
      }
    }
    return prezzo;
  }

  Future<Map<String, double>> getCountColori() async {
    final database = await outfitDatabase.db;
    Map<String, double> result = {};
    var qResult = await database.rawQuery('SELECT colore, COUNT(*) AS num FROM Vestito GROUP BY colore');

    for (var map in qResult) {
      var colore = map['colore'] as String;
      var num = map['num'] as int;
      result[colore] = num.toDouble();
    }

    return result;
  }

}