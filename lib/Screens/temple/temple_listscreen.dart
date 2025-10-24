import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<TempleViewModel>(context, listen: false);
    viewModel.fetchTemples();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !viewModel.isLoadingMore &&
          viewModel.hasMore) {
        viewModel.fetchTemples();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TempleViewModel>(builder: (context, viewModel, _) {
      return Scaffold(
        backgroundColor: ColorConstant.buttonColor,
        appBar: AppBar(
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          centerTitle: true,
          title:_buildAppBar(),
        ),
        body: 
        
        
        viewModel.isLoading && viewModel.temples.isEmpty
            ? _buildShimmer()
            : Column(
                children: [
                  Expanded(
                    child:Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
                      controller: _scrollController,
                      itemCount: viewModel.temples.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) =>
                          _templeCard(viewModel.temples[index]),
                    ),
                  )),
                  if (viewModel.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
      );
    });
  }
Widget _buildAppBar() {
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
        const SizedBox(width: 48),
      ],
    );
  }
  Widget _templeCard(Temple temple) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                  child: false
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
                Expanded(
                  child: Column(
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${StringConstant.address} ${temple.address}, ${temple.pincode}",
              style: AppTextStyles.templeNameDetailsAddressStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child:
    
    ListView.separated(
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
    ));
  }
}
