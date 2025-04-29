
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../base_network/base_response.dart';
import '../flavor/flavor.dart';

class CacheManager {

  CacheManager._instance();
  static final CacheManager instance = CacheManager._instance();
  final String cacheBoxName = "cacheBox";

  Box? _cacheBox;

  Future<Box> _getBox() async {
    if (_cacheBox == null || !_cacheBox!.isOpen) {
      _cacheBox = await Hive.openBox(cacheBoxName);
    }
    return _cacheBox!;
  }


  Future<void> cacheData(dynamic body, String key) async {
    try {
      final cacheBox = await _getBox();
      await cacheBox.put(key, body);
    } catch(e){
      debugPrint("cacheJson: $e");
    }
  }

  Future<dynamic> getCacheData(String key) async {
    try {
      final cacheBox = await _getBox();
      final data = await cacheBox.get(key);
      return data;
    } catch(e){
      debugPrint("getCacheString: $e");
    }
    return null;
  }

  Future<void> removeData(String key) async {
    try {
      final cacheBox = await _getBox();
      await cacheBox.delete(key);
    } catch(e){
      debugPrint("removeData: $e");
    }
  }

  Future<ServerResponse<T>?> getCacheResponse<T>(String url, T Function(Map<String, Object?>)? target) async {
    try {
      final body = await getCacheData(url) as String?;
      if (body != null) {
        Map<String, dynamic>? json = jsonDecode(body);
        if (json != null) {
          final serverResponse = ServerResponse.parseJson(json, target);
          if (serverResponse.success && serverResponse.data != null) {
            return serverResponse;
          }
        }
      }
    } catch (e) {
      debugPrint("getCacheResponse: $e");
    }

    return null;
  }

  Future<ServerResponseArray<T>?> getCacheResponseArray<T>(String url, T Function(Map<String, Object?>)? target) async {
    try {
      final body = await getCacheData(url) as String?;
      if (body != null) {
        Map<String, dynamic>? json = jsonDecode(body);
        if (json != null) {
          final serverResponse = ServerResponseArray.parseJson(json, target);
          if (serverResponse.isSuccess && serverResponse.datas.isNotEmpty) {
            return serverResponse;
          }
        }
      }
    } catch (e){
      debugPrint("getCacheResponseArray: $e");
    }
    return null;
  }


  void clearCache() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      debugPrint("clearCache: $e");
    }
  }

  Future<void> dispose() async {
    if (_cacheBox?.isOpen == true) {
      await _cacheBox!.close();
    }
  }

}
