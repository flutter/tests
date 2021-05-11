// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

// This file contains two variants of a similar effect. The first
// (ExpandingPhysicalModel) uses Skia's built-in shadows and is quite efficient.
// The second uses blurs, and is discouraged. However, it is still found in code
// in the wild.

class ExpandingPhysicalModel extends StatelessWidget {
  const ExpandingPhysicalModel({ Key? key, required this.scale }) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF009688),
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: const EdgeInsets.all(30.0),
          padding: const EdgeInsets.all(30.0),
          child: PhysicalModel(
            color: const Color(0xFFCDDC39),
            borderRadius: BorderRadius.circular(10.0),
            elevation: 4.0,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class ExpandingBlurs extends StatelessWidget {
  const ExpandingBlurs({ Key? key, required this.scale }) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF009688),
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: const EdgeInsets.all(30.0),
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: const Color(0xFFCDDC39),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(offset: Offset(4.0, 4.0), blurRadius: 2.0, spreadRadius: 0.0, color: Color(0x24000000)),
              BoxShadow(offset: Offset(-4.0, 4.0), blurRadius: 4.0, spreadRadius: 0.0, color: Color(0x24000000)),
              BoxShadow(offset: Offset(4.0, -4.0), blurRadius: 8.0, spreadRadius: 0.0, color: Color(0x24000000)),
              BoxShadow(offset: Offset(-4.0, -4.0), blurRadius: 12.0, spreadRadius: 0.0, color: Color(0x24000000)),
              BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 16.0, spreadRadius: 4.0, color: Color(0x24000000)),
            ],
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
