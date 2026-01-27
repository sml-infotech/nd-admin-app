import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/article_section_kannadam.dart';
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
  late CreateBlogViewmodel viewmodel;

  

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreateBlogViewmodel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 10, 16, 0),
          child: Text(
            'Article Section (English) 1',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: font,
            ),
          ),
        ),
        const SizedBox(height: 16),

        _label('Section Title'),
        CommonTextField(
          hintText: AppLocalizations.of(context)!.sectionTitle,
          labelText: 'Section Title',
          isFromPassword: false,
          controller: viewmodel.sectionTitle,
        ),

        const SizedBox(height: 24),

        ...List.generate(viewmodel.paragraphControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Paragraph ${index + 1}'),

                CommonTextField(
                  controller: viewmodel.paragraphControllers[index],
                  hintText: "Write Paragraph",
                  labelText: 'Write Paragraph',
                  isFromPassword: false,
                  isFromDescription: true,
                ),
              ],
            ),
          );
        }),

        TextButton.icon(
          onPressed: _addParagraph,
          icon: const Icon(Icons.add, color: Colors.pink),
          label: Text(
            'Add Paragraph',
            style: TextStyle(color: Colors.pink, fontFamily: font),
          ),
        ),

        const SizedBox(height: 24),

        TextButton.icon(
          onPressed: () {
            setState(() => viewmodel.showListGroupEN = true);
          },
          icon: const Icon(Icons.add, color: Colors.pink),
          label: Text(
            'Add List Group',
            style: TextStyle(color: Colors.pink, fontFamily: font),
          ),
        ),

        if (viewmodel.showListGroupEN) ...[
          const SizedBox(height: 12),
          Container(
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
                  style: TextStyle(fontFamily: font, color: Colors.black),
                  value: viewmodel.listTypeEN,
                  items: const [
                    DropdownMenuItem(
                      value: 'Numbered',
                      child: Text('Numbered'),
                    ),
                    DropdownMenuItem(
                      value: 'Bulleted',
                      child: Text('Bulleted'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => viewmodel.listTypeEN = value!);
                  },
                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 12),

                _label('List Heading'),
                TextField(
                  controller: viewmodel.listHeadingControllerEN,
                  decoration: _inputDecoration(hint: 'List heading'),
                ),

                const SizedBox(height: 16),

                ...List.generate(viewmodel.listItemControllersEN.length, (
                  index,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Item ${index + 1}'),
                        TextField(
                          controller: viewmodel.listItemControllersEN[index],
                          decoration: _inputDecoration(hint: 'List item'),
                        ),
                      ],
                    ),
                  );
                }),

                TextButton.icon(
                  onPressed: _addListItem,
                  icon: const Icon(Icons.add, color: Colors.pink),
                  label: Text(
                    'Add Item',
                    style: TextStyle(color: Colors.pink, fontFamily: font),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Create Button
      ],
    );
  }

  // Add Paragraph logic
  void _addParagraph() {
    setState(() {
      viewmodel.paragraphControllers.add(TextEditingController());
    });
  }

  // Add List Item logic
  void _addListItem() {
    setState(() {
      viewmodel.listItemControllersEN.add(TextEditingController());
    });
  }

  // Display SnackBar
  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Helper for labels
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

  // Helper for InputDecoration
  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: font),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
