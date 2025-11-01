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
    print("_selectedIds${_selectedIds}");
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
    // ✅ Display joined temple names for multi-select, or selected value for normal
    final displayText = widget.isTempleSelection
        ? _selectedIds.isEmpty
              ? widget.hintText
              : widget.items
                    .whereType<Map<String, dynamic>>() // ensure proper type
                    .where(
                      (item) => _selectedIds.contains(item['id'].toString()),
                    )
                    .map((e) => e['name'].toString())
                    .join(', ')
        : _currentValue ?? widget.hintText;

    return SizedBox(
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.paddingSize),
        child: GestureDetector(
          onTap: widget.isTempleSelection ? _showMultiSelectDialog : null,
          child: AbsorbPointer(
            absorbing:
                widget.isTempleSelection, // disable dropdown tap for multi
            child: DropdownButtonFormField<String>(
              value: widget.isTempleSelection ? null : _currentValue,
              onChanged: widget.isTempleSelection
                  ? null
                  : (value) {
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
              // ✅ For normal dropdowns only
              items: !widget.isTempleSelection
                  ? widget.items
                        .whereType<String>() // safety check
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e, style: TextStyle(fontFamily: font)),
                          ),
                        )
                        .toList()
                  : [
                     DropdownMenuItem<String>(
  value: '',
  enabled: false,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.8, // prevent overflow
    ),
    child: Text(
      displayText,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: false,
      style: TextStyle(fontFamily: font),
    ),
  ),
),
                    ],
            ),
          ),
        ),
      ),
    );
  }

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
                child: ListBody(
                  children: widget.items.whereType<Map<String, dynamic>>().map((
                    item,
                  ) {
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
