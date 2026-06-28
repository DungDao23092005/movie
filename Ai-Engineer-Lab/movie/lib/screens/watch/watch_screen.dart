import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:go_router/go_router.dart';

import '../../models/watch_arguments.dart';
import '../../storage/history_storage.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/error_view.dart';

class WatchScreen extends StatefulWidget {
  final WatchArguments arguments;

  const WatchScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      debugPrint("====== DỮ LIỆU VIDEO ======");
      debugPrint("Link: ${widget.arguments.videoUrl}");
      
      // Khởi tạo Player kèm Header giả lập trình duyệt Chrome (User-Agent)
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.arguments.videoUrl),
        httpHeaders: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        },
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        startAt: Duration(seconds: widget.arguments.startAt),
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Không thể phát luồng video này.\n\nChi tiết: $errorMessage\n\nLink hiện tại: ${widget.arguments.videoUrl}",
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    // Chỉ lưu thời gian nếu video đã khởi tạo thành công
    if (_videoPlayerController.value.isInitialized) {
      final currentPosition = _videoPlayerController.value.position.inSeconds;
      HistoryStorage.updateWatchPosition(
        widget.arguments.slug,
        widget.arguments.episodeName,
        currentPosition,
      );
    }
    
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Tập ${widget.arguments.episodeName}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _hasError
            ? ErrorView(
                title: "Lỗi phát Video",
                error: "Máy chủ từ chối kết nối hoặc định dạng không hỗ trợ.\n\nChi tiết: $_errorMessage\n\nLink: ${widget.arguments.videoUrl}",
                onRetry: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = "";
                  });
                  _initializePlayer();
                },
              )
            : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : const LoadingView(text: "Đang tải dữ liệu video..."),
      ),
    );
  }
}