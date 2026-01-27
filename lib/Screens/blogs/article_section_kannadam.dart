import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreateBlogScreenKannada extends StatefulWidget {
  const CreateBlogScreenKannada({super.key});

  @override
  State<CreateBlogScreenKannada> createState() =>
      _CreateBlogScreenKannadaState();
}

class _CreateBlogScreenKannadaState extends State<CreateBlogScreenKannada> {
  late CreateBlogViewmodel viewmodel;
  List<TextEditingController> _paragraphControllers = [TextEditingController()];

  @override
  void dispose() {
    for (final c in _paragraphControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<CreateBlogViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                hintText: 'ಬ್ಲಾಗ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ (Kannada)',
                labelText: 'ಬ್ಲಾಗ್ ಹೆಸರು',
                isFromPassword: false,
                controller: viewmodel.blogNameKN,
              ),

              const SizedBox(height: 16),

              // Blog Description in Kannada
              CommonTextField(
                hintText: 'ವಿವರಣೆಯನ್ನು ನಮೂದಿಸಿ (Kannada)',
                labelText: 'ಬ್ಲಾಗ್ ವಿವರಣೆ',
                isFromPassword: false,
                isFromDescription: true,
                controller: viewmodel.blogDescriptionKN,
              ),
              const SizedBox(height: 16),

              CommonTextField(
                hintText: 'ವಿಭಾಗದ ಶೀರ್ಷಿಕೆ ನಮೂದಿಸಿ',
                labelText: 'ವಿಭಾಗದ ಶೀರ್ಷಿಕೆ',
                isFromPassword: false,
                controller: viewmodel.sectionTitleKn,
              ),
              const SizedBox(height: 16),

              // Paragraphs
              ...List.generate(_paragraphControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _paragraphControllers[index],
                        maxLines: 4,
                        decoration: _inputDecoration(
                          hint: 'ಪ್ಯಾರಾಗ್ರಾಫ್ ಬರೆಯಿರಿ...',
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Add Paragraph Button
              TextButton.icon(
                onPressed: _addParagraph,
                icon: const Icon(Icons.add, color: Colors.pink),
                label: const Text(
                  'ಪ್ಯಾರಾಗ್ರಾಫ್ ಸೇರಿಸಿ',
                  style: TextStyle(color: Colors.pink),
                ),
              ),

              const SizedBox(height: 24),

              // Add List Group
              TextButton.icon(
                onPressed: () {
                  setState(() => viewmodel.showListGroupKN = true);
                },
                icon: const Icon(Icons.add, color: Colors.pink),
                label: const Text(
                  'ಪಟ್ಟಿ ಗುಂಪು ಸೇರಿಸಿ',
                  style: TextStyle(color: Colors.pink),
                ),
              ),

              if (viewmodel.showListGroupKN) ...[
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
                      _label('ಪಟ್ಟಿ ಪ್ರಕಾರ'),
                      DropdownButtonFormField<String>(
                        value: viewmodel.listTypeKN,
                        items: const [
                          DropdownMenuItem(
                            value: 'Numbered',
                            child: Text('ಸಂಖ್ಯೆಗಳ ಪಟ್ಟಿಗೆ'),
                          ),
                          DropdownMenuItem(
                            value: 'Bulleted',
                            child: Text('ಬುಲೆಟ್ ಪಟ್ಟಿಗೆ'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => viewmodel.listTypeKN = value!);
                        },
                        decoration: _inputDecoration(),
                      ),

                      const SizedBox(height: 12),
                      _label('ಪಟ್ಟಿ ಶೀರ್ಷಿಕೆ'),
                      TextField(
                        controller: viewmodel.listHeadingControllerKN,
                        decoration: _inputDecoration(hint: 'ಪಟ್ಟಿ ಶೀರ್ಷಿಕೆ'),
                      ),

                      const SizedBox(height: 16),

                      // List items
                      ...List.generate(viewmodel.listItemControllersKN.length, (
                        index,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('ಐಟಂ ${index + 1}'),
                              TextField(
                                controller:
                                    viewmodel.listItemControllersKN[index],
                                decoration: _inputDecoration(hint: 'ಪಟ್ಟಿ ಐಟಂ'),
                              ),
                            ],
                          ),
                        );
                      }),

                      TextButton.icon(
                        onPressed: _addListItem,
                        icon: const Icon(Icons.add, color: Colors.pink),
                        label: const Text(
                          'ಐಟಂ ಸೇರಿಸಿ',
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              createUserButton(viewmodel, context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget createUserButton(CreateBlogViewmodel viewModel, navContext) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (viewModel.blogNameKN.text.isNotEmpty &&
                viewModel.blogDescriptionKN.text.isNotEmpty &&
                viewModel.sectionTitleKn.text.isNotEmpty) {
              _addArticleSection();
              Navigator.of(context, rootNavigator: true).pop();
            } else {
              Fluttertoast.showToast(msg: "Fill the Fields");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.create,
            style: AppTextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }

  void _addParagraph() {
    setState(() {
      _paragraphControllers.add(TextEditingController());
    });
  }

  void _addListItem() {
    setState(() {
      viewmodel.listItemControllersKN.add(TextEditingController());
    });
  }

  void _addArticleSection() {
    List<String> paragraphs = _paragraphControllers
        .map((controller) => controller.text.trim())
        .toList();
    viewmodel.saveFullSectionKN(_paragraphControllers);
    viewmodel.addBlog();
    viewmodel.notifyListeners();
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
