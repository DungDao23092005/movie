import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WatchScreen extends StatefulWidget {
  final String videoUrl;

  const WatchScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {

  late final WebViewController controller;

  @override
  void initState() {

    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..loadRequest(
        Uri.parse(widget.videoUrl),
      );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Watch"),

      ),

      body: WebViewWidget(

        controller: controller,

      ),

    );

  }
}