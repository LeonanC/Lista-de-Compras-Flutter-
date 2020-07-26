import 'package:lista_compras_app/application.dart';
import 'package:lista_compras_app/src/models/AbstractModel.dart';
import 'package:sqflite/sqflite.dart';

class ModelGasto extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static ModelGasto _this;

  factory ModelGasto() {
    if (_this == null) {
      _this = ModelGasto.getInstance();
    }
    return _this;
  }

  ModelGasto.getInstance() : super();

  ///
  /// The Instance
  ///
  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery('''
      SELECT
        L.*,
        (
          SELECT COUNT(1)
          FROM gasto as i
          WHERE L.pk_gasto
        ) as qtdPrecos
      FROM gasto as L
      ORDER BY L.criado DESC
    ''');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('gasto', where: 'pk_gasto = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('gasto', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {

    Database db = await this.getDb();
    int rows = await db.update('gasto', values, where: 'pk_gasto = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('gasto', where: 'pk_gasto = ?', whereArgs: [id]);

    return (rows != 0);
  }

}

class ModelItem extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static ModelItem _this;

  factory ModelItem() {
    if (_this == null) {
      _this = ModelItem.getInstance();
    }
    return _this;
  }

  ModelItem.getInstance() : super();

  ///
  /// The Instance
  ///
  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery('SELECT * FROM item ORDER BY criado DESC');
  }

  /// Retorna todos os items da lista
  /// 
  /// [fkLista] ID da lista
  Future<List<Map>> itemsByList(int fkLista) async {
    Database db = await this.getDb();
    return db.rawQuery('SELECT * FROM item WHERE fk_lista = $fkLista ORDER BY nome ASC, criado DESC');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('item', where: 'pk_item = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('item', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {

    Database db = await this.getDb();
    int rows = await db.update('item', values, where: 'pk_item = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('item', where: 'pk_item = ?', whereArgs: [id]);

    return (rows != 0);
  }

  /// Delete all items from a list
  /// @return int Number of rows deleted
  Future<int> deleteAllFromList(dynamic id) async {
    Database db = await this.getDb();
    return await db.delete('item', where: 'fk_lista = ?', whereArgs: [id]);
  }

}

class ModelLista extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static ModelLista _this;

  factory ModelLista() {
    if (_this == null) {
      _this = ModelLista.getInstance();
    }
    return _this;
  }

  ModelLista.getInstance() : super();

  ///
  /// The Instance
  ///
  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery('''
      SELECT
        L.*,
        (
          SELECT COUNT(1)
          FROM item as i
          WHERE i.fk_lista = L.pk_lista
        ) as qtdItems
      FROM lista as L
      ORDER BY L.criado DESC
    ''');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('lista', where: 'pk_lista = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('lista', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {

    Database db = await this.getDb();
    int rows = await db.update('lista', values, where: 'pk_lista = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('lista', where: 'pk_lista = ?', whereArgs: [id]);

    return (rows != 0);
  }

}

class ModelPreco extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static ModelPreco _this;

  factory ModelPreco() {
    if (_this == null) {
      _this = ModelPreco.getInstance();
    }
    return _this;
  }

  ModelPreco.getInstance() : super();

  ///
  /// The Instance
  ///
  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery('''
      SELECT
        L.*,
        (
          SELECT COUNT(1)
          FROM preco as i
          WHERE L.pk_preco
        ) as qtdPrecos
      FROM preco as L
      ORDER BY L.criado DESC
    ''');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('preco', where: 'pk_preco = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('preco', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {

    Database db = await this.getDb();
    int rows = await db.update('preco', values, where: 'pk_preco = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('preco', where: 'pk_preco = ?', whereArgs: [id]);

    return (rows != 0);
  }

}