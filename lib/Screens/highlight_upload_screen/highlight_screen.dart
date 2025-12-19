import 'dart:io';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammadaiva_dashboard/Screens/highlight_upload_screen/media_viewer.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/generated/l10n.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/highlight_model/active_list_responsemodel.dart';
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
  late HighlightViewmodel viewModel = Provider.of<HighlightViewmodel>(
    context,
    listen: false,
  );

  int _selectedSegment = 0;
  final Set<String> _selectedItems = {};

  late List<String> activeMedia = viewModel.highlightList
      .map((item) => item.mediaUrl)
      .whereType<String>()
      .toList();
  late List<String> inactiveMedia = viewModel.highlightList
      .map((item) => item.mediaUrl)
      .whereType<String>()
      .toList();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _clearPreviousVideo();
      // viewModel.addMedia([pickedFile.path], false);
      setState(() => _pickedFile = pickedFile);
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _clearPreviousVideo();
      final controller = VideoPlayerController.file(File(pickedFile.path));
      try {
        await controller.initialize();
        // viewModel.addMedia([pickedFile.path], true);
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

  void _toggleStatus() async {
    // Check if no items are selected
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No items selected")));
      return;
    }

    debugPrint("Selected items: $_selectedItems");
    debugPrint("Active media before update: $activeMedia");
    debugPrint("Inactive media before update: $inactiveMedia");

    if (_selectedSegment == 0) {
      await viewModel.updateHighlight(_selectedItems.toList(), false);
      setState(() {
        activeMedia.removeWhere((item) => _selectedItems.contains(item));
        inactiveMedia.addAll(_selectedItems);
        viewModel.fetchHighlights();
      });
    } else {
      await viewModel.updateHighlight(_selectedItems.toList(), true);
      setState(() {
        inactiveMedia.removeWhere((item) => _selectedItems.contains(item));
        activeMedia.addAll(_selectedItems);
        viewModel.fetchInactiveHighlights();
      });
    }

    debugPrint("Active media after update: $activeMedia");
    debugPrint("Inactive media after update: $inactiveMedia");

    setState(() {
      _selectedItems.clear();
    });
  }

  @override
  void dispose() {
    _clearPreviousVideo();
    super.dispose();
  }

  bool _checkIsVideo(String path) {
    String cleanPath = path.split('?').first.toLowerCase();
    return cleanPath.endsWith('.mp4') || cleanPath.endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HighlightViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: nammaDaivaCreateAppBar(),
        backgroundColor: ColorConstant.buttonColor,
        centerTitle: true,
      ),
      body: FocusDetector(
        onFocusGained: () async {
          await viewModel.fetchHighlights();
        },
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 15),
                uploadContentWidget(viewModel),
              ],
            ),
            if (viewModel.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.buttonColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget uploadContentWidget(HighlightViewmodel viewModel) {
    final currentList = _selectedSegment == 0
        ? viewModel.activeHighlights
        : viewModel.inactiveHighlights;
    return Expanded(
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
            uploadButton(viewModel),
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
            activeAndInactiveSegment(),
            const SizedBox(height: 10),
            if (currentList.isNotEmpty) _buildMediaGrid(),
            if (currentList.isEmpty) ...[
              const SizedBox(height: 100),
              addHighlightUnderLineButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget activeAndInactiveSegment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedSegment == 0 ? "Active Highlights" : "Inactive Highlights",
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
              style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget uploadButton(HighlightViewmodel viewModel) {
    return SizedBox(
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
                style: TextStyle(fontFamily: font, color: Colors.white),
              ),
      ),
    );
  }

  Widget addHighlightUnderLineButton() {
    return GestureDetector(
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
    await viewModel.addMedia([_pickedFile!.path], isVideo);
    if (viewModel.uploadedImageUrls.isNotEmpty) {
      setState(() {
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
    if (_pickedFile == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 40),
            Text("Tap to select HighLights"),
          ],
        ),
      );
    }

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
    List<HighlightItem> currentList = _selectedSegment == 0
        ? viewModel.activeHighlights
        : viewModel.inactiveHighlights;

    return ReorderableGridView.builder(
      shrinkWrap: true,
      physics:
          _selectedSegment ==
              0
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: currentList.length,
      onReorder: 
      
      (oldIndex, newIndex) {
        if (_selectedSegment == 0) {
          setState(() {
            final item = currentList.removeAt(oldIndex);
            currentList.insert(newIndex, item);
            final movedItem = viewModel.highlightList.removeAt(oldIndex);
            viewModel.highlightList.insert(newIndex, movedItem);
          });

          final movedItemId = viewModel.highlightList[newIndex].id ?? '';
          viewModel.reorderHighlights(movedItemId, oldIndex, newIndex);
        }
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
        HighlightItem highlightItem = currentList[index];
        String path = highlightItem.mediaUrl ?? '';
        String id = highlightItem.id ?? '';
        bool isSelected = _selectedItems.contains(id);
        bool isVideo = _checkIsVideo(path);

        return Stack(
          key: ValueKey(id),
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
                  if (val!) {
                    _selectedItems.add(id);
                  } else {
                    _selectedItems.remove(id);
                  }
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
          if (index == 0) {
            viewModel.fetchHighlights(refresh: true);
          } else {
            viewModel.fetchInactiveHighlights();
          }
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

void _showMediaDialog(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: MediaDialogContent(url: url),
      );
    },
  );
}
