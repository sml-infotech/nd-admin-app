import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/list_blogs/list_blogs_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/blogs_argument.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_detail_res_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class BlogDetailsScreen extends StatefulWidget {
  final BlogsArgument slug_name;

  const BlogDetailsScreen({super.key, required this.slug_name});

  @override
  State<BlogDetailsScreen> createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  late ListBlogsViewmodel viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<ListBlogsViewmodel>(context, listen: false);
    _loadUserData();
    viewmodel.fetchDetail(widget.slug_name.slug_name);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      viewmodel.language = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListBlogsViewmodel>(
      builder: (context, vm, _) {
        final blogDetail = vm.blogDetails;

        if (vm.isLoading || blogDetail == null) {
          return Scaffold(body: _buildShimmer());
        }

        Translation? translation;

        if (blogDetail.translations != null &&
            blogDetail.translations!.isNotEmpty) {
          translation = blogDetail.translations!.firstWhere(
            (t) => t.languageCode == 'kn',
            orElse: () => blogDetail.translations!.first,
          );
        } else {
          translation = null;
        }

        final title = viewmodel.language == "kn"
            ? translation?.name ?? blogDetail.name
            : blogDetail.name;
        final description = viewmodel.language == "kn"
            ? translation?.description ?? blogDetail.description
            : blogDetail.description;
        final sections = viewmodel.language == "kn"
            ? translation?.articleSections ?? blogDetail.articleSections
            : blogDetail.articleSections;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorConstant.buttonColor,
            elevation: 0,
            title: nammaDaivaAppBar(
              title: AppLocalizations.of(context)!.blogs_details,
              onEdit: () {
                // Navigate to create blog screen
                Navigator.pushNamed(
                  context,
                  StringsRoute.create_blog,
                  arguments: BlogDetails(
                    name: blogDetail.name,
                    description: blogDetail.description,
                    image: blogDetail.image,
                    articleSections: blogDetail.articleSections,
                    translations: blogDetail.translations,
                    id: blogDetail.id,
                    slug: blogDetail.slug,
                    isActive: true,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blogDetail.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      blogDetail.image,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),

                Text(
                  title,
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(description, style: AppTextStyles.templeNameDetailsStyle),
                const SizedBox(height: 24),

                if (sections != null)
                  ...sections.map((section) => _buildSection(section)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget nammaDaivaAppBar({required String title, VoidCallback? onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(title, style: AppTextStyles.appBarTitleStyle),
        const Spacer(),
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
      ],
    );
  }

  Widget _buildSection(ArticleSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((section.title ?? '').isNotEmpty)
          Text(
            section.title!,
            style: AppTextStyles.templeNameDetailsStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

        const SizedBox(height: 8),

        /// ---------- PARAGRAPHS ----------
        if (section.paragraphs != null && section.paragraphs!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: section.paragraphs!.map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  p.text ?? '',
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              );
            }).toList(),
          ),

        /// ---------- LISTS ----------
        if (section.lists != null && section.lists!.isNotEmpty)
          Column(
            children: section.lists!.map((list) => _buildList(list)).toList(),
          ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildList(SectionList list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((list.heading ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Text(
              list.heading!,
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        if (list.points != null && list.points!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list.points!.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;

              final prefix = list.listType == 'Numbered'
                  ? '${index + 1}. '
                  : '• ';

              return Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 6),
                child: Text(
                  '$prefix${point.text ?? ''}',
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
