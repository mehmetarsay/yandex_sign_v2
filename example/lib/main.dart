import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:yandex_sign_v2/yandex_sign.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _signUrl = 'Unknown';


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String signUrl;
    try {
      final url = 'yandexmaps://maps.yandex.ru?ll=55.75,37.64&z=14&client=007';
      final key = '''-----BEGIN RSA PRIVATE KEY-----.......-----END RSA PRIVATE KEY-----''';
      signUrl = await YandexSign.getSignUrl(url, key);
    } on PlatformException {
      signUrl = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _signUrl = signUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_signUrl\n'),
        ),
      ),
    );
  }
}
