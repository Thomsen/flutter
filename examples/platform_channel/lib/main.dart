// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => new _PlatformChannelState();
}

class TransData {
  String name;

  TransData(this.name);

  TransData.fromMap(Map<String, dynamic> map)
      : name = map['name'];

  Map<String, dynamic> toMap() => {
    'name': name
  };

}


class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel methodChannel =
      const MethodChannel('samples.flutter.io/battery');
  static const EventChannel eventChannel =
      const EventChannel('samples.flutter.io/charging');

  static const MethodChannel methodPageChannel = const MethodChannel("samples.flutter.io/intent");

  String _batteryLevel = 'Battery level: unknown.';
  String _chargingStatus = 'Battery status: unknown.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
//      final int result = await methodChannel.invokeMethod('getBatteryLevel');
//      batteryLevel = 'Battery level: $result%.';

      batteryLevel = 'Battery level: 100%';
      TransData data = new TransData('flutter page text');

      methodPageChannel.invokeMethod("openPage", data.toMap());

    } on PlatformException {
      batteryLevel = 'Failed to get battery level.';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    methodPageChannel.setMethodCallHandler(platformCallHandler);

  }

  Future<dynamic> platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onResult": {
        print("on result: " + call.arguments['name']);
        setState(() {
          TransData transData = new TransData.fromMap(call.arguments);
          _chargingStatus = transData.name;
        });
        break;
      }
    }
  }


  void _onEvent(Object event) {
    setState(() {
      _chargingStatus =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown.';
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_batteryLevel, key: const Key('Battery level label')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('Refresh'),
                  onPressed: _getBatteryLevel,
                ),
              ),
            ],
          ),
          new Text(_chargingStatus),
        ],
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(home: new PlatformChannel()));
}
