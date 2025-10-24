import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:provider/provider.dart';

class TempleInputWidget extends StatelessWidget {
  const TempleInputWidget({super.key});

  void _addTemple(BuildContext context) {
    final vm = Provider.of<AddTempleViewmodel>(context, listen: false);
    String text = vm.templeController.text.trim();

    if (text.isNotEmpty) {
      vm.addTemple(text); 
      vm.templeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTempleViewmodel>(
      builder: (context, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Temple input text field
            TextField(
              controller: vm.templeController,
              decoration: InputDecoration(
                hintText: "Enter temple",
                labelText: "Enter temple",
                labelStyle:
                     TextStyle(fontFamily: font, color: Colors.black),
                hintStyle:
                     TextStyle(fontFamily: font, color: Colors.black),
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
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTemple(context),
                ),
              ),
              onSubmitted: (_) => _addTemple(context),
            ),

            const SizedBox(height: 15),

            // Temple chips/cards
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                vm.temples.length,
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
                          vm.temples[index],
                          style:  TextStyle(
                            fontFamily: font,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => vm.removeTemple(index),
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
      },
    );
  }
}
