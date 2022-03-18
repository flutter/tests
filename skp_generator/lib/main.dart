// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

import 'tests/cupertino_alert_dialog.dart';
import 'tests/expanding_expansion_panel.dart';
import 'tests/expanding_shadows.dart';
import 'tests/page_flip.dart';

String get title => 'SKP COLLECTION\n'
  'GENERATED ${DateTime.now()}\n'
  'ON ${Platform.localHostname}\n'
  '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';

late VmService vmService;
  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint = debugPrintSynchronously;
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
    exit(1);
  };
  
  final developer.ServiceProtocolInfo info = await developer.Service.getInfo();
  if (info.serverUri == null) {
    print('skp_generator could not determine VM service protocol URL.');
    print('Use "build.sh" to run this application.');
    exit(1);
  }
  String url = 'ws://localhost:${info.serverUri!.port}${info.serverUri!.path}ws';
  vmService = await vmServiceConnectUri(url);

  runApp(TestScreen(widgets: <Widget>[
    Slate(title: title),
    const PageFlipTest(angle: 0.0),
    const PageFlipTest(angle: 0.097),
    const PageFlipTest(angle: 0.097 * 2.0),
    const CupertinoDialogTest(),
    const StoryBoard<ExpandingExpansionPanel>(widgets: <ExpandingExpansionPanel>[
      ExpandingExpansionPanel(scale: 0.0),
      ExpandingExpansionPanel(scale: 0.05),
      ExpandingExpansionPanel(scale: 0.1),
      ExpandingExpansionPanel(scale: 0.2),
      ExpandingExpansionPanel(scale: 0.3),
      ExpandingExpansionPanel(scale: 0.4),
      ExpandingExpansionPanel(scale: 0.5),
      ExpandingExpansionPanel(scale: 0.8),
      ExpandingExpansionPanel(scale: 1.0),
    ]),
    const StoryBoard<ExpandingPhysicalModel>(widgets: <ExpandingPhysicalModel>[
      ExpandingPhysicalModel(scale: 0.0),
      ExpandingPhysicalModel(scale: 0.05),
      ExpandingPhysicalModel(scale: 0.1),
      ExpandingPhysicalModel(scale: 0.2),
      ExpandingPhysicalModel(scale: 0.3),
      ExpandingPhysicalModel(scale: 0.4),
      ExpandingPhysicalModel(scale: 0.5),
      ExpandingPhysicalModel(scale: 0.8),
      ExpandingPhysicalModel(scale: 1.0),
    ]),
    const StoryBoard<ExpandingBlurs>(widgets: <ExpandingBlurs>[
      ExpandingBlurs(scale: 0.0),
      ExpandingBlurs(scale: 0.05),
      ExpandingBlurs(scale: 0.1),
      ExpandingBlurs(scale: 0.2),
      ExpandingBlurs(scale: 0.3),
      ExpandingBlurs(scale: 0.4),
      ExpandingBlurs(scale: 0.5),
      ExpandingBlurs(scale: 0.8),
      ExpandingBlurs(scale: 1.0),
    ]),
  ]));
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key, required this.widgets }) : super(key: key);

  final List<Widget> widgets;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addTimingsCallback(_framesRendered);
  }

  @override
  void dispose() {
    SchedulerBinding.instance!.removeTimingsCallback(_framesRendered);
    super.dispose();
  }

  String? _name;
  bool _captured = false;
  
  void _framesRendered(List<FrameTiming> timings) async {
    int remaining = timings.length;
    for (FrameTiming timing in timings) {
      remaining -= 1;
      print(
        'Rendered ${ _name == null || remaining > 0 ? "discarded frame (!)" : "frame for \"$_name\"" }: '
        'build: ${_describe(timing.buildDuration)}; '
        'raster: ${_describe(timing.rasterDuration)}; '
        'total: ${_describe(timing.totalSpan, target: const Duration(milliseconds: 16))}',
      );
    }
    if (!_captured && _name != null) {
      _capture();
    }
  }

  String _describe(Duration duration, {
    Duration target = const Duration(milliseconds: 8),
    Duration woah = const Duration(milliseconds: 100),
  }) {
    assert(target < woah);
    if (duration > woah) {
      return '${duration.inMilliseconds}ms!!';
    }
    if (duration > target) {
      return '${duration.inMilliseconds}ms!';
    }
    return '${duration.inMilliseconds}ms';
  }

  Future<void> _capture() async {
    _captured = true;
    final Response response = await vmService.callServiceExtension('_flutter.screenshotSkp');
    final String filename = 'skps/flutter_$_name.skp';
    await File(filename).writeAsBytes(base64Decode(response.json!['skp'] as String));
    if (mounted) {
      setState(() {
        _name = null;
        _captured = false;
      });
    }
  }

  Type _lastType = Null;
  int _index = 0;
  int _subindex = 0;

  @override
  Widget build(BuildContext context) {
    assert(_name == null);
    if (_index >= widget.widgets.length) {
      print('Terminating...');
      exit(0);
    }
    Widget target = widget.widgets[_index];
    if (_lastType != target.runtimeType) {
      _lastType = target.runtimeType;
      _subindex = 0;
    }
    _index += 1;
    _subindex += 1;
    _name = '$_lastType.${_subindex.toString().padLeft(2, "0")}';
    return target;
  }
}

class Slate extends StatelessWidget {
  const Slate({ Key? key, required this.title }) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, textDirection: TextDirection.ltr));
  }
}

class StoryBoard<T extends Widget> extends StatelessWidget {
  const StoryBoard({ Key? key, required this.widgets }) : super(key: key);

  final List<T> widgets;
  
  @override
  Widget build(BuildContext context) {
    int dim = math.sqrt(widgets.length).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int y = 0; y < dim; y += 1)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                for (int x = 0; x < dim; x += 1)
                  Expanded(
                    child: y * dim + x < widgets.length ? widgets[y * dim + x] : const Placeholder(),
                  ),
              ],
            )
          ),
      ],
    );
  }
}
