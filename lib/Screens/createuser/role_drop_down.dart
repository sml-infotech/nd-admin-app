import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class CommonDropdownField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final List<dynamic> items;

  final String? selectedValue;
  final List<String>? selectedIds;
  final Function(String?)? onChanged;
  final Function(List<String>)? onMultiChanged;
  final bool isTempleSelection;
  final double paddingSize;

  const CommonDropdownField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.items,
    this.selectedValue,
    this.selectedIds,
    this.onChanged,
    this.onMultiChanged,
    this.isTempleSelection = false,
    required this.paddingSize,
  });

  @override
  State<CommonDropdownField> createState() => _CommonDropdownFieldState();
}

class _CommonDropdownFieldState extends State<CommonDropdownField> {
  String? _currentValue;
  List<String> _selectedIds = [];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.selectedValue;
    _selectedIds = widget.selectedIds ?? [];
  }

  @override
  void didUpdateWidget(CommonDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedValue != oldWidget.selectedValue &&
        widget.selectedValue != _currentValue) {
      setState(() => _currentValue = widget.selectedValue);
    }

    if (widget.selectedIds != oldWidget.selectedIds &&
        widget.selectedIds != _selectedIds) {
      setState(() => _selectedIds = widget.selectedIds ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedNames = widget.items
        .whereType<Map<String, dynamic>>()
        .where((item) => _selectedIds.contains(item['id'].toString()))
        .map((e) => e['name'].toString())
        .join(', ');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
      child: widget.isTempleSelection
          ? InkWell(
              onTap: _showMultiSelectDialog,
              borderRadius: BorderRadius.circular(13),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide:
                        const BorderSide(color: ColorConstant.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide:
                        const BorderSide(color: ColorConstant.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  suffixIcon: const Icon(Icons.arrow_drop_down,
                      color: Colors.black),
                ),
                child: Text(
                  selectedNames.isEmpty ? widget.hintText : selectedNames,
                  style: TextStyle(
                    fontFamily: font,
                    color:
                        selectedNames.isEmpty ? Colors.grey[600] : Colors.black,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            )

          /// ✅ Single Select: Bottom Sheet Dropdown
          : InkWell(
              onTap: _showBottomSheetDropdown,
              borderRadius: BorderRadius.circular(13),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide:
                        const BorderSide(color: ColorConstant.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide:
                        const BorderSide(color: ColorConstant.primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  suffixIcon: const Icon(Icons.arrow_drop_down,
                      color: Colors.black),
                ),
                child: Text(
                  _currentValue ?? widget.hintText,
                  style: TextStyle(
                    fontFamily: font,
                    color: _currentValue == null
                        ? Colors.grey[600]
                        : Colors.black,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
    );
  }

  /// ✅ Single-select Bottom Sheet
  void _showBottomSheetDropdown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.labelText,
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final name = item.toString();
                    final isSelected = _currentValue == name;

                    return ListTile(
                      title: Text(
                        name,
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 15,
                          color: isSelected
                              ? ColorConstant.primaryColor
                              : Colors.black,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check,
                              color: ColorConstant.primaryColor)
                          : null,
                      onTap: () {
                        setState(() => _currentValue = name);
                        widget.onChanged?.call(name);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// ✅ Multi-select dialog (unchanged)
  void _showMultiSelectDialog() async {
    final List<String> tempSelectedIds = List.from(_selectedIds);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(widget.labelText, style: TextStyle(fontFamily: font)),
              content: SingleChildScrollView(
                child: Column(
                  children: widget.items
                      .whereType<Map<String, dynamic>>()
                      .map((item) {
                    final id = item['id'].toString();
                    final name = item['name'].toString();
                    final isSelected = tempSelectedIds.contains(id);

                    return CheckboxListTile(
                      activeColor: ColorConstant.buttonColor,
                      title: Text(name, style: TextStyle(fontFamily: font)),
                      value: isSelected,
                      onChanged: (checked) {
                        setDialogState(() {
                          if (checked == true) {
                            tempSelectedIds.add(id);
                          } else {
                            tempSelectedIds.remove(id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontFamily: font, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIds = tempSelectedIds;
                    });
                    widget.onMultiChanged?.call(_selectedIds);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primaryColor,
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(fontFamily: font, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
