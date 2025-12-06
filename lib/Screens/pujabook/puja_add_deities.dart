import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';

class DeitiesDropdown extends StatefulWidget {
  final List<String> items; // All deities list
  final List<String> selectedItems; // Currently selected deities
  final ValueChanged<List<String>> onSelectionChanged;
  final double paddingSize;

  const DeitiesDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.paddingSize = 16,
  });

  @override
  State<DeitiesDropdown> createState() => _DeitiesDropdownState();
}

class _DeitiesDropdownState extends State<DeitiesDropdown> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(covariant DeitiesDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      _selectedItems = List.from(widget.selectedItems);
    }
  }

  Future<void> _showDeitiesBottomSheet() async {
    List<String> tempSelected = List.from(_selectedItems);
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  barWidget(),
                  selectDietiesText(),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  if (widget.items.isEmpty) emptyText(),
                  if (widget.items.isNotEmpty)
                    deitiesCheckbox(tempSelected, setBottomSheetState),
                  if (widget.items.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        okButton(tempSelected),
                        const SizedBox(height: 8),
                        cancelButton(),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget barWidget() {
    return Container(
      height: 5,
      width: 40,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget emptyText() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        AppLocalizations.of(context)!.selectDeities,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: font, color: Colors.black87, fontSize: 14),
      ),
    );
  }

  Widget selectDietiesText() {
    return Text(
      "Select Deities",
      style: TextStyle(
        fontFamily: font,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget deitiesCheckbox(
    List<String> tempSelected,
    Function setBottomSheetState,
  ) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final deity = widget.items[index];
          final isSelected = tempSelected.contains(deity);

          return CheckboxListTile(
            value: isSelected,
            title: Text(
              deity,
              style: TextStyle(fontFamily: font, color: Colors.black),
            ),
            activeColor: ColorConstant.primaryColor,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) {
              setBottomSheetState(() {
                if (checked == true) {
                  tempSelected.add(deity);
                } else {
                  tempSelected.remove(deity);
                }
              });
            },
          );
        },
      ),
    );
  }

  Widget okButton(List<String> tempSelected) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedItems = List.from(tempSelected);
          });
          widget.onSelectionChanged(_selectedItems);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "OK",
          style: TextStyle(
            fontFamily: font,
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget cancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ColorConstant.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            fontFamily: font,
            color: ColorConstant.primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            "Deities",
            style: TextStyle(
              fontFamily: font,
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Dropdown-style display
          GestureDetector(
            onTap: _showDeitiesBottomSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _selectedItems.isEmpty
                          ? [
                              Text(
                                "Select Deities",
                                style: TextStyle(
                                  fontFamily: font,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ]
                          : _selectedItems
                                .map(
                                  (d) => Chip(
                                    label: Text(
                                      d,
                                      style: TextStyle(fontFamily: font),
                                    ),
                                    backgroundColor: ColorConstant.primaryColor
                                        .withOpacity(0.2),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedItems.remove(d);
                                        widget.onSelectionChanged(
                                          _selectedItems,
                                        );
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ColorConstant.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
