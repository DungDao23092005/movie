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
  late final WebViewController _controller;

  bool _isLoading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.description),
              ),
            );
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.videoUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Đang xem"),
        actions: [
          IconButton(
            tooltip: "Tải lại",
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),

          if (_isLoading)
            Container(
              color: Colors.black,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _progress,
                    minHeight: 3,
                  ),
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}