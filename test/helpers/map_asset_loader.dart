import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MapAssetLoader extends AssetLoader {
  final Map<String, dynamic> translations;
  const MapAssetLoader(this.translations);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return translations;
  }
}
