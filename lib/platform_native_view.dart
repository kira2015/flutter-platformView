import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformNativeViewController {
  MethodChannel _methodChannelReceive;

  MethodChannel _channel;
  PlatformNativeViewController.init(int id) {
    _channel = MethodChannel('flutter_ios_counter_$id');
    _methodChannelReceive = MethodChannel('flutter_ios_counter_receive_$id');
  }
  //发送
  Future<void> counterClick(String method,int counter) async {
    return _channel.invokeMethod(method, counter);
  }

  //接收
  listenNative(Future<dynamic> Function(MethodCall) handler) {
    _methodChannelReceive.setMethodCallHandler(handler);
  }
}

//声明
typedef void PlatformNativeViewCreatedCallback(
    PlatformNativeViewController controller);

class PlatformNativeView extends StatefulWidget {
  final counter;
  final PlatformNativeViewCreatedCallback callback;

  PlatformNativeView({
    Key key,
    @required this.callback,
    @required this.counter,
  });

  @override
  _PlatformNativeViewState createState() => _PlatformNativeViewState();
}

class _PlatformNativeViewState extends State<PlatformNativeView> {
  @override
  Widget build(BuildContext context) {
    return nativeView();
  }

  nativeView() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.native.view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{
          "counter": widget.counter,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Text('出错了');
    }
  }

  void _onPlatformViewCreated(int id) {
    if (widget.callback == null) {
      return;
    }
    widget.callback(PlatformNativeViewController.init(id));
  }
}
