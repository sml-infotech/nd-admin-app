import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ArticleSectionUI extends StatefulWidget {
  const ArticleSectionUI({super.key});

  @override
  State<ArticleSectionUI> createState() => _ArticleSectionUIState();
}

class _ArticleSectionUIState extends State<ArticleSectionUI> {
  late CreateBlogViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<CreateBlogViewmodel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        _sectionHeader('Article Section (English)'),
        const SizedBox(height: 16),

        _label(AppLocalizations.of(context)!.sectionTitle),
        CommonTextField(
          hintText: AppLocalizations.of(context)!.sectionTitle,
          labelText: AppLocalizations.of(context)!.sectionTitle,
          controller: viewModel.sectionTitle,
          isFromPassword: false,
        ),
        const SizedBox(height: 24),

        ..._buildParagraphFields(),

        _textButton(
          icon: Icons.add,
          label: 'Add Paragraph',
          onPressed: _addParagraph,
        ),

        const SizedBox(height: 24),

        _textButton(
          icon: Icons.add,
          label: 'Add List Group',
          onPressed: () {
            setState(() {
              viewModel.showListGroupEN = true;
              if (viewModel.listTypeEN.isEmpty)
                viewModel.listTypeEN = 'Numbered';
            });
          },
        ),

        if (viewModel.showListGroupEN) _listGroupUI(),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: font,
        ),
      ),
    );
  }

  List<Widget> _buildParagraphFields() {
    final sortedControllers = List<TextEditingController>.from(
      viewModel.paragraphControllers,
    );

    sortedControllers.sort((a, b) {
      final aIndex = viewModel.paragraphPositions[a] ?? 0;
      final bIndex = viewModel.paragraphPositions[b] ?? 0;
      return aIndex.compareTo(bIndex);
    });

    return List.generate(sortedControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _label('Paragraph ${index + 1}'),
                if (index > 0)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        final controllerToRemove = sortedControllers[index];
                        viewModel.paragraphControllers.remove(
                          controllerToRemove,
                        );
                        viewModel.paragraphPositions.remove(controllerToRemove);
                        controllerToRemove.dispose();
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            CommonTextField(
              controller: sortedControllers[index],
              hintText: 'Write Paragraph',
              labelText: 'Write Paragraph',
              isFromPassword: false,
              isFromDescription: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _listGroupUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              Colors.grey.shade50,  
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "List Group Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: font,
                    color: Colors.grey.shade700,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: _removeListGroup, 
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            _label('List Type'),
            DropdownButtonFormField<String>(
              value:
                  (viewModel.listTypeEN.toLowerCase() == 'unordered' ||
                      viewModel.listTypeEN == 'Bulleted')
                  ? 'Bulleted'
                  : 'Numbered',
              items: const [
                DropdownMenuItem(value: 'Numbered', child: Text('Numbered')),
                DropdownMenuItem(value: 'Bulleted', child: Text('Bulleted')),
              ],
              onChanged: (value) {
                setState(() => viewModel.listTypeEN = value ?? 'Numbered');
              },
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 12),

            _label('List Heading'),
            TextField(
              controller: viewModel.listHeadingControllerEN,
              decoration: _inputDecoration(hint: 'List heading'),
            ),
            const SizedBox(height: 16),

            ..._buildListItems(),

            _textButton(
              icon: Icons.add,
              label: 'Add Item',
              onPressed: _addListItem,
            ),
          ],
        ),
      ),
    );
  }

  void _removeListGroup() {
    setState(() {
      viewModel.showListGroupEN = false;
      viewModel.listHeadingControllerEN.clear();
      for (var controller in viewModel.listItemControllersEN) {
        controller.dispose();
      }
      viewModel.listItemControllersEN.clear();

      viewModel.listTypeEN = 'Numbered';
    });
  }

  List<Widget> _buildListItems() {
    return List.generate(viewModel.listItemControllersEN.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 0, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Item ${index + 1}'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: viewModel.listItemControllersEN[index],
                    decoration: _inputDecoration(hint: 'List item'),
                  ),
                ),

                if (viewModel.listItemControllersEN.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        viewModel.listItemControllersEN[index].dispose();
                        viewModel.listItemControllersEN.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 16, right: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: font,
        ),
      ),
    );
  }

  Widget _textButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.pink),
      label: Text(
        label,
        style: TextStyle(color: Colors.pink, fontFamily: font),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: font),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  void _addParagraph() {
    setState(() {
      viewModel.paragraphControllers.add(TextEditingController());
    });
  }

  void _addListItem() {
    setState(() {
      viewModel.listItemControllersEN.add(TextEditingController());
    });
  }
}
