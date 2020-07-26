import 'package:flutter/widgets.dart';
import 'package:internationalization/internationalization.dart';

class Intl {
  static String get stringsPath => "assets/translations/";
  static List<Locale> get suportedLocales => [
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('en'),
  ];
  static List<String> get files => [
    "usage",
    "next_page"
  ];

  static _Usage get usage => const _Usage();
  static _Next_page get next_page => const _Next_page();
}

class _Usage {
  const _Usage();

  String simpleString({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "simple_string".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String interpolationString({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "interpolation_string".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String interpolationStringWithNamedArgs({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "interpolation_string_with_named_args".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String simplePlurals({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "simple_plurals".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String interpolationPlurals({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "interpolation_plurals".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String nextPageBtn({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) 
  => "next_page_btn".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
}

class _Next_page {
  const _Next_page();

  String title({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) => "title".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String titulo({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) => "titulo".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String primeiraPagina({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) => "Lista de Compras".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
  String wellcomeLabel({int pluralValue, List<String> args, Map<String, dynamic> namedArgs}) => "welcome_label".translate(pluralValue: pluralValue, args: args, namedArgs: namedArgs);
}