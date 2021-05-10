// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ExpandingExpansionPanel extends StatelessWidget {
  const ExpandingExpansionPanel({Key? key, required this.scale}) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Stack(
          children: <Widget>[
            Transform.scale(
              scale: scale,
              child: Center(
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  child: AlertDialog(
                    scrollable: true,
                    titlePadding: const EdgeInsets.symmetric(horizontal: 20.0),
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                    contentPadding: const EdgeInsets.all(20.0),
                    backgroundColor: Colors.teal,
                    content: Column(
                      children: <Widget>[
                        ExpansionPanelList(
                          children: [
                            ExpansionPanel(
                              headerBuilder: (var context, var isExpanded) {
                                return const ListTile(
                                  title: Text(
                                    'This is the title',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              canTapOnHeader: true,
                              isExpanded: false,
                              body: ListView.builder(
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                    onChanged: (isSelected) {},
                                    value: true,
                                    title: const Text('This is the title'),
                                    subtitle: const Text('This is the subtitle'),
                                  );
                                },
                                itemCount: 5,
                                shrinkWrap: true,
                              ),
                            ),
                          ],
                          expansionCallback: (panelIndex, isExpanded) {},
                          expandedHeaderPadding: const EdgeInsets.all(0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
