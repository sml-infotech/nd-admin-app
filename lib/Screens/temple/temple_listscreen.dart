import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    viewModel?.reset();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('authToken');
      role = prefs.getString('userRole');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TempleViewModel>(
      builder: (context, model, _) {
        viewModel = model;

        // Infinite scroll listener — only attach once
        if (!_scrollController.hasListeners) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels >=
                    _scrollController.position.maxScrollExtent - 200 &&
                !model.isLoadingMore &&
                model.hasMore) {
              model.fetchTemples();
            }
          });
        }

        return FocusDetector(
          onFocusGained: () async {
            // 🧹 Reset data and fetch fresh temples when coming back
            await viewModel?.resetAndFetch();
          },
          child: Scaffold(
            backgroundColor: ColorConstant.buttonColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ColorConstant.buttonColor,
              elevation: 0,
              centerTitle: true,
              title: _buildAppBar(context),
            ),
            body: model.isLoading && model.temples.isEmpty
                ? _buildShimmer()
                : Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            controller: _scrollController,
                            itemCount: model.temples.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) =>
                                _templeCard(model.temples[index]),
                          ),
                        ),
                        if (model.isLoadingMore)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _loadingIndicator(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(StringConstant.temple, style: AppTextStyles.appBarTitleStyle),
        const Spacer(),
        if (role == "Super Admin")
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, StringsRoute.addTempleScreen);
              // 🔁 When you return from add screen, refetch fresh list
              await viewModel?.resetAndFetch();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
      ],
    );
  }

  Widget _templeCard(Temple temple) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          StringsRoute.templeDetail,
          arguments: TempleDetailsArguments(
            name: temple.name,
            address: temple.address,
            city: temple.city,
            state: temple.state,
            pincode: temple.pincode,
            architecture: temple.architecture,
            phoneNumber: temple.phoneNumber,
            email: temple.email,
            description: temple.description,
            deities: temple.deities ?? [],
            images: temple.images ?? [],
            templeId: temple.id,
          ),
        );
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: temple.images?.isNotEmpty ?? false
                        ? Image.network(
                            temple.images!.first,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            ImageStrings.loginImage,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _templeDetails(temple)),
                ],
              ),
              const SizedBox(height: 8),
              _templeAddress(temple),
            ],
          ),
        ),
      ),
    );
  }

  Widget _templeDetails(Temple temple) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          temple.name,
          style: AppTextStyles.templeNameTitleBoldStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          "${StringConstant.city} ${temple.city}",
          style: AppTextStyles.templeNameDetailsStyle,
        ),
        Text(
          "${StringConstant.state} ${temple.state}",
          style: AppTextStyles.templeNameDetailsStyle,
        ),
        Text(
          "${StringConstant.architecture} ${temple.architecture}",
          style: AppTextStyles.templeNameDetailsStyle,
        ),
      ],
    );
  }

  Widget _templeAddress(Temple temple) {
    return Text(
      "${StringConstant.address} ${temple.address}, ${temple.pincode}",
      style: AppTextStyles.templeNameDetailsAddressStyle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.all(16),
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
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
