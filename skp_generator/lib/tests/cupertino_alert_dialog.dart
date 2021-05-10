// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FlutterLogo;

class CupertinoDialogTest extends StatelessWidget {
  const CupertinoDialogTest({ Key? key, this.visible = true }) : super(key: key);

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: FlutterLogo(),
          ),
          if (visible)
            Center(
              child: CupertinoAlertDialog(
                title: const Text('Dialog Title'),
                content: Text('This is lots of dummy text. ' * 15),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('Close'),
                    onPressed: () { },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
