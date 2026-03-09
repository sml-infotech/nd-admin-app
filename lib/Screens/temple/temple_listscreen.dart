import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:shimmer/shimmer.dart';

class TempleScreen extends StatefulWidget {
  const TempleScreen({super.key});

  @override
  State<TempleScreen> createState() => _TempleScreenState();
}

class _TempleScreenState extends State<TempleScreen> {
  final ScrollController _scrollController = ScrollController();

  TempleViewModel? viewModel;
  String? token;
  String? role;
  String? language;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    viewModel?.searchController.text = "";

    viewModel?.reset();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('authToken');
      role = prefs.getString('userRole');
      language = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TempleViewModel>(
      builder: (context, model, _) {
        viewModel = model;

        if (!_scrollController.hasListeners) {
          _scrollController.addListener(() {
            final atBottom =
                _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200;

            if (atBottom && !model.isLoadingMore && model.hasMore) {
              model.fetchTemples();
            }
          });
        }

        if (!model.searchController.hasListeners) {
          model.searchController.addListener(() {
            model.onSearchChanged();
          });
        }

        return FocusDetector(
          onFocusGained: () async {
            viewModel?.isLoading = true;
            await model.resetAndFetch();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ColorConstant.buttonColor,
              elevation: 0,
              centerTitle: true,
              title: _buildAppBar(context),
            ),
            body: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  templeSearchBar(),

                  const SizedBox(height: 10),

                  if (model.isLoading && model.temples.isEmpty)
                    Expanded(child: _buildShimmer()),

                  if (!model.isLoading && model.temples.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noTemplesFound,
                          style: TextStyle(fontFamily: font),
                        ),
                      ),
                    ),

                  if (model.temples.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount:
                            model.temples.length +
                            (model.isLoadingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          if (index == model.temples.length) {
                            return _loadingIndicator();
                          }
                          return _templeCard(model.temples[index]);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),

        Expanded(
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.temples,
              style: AppTextStyles.appBarTitleStyle,
            ),
          ),
        ),

        // if (role == "Super Admin")
        //   IconButton(
        //     onPressed: () async {
        //       viewModel!.searchController.text = "";
        //       await Navigator.pushNamed(context, StringsRoute.addTempleScreen);
        //       await viewModel?.reset();
        //     },
        //     icon: const Icon(Icons.add, color: Colors.white),
        //   )
        // else
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _templeCard(Temple temple) {
    return GestureDetector(
      onTap: () {
        final locale = Localizations.localeOf(context).languageCode;

        final translation =
            (locale == 'kn' &&
                temple.translations != null &&
                temple.translations!.isNotEmpty)
            ? temple.translations!.first
            : null;
        Navigator.pushNamed(
          context,
          StringsRoute.templeDetail,
          arguments: TempleDetailsArguments(
            name: translation?.name ?? temple.name,
            address: translation?.address ?? temple.address,
            city: translation?.city ?? temple.city,
            state: translation?.state ?? temple.state,
            pincode: temple.pincode,
            architecture: translation?.architecture ?? temple.architecture,
            phoneNumber: temple.phoneNumber,
            email: temple.email,
            description: translation?.description ?? temple.description,
            deities: translation?.deities ?? temple.deities ?? [],
            images: temple.images ?? [],
            templeId: temple.id,
            translations: temple.translations ?? [],
            google_map_link: temple.googleMapLink,
          ),
        );
        viewModel?.reset();
      },
      child: Card(
        elevation: 6,
        color: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: temple.images?.isNotEmpty ?? false
                      ? Image.network(
                          temple.images!.first,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          ImageStrings.loginImage,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Text(
                    language == "kn"
                        ? temple.translations?.first?.name ?? temple.name
                        : temple.name,
                    style: AppTextStyles.templeNameTitleBoldStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: ColorConstant.buttonColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${language == "kn" ? temple.translations?.first?.village_name ?? temple.village_name : temple.village_name}, ${language == "kn" ? temple.translations?.first?.taluk ?? temple.taluk : temple.taluk}",
                          style: AppTextStyles.templeNameDetailsStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.temple_hindu,
                        size: 18,
                        color: ColorConstant.buttonColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          language == "kn"
                              ? formatDeities(
                                  temple.translations?.first?.deities,
                                )
                              : formatDeities(temple.deities),

                          maxLines: 2,
                          style: AppTextStyles.templeNameDetailsStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 18,
                        color: ColorConstant.buttonColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${language == "kn" ? temple.translations?.first?.address ?? temple.address : temple.address}, ${temple.pincode}",
                          style: AppTextStyles.templeNameDetailsStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingIndicator() => const Center(
    child: CircularProgressIndicator(color: ColorConstant.buttonColor),
  );

  Widget _buildShimmer() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  String formatDeities(List<String>? deities) {
    if (deities == null || deities.isEmpty) return "-";
    return deities.where((e) => e.trim().isNotEmpty).join(", ");
  }

  Widget templeSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
        controller: viewModel?.searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchTemples,
          hintStyle: TextStyle(fontFamily: font),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
        ),
      ),
    );
  }
}
