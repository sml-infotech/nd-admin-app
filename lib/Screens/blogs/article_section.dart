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

        // Paragraph Fields
        ..._buildParagraphFields(),

        // Add Paragraph Button
        _textButton(
          icon: Icons.add,
          label: 'Add Paragraph',
          onPressed: _addParagraph,
        ),

        const SizedBox(height: 24),

        // Add List Group Button
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

        // List Group UI
        if (viewModel.showListGroupEN) _listGroupUI(),

        const SizedBox(height: 16),
      ],
    );
  }

  // Section Header
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
    // Sort paragraphs by position first
    final sortedControllers = List<TextEditingController>.from(
      viewModel.paragraphControllers,
    );

    sortedControllers.sort((a, b) {
      // If you stored the position in a map, use that, otherwise fallback to index
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
            _label('Paragraph ${index + 1}'),
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

  // List Group UI
  Widget _listGroupUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('List Type'),
            DropdownButtonFormField<String>(
              value: viewModel.listTypeEN.isNotEmpty
                  ? viewModel.listTypeEN
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

            // List Items
            ..._buildListItems(),

            // Add List Item Button
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

  // Build List Items
  List<Widget> _buildListItems() {
    return List.generate(viewModel.listItemControllersEN.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Item ${index + 1}'),
            TextField(
              controller: viewModel.listItemControllersEN[index],
              decoration: _inputDecoration(hint: 'List item'),
            ),
          ],
        ),
      );
    });
  }

  // Label Widget
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

  // Text Button
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

  // Input Decoration
  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: font),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  // Add Paragraph
  void _addParagraph() {
    setState(() {
      viewModel.paragraphControllers.add(TextEditingController());
    });
  }

  // Add List Item
  void _addListItem() {
    setState(() {
      viewModel.listItemControllersEN.add(TextEditingController());
    });
  }
}
