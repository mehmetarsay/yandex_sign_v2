# yandex_sign_v2

Flutter plugin for yandex map sign and yandex navigator sign.

__Disclaimer__: This project uses Yandex sign algorithm which discribed 
in [commercial_use_signature_navigator](https://yandex.ru/dev/yandex-apps-launch/navigator/doc/concepts/navigator-commercial-use-signature-docpage/)
and [commercial_use_signature_yandexmaps](https://yandex.ru/dev/yandex-apps-launch/maps/doc/concepts/yandexmaps-commercial-use-signature-docpage/)

Improvements have been made to the package here. https://pub.dev/packages/yandex_sign

## Getting Started

### Generate your API Key

Get key and client Id from [yandex_navigator](https://yandex.ru/dev/yandex-apps-launch/navigator/doc/concepts/navigator-commercial-use-signature-docpage/) or [yandexmaps](https://yandex.ru/dev/yandex-apps-launch/maps/doc/concepts/yandexmaps-commercial-use-signature-docpage/)


### Initilazing for Android and IOS
1. Get String(base64) from file key.pem
2. Add to local variable for flutter project like in example

### Usage

Example:

```
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:yandex_sign/yandex_sign.dart';

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
      final url = 'a';
      final androidKey = '''-----BEGIN RSA PRIVATE KEY-----.......-----END RSA PRIVATE KEY-----''';
      signUrl = await YandexSign.getSignUrl(url, androidKey);
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

```

For more info see example

### Features

- [X] iOS Support
- [X] Android Support
