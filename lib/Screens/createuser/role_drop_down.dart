import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';

class CommonDropdownField extends StatefulWidget {
  final String hintText;
  final String labelText;

  /// For single-select: pass List<String>
  /// For multi-select (temple): pass List<Map<String, dynamic>> with keys 'id' and 'name'
  final List<dynamic> items;

  final String? selectedValue;
  final List<String>? selectedIds; // ✅ for multi-select
  final Function(String?)? onChanged;
  final Function(List<String>)? onMultiChanged; // ✅ callback for multi-select
  final bool isTempleSelection; // ✅ enables multi-select dialog
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
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() => _currentValue = widget.selectedValue);
    }
    if (widget.selectedIds != oldWidget.selectedIds) {
      setState(() => _selectedIds = widget.selectedIds ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.isTempleSelection
        ? _selectedIds.isEmpty
            ? widget.hintText
            : widget.items
                .whereType<Map<String, dynamic>>()
                .where((item) => _selectedIds.contains(item['id'].toString()))
                .map((e) => e['name'].toString())
                .join(', ')
        : _currentValue ?? widget.hintText;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
      child: widget.isTempleSelection
          ? GestureDetector(
              onTap: _showMultiSelectDialog,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle:
                      TextStyle(fontFamily: font, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 18,
                  ),
                ),
                child: Text(
                  displayText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: font,
                    color: _selectedIds.isEmpty
                        ? Colors.grey
                        : Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          : DropdownButtonFormField<String>(
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
                  borderSide: const BorderSide(
                    color: ColorConstant.primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: ColorConstant.primaryColor,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
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

  /// ✅ Multi-select dialog
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
                  mainAxisSize: MainAxisSize.min,
                  children:
                      widget.items.whereType<Map<String, dynamic>>().map((item) {
                    final id = item['id'].toString();
                    final name = item['name'].toString();
                    final isSelected = tempSelectedIds.contains(id);

                    return CheckboxListTile(
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
                  child: const Text("Cancel"),
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
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
