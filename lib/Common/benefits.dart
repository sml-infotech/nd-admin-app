import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';

class BenefitInputWidget extends StatefulWidget {
  final dynamic viewmodel; // Can be CreatePujaViewmodel
  final bool isUpdateMode;
  final bool isKannada;

  const BenefitInputWidget({
    super.key,
    required this.viewmodel,
    this.isUpdateMode = false,
    this.isKannada = true,
  });

  @override
  State<BenefitInputWidget> createState() => _BenefitInputWidgetState();
}

class _BenefitInputWidgetState extends State<BenefitInputWidget> {
  void addBenefit() {
    final controller = widget.isKannada
        ? widget.viewmodel.benefitControllerKn
        : widget.viewmodel.benefitController;

    final text = controller.text.trim();

    if (text.isNotEmpty) {
      widget.viewmodel.addBenefit(text, isKannada: widget.isKannada);
      controller.clear();
    }
  }

  void removeBenefit(int index) {
    widget.viewmodel.removeBenefit(index, isKannada: widget.isKannada);
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewmodel;

    final benefits = widget.isKannada ? vm.benefitsKn : vm.benefitsEn;

    final controller = widget.isKannada
        ? vm.benefitControllerKn
        : vm.benefitController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.add_benefit,
            labelText: AppLocalizations.of(context)!.add_benefit,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: addBenefit,
            ),
          ),
          onSubmitted: (_) => addBenefit(),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            benefits.length,
            (index) => Chip(
              label: Text(benefits[index]),
              onDeleted: () => removeBenefit(index),
            ),
          ),
        ),
      ],
    );
  }
}
