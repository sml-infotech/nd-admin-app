import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class DeitiesDropdown extends StatefulWidget {
  final List<String> items; // all deities
  final List<String> selectedItems; // selected deities
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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  void _toggleDropdown() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deities",
            style: TextStyle(
              fontFamily: font,
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13), 
                border: Border.all(color: ColorConstant.primaryColor),
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
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: ColorConstant.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: _isExpanded ? 180 : 0,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: ColorConstant.primaryColor),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final deity = widget.items[index];
                  final isSelected = _selectedItems.contains(deity);
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(
                      deity,
                      style: TextStyle(fontFamily: font, color: Colors.black),
                    ),
                    activeColor: ColorConstant.primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedItems.add(deity);
                        } else {
                          _selectedItems.remove(deity);
                        }
                        widget.onSelectionChanged(_selectedItems);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
