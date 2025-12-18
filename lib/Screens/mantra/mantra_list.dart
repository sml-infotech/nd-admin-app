import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/mantra/mantra_list_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/update_mantra.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MantraList extends StatefulWidget {
  const MantraList({super.key});

  @override
  State<MantraList> createState() => _MantraListState();
}

class _MantraListState extends State<MantraList> {
  late MantraListViewmodel viewmodel;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_paginationListener);
  }

  @override
  void dispose() {
    super.dispose();
    viewmodel.reset();
  }

  void _paginationListener() {
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 300 &&
        !viewmodel.isLoadingMore &&
        viewmodel.hasMore) {
      viewmodel.fetchMantra();
    }
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<MantraListViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: appBarForListMantra(),
        automaticallyImplyLeading: false,
      ),

      body: FocusDetector(
        onFocusGained: () {
          viewmodel.fetchMantra(reset: true);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: viewmodel.isLoading
              ? mantraShimmer()
              : ListView.builder(
                  controller: _controller,
                  padding: const EdgeInsets.only(top: 0),
                  itemCount:
                      viewmodel.mantras.length +
                      (viewmodel.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == viewmodel.mantras.length) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorConstant.buttonColor,
                          ),
                        ),
                      );
                    }

                    final item = viewmodel.mantras[index];

                    return mantraItem(
                      imageUrl: item.imageUrl ?? "",
                      title: item.mantraName ?? "",
                      mantra: item.mantra ?? "",
                      mantraId: item.id ?? "",
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget appBarForListMantra() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.mantra,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              StringsRoute.createMantra,
              arguments: UpdateMantra(
                mantraName: "",
                mantra: "",
                image: "",
                mantraID: "",
              ),
            );
            viewmodel.reset();
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget mantraItem({
    required String imageUrl,
    required String title,
    required String mantra,
    required String mantraId,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // <-- FIXED
            children: [
              roundedImage(imageUrl),
              const SizedBox(width: 15),
              titleAndContent(
                title,
                mantra,
                context,
                imageUrl,
                mantraId,
                viewmodel,
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
      ],
    );
  }
}

Widget roundedImage(String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(40),
    child: Image.network(
      imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.white),
      ),
    ),
  );
}

Widget titleAndContent(
  String title,
  String mantra,
  BuildContext context,
  String image,
  String mantraId,
  MantraListViewmodel viewmodel,
) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: font,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  StringsRoute.createMantra,
                  arguments: UpdateMantra(
                    mantraName: title,
                    mantra: mantra,
                    image: image,
                    mantraID: mantraId,
                  ),
                );
                viewmodel.reset();
              },
              icon: Icon(Icons.edit),
              iconSize: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          mantra,
          style: TextStyle(
            fontSize: 14,
            fontFamily: font,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

Widget mantraShimmer() {
  return ListView.builder(
    itemCount: 8,
    itemBuilder: (_, __) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: 120, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 14, width: 200, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
