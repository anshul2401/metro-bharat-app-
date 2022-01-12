import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//change language and convert string
class DemoLocalization {
  DemoLocalization(this.locale);

  final Locale locale;
  static DemoLocalization? of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  static Map<String, String>? _localizedValues;

  Future<void> load() async {
    String jsonStringValues =
    await rootBundle.loadString('lib/Language/${locale.languageCode}.json');
    print("json string values**********$jsonStringValues");
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));

  }
  String? translate(String key) {
    return _localizedValues![key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<DemoLocalization> delegate =
  _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'hi', 'tr', 'pt']
        .contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization = new DemoLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<DemoLocalization> old) => false;
}