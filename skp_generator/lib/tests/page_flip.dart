// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class PageFlipTest extends StatelessWidget {
  const PageFlipTest({
    Key? key,
    required this.angle,
  }) : assert(angle >= 0.0),
       assert(angle < 0.5),
       super(key: key);

  // 0.0, 0.097, 0.194
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: (Matrix4.rotationY(angle * math.pi)..setEntry(3, 0, angle * 0.008)) *
                 Matrix4.diagonal3Values((1.0 - angle), (1.0 - angle), 1.0),
      alignment: Alignment.center,
      child: GridPaper(
        interval: 256.0,
        child: Container(
          margin: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF006666),
            border: Border.all(color: const Color(0xFF0000FF), width: 8.0),
          ),
          child: const Text('My name\'s not Kirk... It\'s Skywalker.',
            style: TextStyle(fontSize: 64.0, color: Color(0xFFFFFF00)),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
