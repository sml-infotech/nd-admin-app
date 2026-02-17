import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/create_blog_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/list_blogs/list_blogs_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/blogs_argument.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ListBlogs extends StatefulWidget {
  const ListBlogs({super.key});

  @override
  State<ListBlogs> createState() => _ListBlogsState();
}

class _ListBlogsState extends State<ListBlogs> {
  late ListBlogsViewmodel viewmodel;
  ScrollController _scrollController = ScrollController();
  String language = "kn";

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language') ?? 'en';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !viewmodel.isLoadingMore &&
          viewmodel.hasMore &&
          !viewmodel.isLoading) {
        viewmodel.fetchBlogs();
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
    viewmodel = Provider.of<ListBlogsViewmodel>(context);
    return FocusDetector(
      onFocusGained: () {
        viewmodel.fetchBlogs();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.buttonColor,
          elevation: 0,
          title: nammaDaivaAppBar(),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),

            // 1️⃣ Initial loading shimmer
            if (viewmodel.isLoading && viewmodel.blogs.isEmpty)
              Expanded(child: _buildShimmer())
            // 2️⃣ Blog list (with pagination loader)
            else if (viewmodel.blogs.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount:
                      viewmodel.blogs.length +
                      (viewmodel.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    if (index == viewmodel.blogs.length) {
                      return _loadingIndicator();
                    }
                    return blogCard(viewmodel.blogs[index]);
                  },
                ),
              )
            // 3️⃣ Empty state
            else
              Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_blogs_found,
                    style: TextStyle(fontFamily: font),
                  ),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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

  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            viewmodel.reset();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.blogs,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            viewmodel.reset();

            Navigator.pushNamed(context, StringsRoute.create_blog);
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget blogCard(Blog blog) {
    return GestureDetector(
      onTap: () {
        viewmodel.reset();

        Navigator.pushNamed(
          context,
          StringsRoute.blog_details,
          arguments: BlogsArgument(slug_name: blog.slug),
        );
      },
      child: Card(
        elevation: 6,
        color: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: blog.image?.isNotEmpty ?? false
                      ? Image.network(
                          blog.image!,
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
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 18,
                        color: ColorConstant.buttonColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          language == 'kn' &&
                                  blog.translations != null &&
                                  blog.translations!.isNotEmpty
                              ? blog.translations!.first.name
                              : blog.name,
                          maxLines: 3,
                          style: AppTextStyles.templeNameDetailsStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance,
                        size: 18,
                        color: ColorConstant.buttonColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          language == 'kn' &&
                                  blog.translations != null &&
                                  blog.translations!.isNotEmpty
                              ? blog.translations!.first.description
                              : blog.description,
                          maxLines: 3,
                          style: AppTextStyles.templeNameDetailsStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
