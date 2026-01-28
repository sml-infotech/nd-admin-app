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
  late CreateBlogViewmodel viewModel;

  final List<TextEditingController> _paragraphControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (final controller in _paragraphControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<CreateBlogViewmodel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _blogFields(),
            _sectionFields(),
            _paragraphSection(),
            _listGroupSection(),
            const SizedBox(height: 24),
            _createButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _blogFields() {
    return Column(
      children: [
        CommonTextField(
          hintText: 'ಬ್ಲಾಗ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          labelText: 'ಬ್ಲಾಗ್ ಹೆಸರು',
          controller: viewModel.blogNameKN,
          isFromPassword: false,
        ),
        const SizedBox(height: 16),
        CommonTextField(
          hintText: 'ವಿವರಣೆಯನ್ನು ನಮೂದಿಸಿ',
          labelText: 'ಬ್ಲಾಗ್ ವಿವರಣೆ',
          controller: viewModel.blogDescriptionKN,
          isFromPassword: false,
          isFromDescription: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _sectionFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: CommonTextField(
        hintText: 'ವಿಭಾಗದ ಶೀರ್ಷಿಕೆ',
        labelText: 'ವಿಭಾಗದ ಶೀರ್ಷಿಕೆ',
        controller: viewModel.sectionTitleKn,
        isFromPassword: false,
      ),
    );
  }

  Widget _paragraphSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        ...List.generate(_paragraphControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _paragraphControllers[index],
              maxLines: 4,
              decoration: _inputDecoration(hint: 'ಪ್ಯಾರಾಗ್ರಾಫ್ ಬರೆಯಿರಿ'),
            ),
          );
        }),
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: TextButton.icon(
            onPressed: _addParagraph,
            icon: const Icon(Icons.add, color: Colors.pink),
            label: const Text(
              'ಪ್ಯಾರಾಗ್ರಾಫ್ ಸೇರಿಸಿ',
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listGroupSection() {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () => setState(() => viewModel.showListGroupKN = true),
          icon: const Icon(Icons.add, color: Colors.pink),
          label: const Text(
            'ಪಟ್ಟಿ ಗುಂಪು ಸೇರಿಸಿ',
            style: TextStyle(color: Colors.pink),
          ),
        ),
        if (viewModel.showListGroupKN) _listGroupContainer(),
      ],
    );
  }

  Widget _listGroupContainer() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            value: viewModel.listTypeKN,
            decoration: _inputDecoration(),
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
            onChanged: (value) => setState(() => viewModel.listTypeKN = value!),
          ),
          const SizedBox(height: 12),
          _label('ಪಟ್ಟಿ ಶೀರ್ಷಿಕೆ'),
          TextField(
            controller: viewModel.listHeadingControllerKN,
            decoration: _inputDecoration(hint: 'ಪಟ್ಟಿ ಶೀರ್ಷಿಕೆ'),
          ),
          const SizedBox(height: 16),
          ...List.generate(viewModel.listItemControllersKN.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: viewModel.listItemControllersKN[index],
                decoration: _inputDecoration(hint: 'ಪಟ್ಟಿ ಐಟಂ'),
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
    );
  }

  Widget _createButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _onCreatePressed,
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

  void _onCreatePressed() {
  FocusScope.of(context).unfocus();
  if (viewModel.blogNameKN.text.isEmpty ||
      viewModel.blogDescriptionKN.text.isEmpty ||
      viewModel.sectionTitleKn.text.isEmpty) {
    Fluttertoast.showToast(msg: 'Fill the fields');
    return;
  }
  viewModel.saveFullSectionKN(_paragraphControllers);
  viewModel.addBlog();
  Navigator.of(context, rootNavigator: true).pop();
}


  void _addParagraph() {
    setState(() {
      _paragraphControllers.add(TextEditingController());
    });
  }

  void _addListItem() {
    setState(() {
      viewModel.listItemControllersKN.add(TextEditingController());
    });
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
