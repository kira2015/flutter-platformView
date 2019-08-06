import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:platform_native_view/platform_native_view.dart';

void main() => runApp(PlatformHome());

class PlatformHome extends StatefulWidget {
  @override
  _PlatformHomeState createState() => _PlatformHomeState();
}

class _PlatformHomeState extends State<PlatformHome> {
  //核心控制器
  PlatformNativeViewController _controller;

  int _counter = 0;

  Future<dynamic> _handler(MethodCall call) {
    print('flutter接收：${call.arguments}');
    if (call.method == 'counter_method') {
      _counter = call.arguments;
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlatformView使用'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Running on: native'),
            SizedBox(
              width: 300,
              height: 300,
              child: PlatformNativeView(
                counter: _counter,
                callback: (PlatformNativeViewController controller) {
                  _controller = controller;
                  _controller.listenNative(_handler);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('----下面是Flutter----'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('发送到ios端+1'),
                  onPressed: () {
                    _counter++;
                    print('flutter->$_counter');
                    _controller.counterClick('counter_method', _counter);
                    setState(() {});
                  },
                ),
                RaisedButton(
                  child: Text('调用原生的第三方库'),
                  onPressed: () {
                    _controller.counterClick('pods_method', 0);
                  },
                ),
              ],
            ),
            Text('counter:$_counter')
          ],
        ),
      ),
    );
  }
}
