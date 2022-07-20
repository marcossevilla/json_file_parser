import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, Object?> Function(T value);

class DeserializationException implements Exception {
  DeserializationException(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

class SerializationException implements Exception {
  SerializationException(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

class JsonFileParser<T> {
  const JsonFileParser({
    required FromJson<T> fromJson,
    required ToJson<T> toJson,
  })  : _fromJson = fromJson,
        _toJson = toJson;

  final FromJson<T> _fromJson;
  final ToJson<T> _toJson;

  Future<String> get _defaultFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<T> deserialize({required String assetPath}) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return _fromJson(json);
    } catch (error, stackTrace) {
      throw DeserializationException(error, stackTrace);
    }
  }

  Future<void> serialize(T value, {required String filename}) async {
    try {
      final directory = await _defaultFilePath;
      final file = File('$directory/$filename');
      final json = _toJson(value);
      final jsonString = jsonEncode(json);
      await file.writeAsString(jsonString);
    } catch (error, stackTrace) {
      throw SerializationException(error, stackTrace);
    }
  }
}
