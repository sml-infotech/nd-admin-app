import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/generated/l10n.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'highlight_viewmodel.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class HighLightsUploaderScreen extends StatefulWidget {
  const HighLightsUploaderScreen({super.key});

  @override
  State<HighLightsUploaderScreen> createState() =>
      _HighLightsUploaderScreenState();
}

class _HighLightsUploaderScreenState extends State<HighLightsUploaderScreen> {
  XFile? _pickedFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  int _selectedSegment = 0; // 0: Active, 1: Inactive
  final Set<String> _selectedItems = {};

  // Your media lists
  List<String> activeMedia = [
    "https://picsum.photos/id/1016/400/700",
    "https://picsum.photos/id/1011/400/700",
  ];
  List<String> inactiveMedia = [
    "https://picsum.photos/id/1015/400/700",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  ];

  Future<void> _pickImage() async {
    final viewModel = Provider.of<HighlightViewmodel>(context, listen: false);

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _clearPreviousVideo();
      viewModel.addMedia([pickedFile.path], false);
      setState(() => _pickedFile = pickedFile);
    }
  }

  Future<void> _pickVideo() async {
    final viewModel = Provider.of<HighlightViewmodel>(context, listen: false);
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _clearPreviousVideo();
      final controller = VideoPlayerController.file(File(pickedFile.path));
      try {
        await controller.initialize();
        viewModel.addMedia([pickedFile.path], true);
        if (mounted) {
          setState(() {
            _pickedFile = pickedFile;
            _videoController = controller;
            _videoController!.play();
            _videoController!.setLooping(true);
          });
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  void _clearPreviousVideo() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
  }

  void _toggleStatus() {
    setState(() {
      if (_selectedSegment == 0) {
        inactiveMedia.addAll(_selectedItems);
        activeMedia.removeWhere((item) => _selectedItems.contains(item));
      } else {
        activeMedia.addAll(_selectedItems);
        inactiveMedia.removeWhere((item) => _selectedItems.contains(item));
      }
      _selectedItems.clear();
    });
  }

  @override
  void dispose() {
    _clearPreviousVideo();
    super.dispose();
  }

  // Helper to check if a path is a video, ignoring URL parameters
  bool _checkIsVideo(String path) {
    String cleanPath = path.split('?').first.toLowerCase();
    return cleanPath.endsWith('.mp4') || cleanPath.endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HighlightViewmodel>(context);
    List<String> currentList = _selectedSegment == 0
        ? activeMedia
        : inactiveMedia;
    return Scaffold(
      appBar: AppBar(
        title: nammaDaivaCreateAppBar(),
        backgroundColor: ColorConstant.buttonColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showPickerOptions,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: _buildPreview(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.buttonColor,
                      ),
                      onPressed: viewModel.isLoading ? null : _handleUpload,
                      child: viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Upload ",
                              style: TextStyle(
                                fontFamily: font,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _segmentButton("Active", 0),
                        _segmentButton("Inactive", 1),
                      ],
                    ),
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedSegment == 0
                            ? "Active Highlights"
                            : "Inactive Highlights",
                        style: TextStyle(
                          fontFamily: font,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (_selectedItems.isNotEmpty)
                        TextButton(
                          onPressed: _toggleStatus,
                          child: Text(
                            _selectedSegment == 0
                                ? " Move to Deactivate"
                                : "Move to Activate",
                            style: TextStyle(
                              fontFamily: font,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (currentList.isNotEmpty) _buildMediaGrid(),
                  if (currentList.isEmpty) ...[
                    const SizedBox(height: 100),
                    GestureDetector(
                      onTap: _showPickerOptions,
                      child: Center(
                        child: Text(
                          "+ Add Highlights ",
                          style: TextStyle(
                            fontFamily: font,
                            color: Colors.black,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nammaDaivaCreateAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.addHighlights,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Future<void> _handleUpload() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select a file first")));
      return;
    }

    final viewModel = Provider.of<HighlightViewmodel>(context, listen: false);
    bool isVideo = _checkIsVideo(_pickedFile!.path);

    // await viewModel.addMedia([_pickedFile!.path], isVideo);

    if (viewModel.uploadedImageUrls.isNotEmpty) {
      setState(() {
        // We split by '?' to get the clean public S3 URL instead of the PutObject pre-signed URL
        String cleanUrl = viewModel.uploadedImageUrls.last.split('?').first;
        activeMedia.insert(0, cleanUrl);
        _pickedFile = null;
        _clearPreviousVideo();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload Successful!")));
    }
  }

  Widget _buildPreview() {
    if (_pickedFile == null)
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 40),
            Text("Tap to select HighLights"),
          ],
        ),
      );

    if (_checkIsVideo(_pickedFile!.path)) {
      return _videoController != null && _videoController!.value.isInitialized
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )
          : const Center(child: CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(File(_pickedFile!.path), fit: BoxFit.cover),
    );
  }

  Widget _buildMediaGrid() {
    List<String> currentList = _selectedSegment == 0
        ? activeMedia
        : inactiveMedia;

    return ReorderableGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: currentList.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final item = currentList.removeAt(oldIndex);
          currentList.insert(newIndex, item);
        });
      },
      dragWidgetBuilder: (index, child) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      itemBuilder: (context, index) {
        String path = currentList[index];
        bool isSelected = _selectedItems.contains(path);
        bool isVideo = _checkIsVideo(path);

        // Each item MUST have a unique ValueKey
        return Stack(
          key: ValueKey(path),
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => _showMediaDialog(context, path),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: isVideo
                      ? VideoGridThumbnail(url: path)
                      : Image.network(
                          path,
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: Checkbox(
                value: isSelected,
                shape: const CircleBorder(),
                activeColor: Colors.blue,
                onChanged: (val) => setState(() {
                  val! ? _selectedItems.add(path) : _selectedItems.remove(path);
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _segmentButton(String title, int index) {
    bool isSelected = _selectedSegment == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          _selectedSegment = index;
          _selectedItems.clear();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? ColorConstant.buttonColor : Colors.white,
            border: Border.all(color: ColorConstant.buttonColor),
            borderRadius: index == 0
                ? const BorderRadius.horizontal(left: Radius.circular(20))
                : const BorderRadius.horizontal(right: Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: font,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text('Photo', style: TextStyle(fontFamily: font)),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('Video', style: TextStyle(fontFamily: font)),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- THUMBNAIL COMPONENT ---
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
    if (_hasError)
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.error_outline, color: Colors.red),
      );
    if (!_initialized)
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(child: VideoPlayer(_controller)),
        const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
      ],
    );
  }
}

void _showMediaDialog(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor:
            Colors.transparent, // Makes the container look floating
        insetPadding: const EdgeInsets.all(20), // Padding around the dialog
        child: MediaDialogContent(url: url),
      );
    },
  );
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
      mainAxisSize:
          MainAxisSize.max, // Dialog takes only as much space as needed
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
