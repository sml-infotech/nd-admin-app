import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class BenefitInputWidget extends StatefulWidget {
  final dynamic viewmodel; // Can be CreatePujaViewmodel
  final bool isUpdateMode;

  const BenefitInputWidget({
    super.key,
    required this.viewmodel,
    this.isUpdateMode = false,
  });

  @override
  State<BenefitInputWidget> createState() => _BenefitInputWidgetState();
}

class _BenefitInputWidgetState extends State<BenefitInputWidget> {
  @override
  void initState() {
    super.initState();

    // Prefill existing benefits if in update mode
    if (widget.isUpdateMode && widget.viewmodel.prefilledBenefits != null) {
      widget.viewmodel.benefits =
          List<String>.from(widget.viewmodel.prefilledBenefits);
    }
  }

  void addBenefit() {
    String text = widget.viewmodel.benefitController.text.trim();
    if (text.isNotEmpty) {
      widget.viewmodel.addBenefit(text);
      widget.viewmodel.benefitController.clear();
      setState(() {});
    }
  }

  void removeBenefit(int index) {
    widget.viewmodel.removeBenefit(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewmodel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: vm.benefitController,
          decoration: InputDecoration(
            hintText: "Add Benefit",
            labelText: "Add Benefit",
            labelStyle: TextStyle(fontFamily: font, color: Colors.grey),
            hintStyle: TextStyle(fontFamily: font, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: ColorConstant.primaryColor),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: addBenefit,
            ),
          ),
          onSubmitted: (_) => addBenefit(),
        ),
        if (vm.benefits.isNotEmpty) ...[const SizedBox(height: 15)],
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            vm.benefits.length,
            (index) => Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                       vm.benefits[index].description,
                      style: TextStyle(fontFamily: font, color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => removeBenefit(index),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
