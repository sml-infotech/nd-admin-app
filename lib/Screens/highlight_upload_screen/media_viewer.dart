
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';












class VideoGridThumbnail extends StatefulWidget {
  final String url;
  const VideoGridThumbnail({super.key, required this.url});

  @override
  State<VideoGridThumbnail> createState() => _VideoGridThumbnailState();
}

class _VideoGridThumbnailState extends State<VideoGridThumbnail> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = widget.url.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
        : VideoPlayerController.file(File(widget.url));

    _controller
        .initialize()
        .then((_) {
          if (mounted) {
            _controller.seekTo(const Duration(seconds: 1));
            setState(() => _initialized = true);
          }
        })
        .catchError((error) {
          if (mounted) setState(() => _hasError = true);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
    if (!_initialized) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(child: VideoPlayer(_controller)),
        const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
      ],
    );
  }
}





class MediaDialogContent extends StatefulWidget {
  final String url;
  const MediaDialogContent({super.key, required this.url});

  @override
  State<MediaDialogContent> createState() => _MediaDialogContentState();
}

class _MediaDialogContentState extends State<MediaDialogContent> {
  VideoPlayerController? _videoController;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();
    String cleanPath = widget.url.split('?').first.toLowerCase();
    isVideo = cleanPath.endsWith('.mp4') || cleanPath.endsWith('.mov');

    if (isVideo) {
      _videoController = widget.url.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
          : VideoPlayerController.file(File(widget.url));

      _videoController!.initialize().then((_) {
        if (mounted) setState(() {});
        _videoController!.play();
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Close Button Row
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // Media Content
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: isVideo
                ? _videoController != null &&
                          _videoController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_videoController!),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _videoController!.value.isPlaying
                                        ? _videoController!.pause()
                                        : _videoController!.play();
                                  });
                                },
                                child: Icon(
                                  _videoController!.value.isPlaying
                                      ? null
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator(),
                        )
                : InteractiveViewer(
                    child: widget.url.startsWith('http')
                        ? Image.network(widget.url, fit: BoxFit.contain)
                        : Image.file(File(widget.url), fit: BoxFit.contain),
                  ),
          ),
        ),
      ],
    );
  }
}
