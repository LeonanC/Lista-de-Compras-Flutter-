import 'package:intl/intl.dart';

Map<String, int> unity = Map.from({ 'Un': 0, 'Kg': 3 });

String dbName = 'listaCompras.db';
int dbVersion = 1;

List<String> dbCreate = [
  // tb lista
  """CREATE TABLE lista (
    pk_lista INTEGER PRIMARY KEY,
    nome TEXT,
    criado TEXT
  )""",

  // tb Item
  """CREATE TABLE item (
    pk_item INTEGER PRIMARY KEY,
    fk_lista INTEGER,
    nome TEXT,
    quantidade DECIMAL(10, 3),
    precisao INTEGER DEFAULT 0,
    valor DECIMAL(10,2),
    checked INTEGER DEFAULT 0,
    criado TEXT
  )""",

  // tb Preco
  """CREATE TABLE preco (
    pk_preco INTEGER PRIMARY KEY,
    nome TEXT,
    valor DECIMAL(10,2),
    criado TEXT
  )""",

  // tb Gasto
  """CREATE TABLE gasto (
    pk_gasto INTEGER PRIMARY KEY,
    nome TEXT,
    valor DECIMAL(10,2),
    criado TEXT
  )""",
];

double currencyToDouble(String value) {
  value = value.replaceFirst('R\$ ', '');
  value = value.replaceAll(RegExp(r'\.'), '');
  value = value.replaceAll(RegExp(r'\,'), '.');

  return double.tryParse(value) ?? null;
}

double currencyToFloat(String value) {
  return currencyToDouble(value);
}

String doubleToCurrency(double value) {
  NumberFormat nf = NumberFormat.compactCurrency(locale: 'pt_BR', symbol: 'R\$');
  return nf.format(value);
}