// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(new DriverTestApp());
}

class DriverTestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DriverTestAppState();
  }
}

class DriverTestAppState extends State<DriverTestApp> {
  bool present = true;
  Letter _selectedValue = Letter.a;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('FlutterDriver test'),
        ),
        body: new ListView(
          padding: const EdgeInsets.all(5.0),
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text(present ? 'present' : 'absent'),
                ),
                new RaisedButton(
                  child: const Text(
                    'toggle',
                    key: ValueKey<String>('togglePresent'),
                  ),
                  onPressed: () {
                    setState(() {
                      present = !present;
                    });
                  },
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                const Expanded(
                  child: Text('hit testability'),
                ),
                new DropdownButton<Letter>(
                  key: const ValueKey<String>('dropdown'),
                  value: _selectedValue,
                  onChanged: (Letter newValue) {
                    setState(() {
                      _selectedValue = newValue;
                    });
                  },
                  items: const <DropdownMenuItem<Letter>>[
                    DropdownMenuItem<Letter>(
                      value: Letter.a,
                      child: Text('Aaa', key: ValueKey<String>('a')),
                    ),
                    DropdownMenuItem<Letter>(
                      value: Letter.b,
                      child: Text('Bbb', key: ValueKey<String>('b')),
                    ),
                    DropdownMenuItem<Letter>(
                      value: Letter.c,
                      child: Text('Ccc', key: ValueKey<String>('c')),
                    ),
                  ],
                ),
              ],
            ),
            const TextField(
              key: ValueKey<String>('enter-text-field'),
            ),
          ],
        ),
      ),
    );
  }
}

enum Letter { a, b, c }
