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

    // Sync single select
    if (widget.selectedValue != oldWidget.selectedValue &&
        widget.selectedValue != _currentValue) {
      setState(() => _currentValue = widget.selectedValue);
    }

    // Sync multi select
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
          : DropdownButtonFormField<String>(
              isExpanded: true,
              value: _currentValue,
              onChanged: (value) {
                setState(() => _currentValue = value);
                widget.onChanged?.call(value);
              },
              style: TextStyle(
                fontFamily: font,
                color: Colors.black,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                labelStyle: TextStyle(fontFamily: font, color: Colors.black),
                hintStyle: TextStyle(fontFamily: font, color: Colors.black),
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
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              dropdownColor: Colors.white,
              items: widget.items
                  .whereType<String>()
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e, style: TextStyle(fontFamily: font)),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  /// Multi-select popup
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
