import 'dart:async';

import 'package:flutter/services.dart';

class YandexSign {
  static const MethodChannel _channel =
      const MethodChannel('yandex_sign');

  static Future<String> getSignUrl(String url, String key) async {
    final String signUrl = await _channel.invokeMethod('getSignUrl', {'url': url, 'key': key});
    return signUrl;
  }
}
