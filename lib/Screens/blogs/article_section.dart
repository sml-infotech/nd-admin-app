import 'package:flutter/material.dart';

class ArticleSectionUI extends StatelessWidget {
  const ArticleSectionUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const Text(
              'Article Section (English) 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            /// Section Title
            _label('Section Title'),
            _textField(hint: 'Section title'),

            const SizedBox(height: 12),

            /// Add Paragraph
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.pink),
              label: const Text(
                'Add Paragraph',
                style: TextStyle(color: Colors.pink),
              ),
            ),

            _label('Paragraph 1'),
            _textField(
              hint: 'Write paragraph...',
              maxLines: 4,
              trailing: Icons.delete_outline,
            ),

            const SizedBox(height: 16),

            /// Add List Group
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.pink),
              label: const Text(
                'Add List Group',
                style: TextStyle(color: Colors.pink),
              ),
            ),

            const SizedBox(height: 8),

            /// List Group Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('List Group'),

                  /// List Type Dropdown
                  _label('List Type'),
                  DropdownButtonFormField<String>(
                    value: 'Numbered',
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
                    onChanged: (value) {},
                    decoration: _inputDecoration(),
                  ),

                  const SizedBox(height: 12),

                  /// List Heading
                  _label('List Heading'),
                  _textField(hint: 'List heading'),

                  const SizedBox(height: 12),

                  /// Add Item
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Colors.pink),
                    label: const Text(
                      'Add Item',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Label widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// TextField widget
  Widget _textField({
    required String hint,
    int maxLines = 1,
    IconData? trailing,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: _inputDecoration(hint: hint, trailing: trailing),
    );
  }

  /// Common InputDecoration
  InputDecoration _inputDecoration({String? hint, IconData? trailing}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: trailing != null ? Icon(trailing, color: Colors.red) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.pink),
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
