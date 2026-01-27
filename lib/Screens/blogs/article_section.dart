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

        _sectionHeader('Article Section (English) 1'),
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
          onPressed: () => setState(() => viewModel.showListGroupEN = true),
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
    return List.generate(viewModel.paragraphControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Paragraph ${index + 1}'),
            CommonTextField(
              controller: viewModel.paragraphControllers[index],
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
              value: viewModel.listTypeEN,
              items: const [
                DropdownMenuItem(value: 'Numbered', child: Text('Numbered')),
                DropdownMenuItem(value: 'Bulleted', child: Text('Bulleted')),
              ],
              onChanged: (value) {
                setState(() => viewModel.listTypeEN = value!);
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
