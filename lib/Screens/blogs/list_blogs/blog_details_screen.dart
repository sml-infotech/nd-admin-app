import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/blogs/list_blogs/list_blogs_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/blogs_argument.dart';
import 'package:nammadaiva_dashboard/l10n/app_localizations.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_detail_res_model.dart';
import 'package:provider/provider.dart';
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
    viewmodel.fetchDetail(widget.slug_name.slug_name);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListBlogsViewmodel>(
      builder: (context, vm, _) {
        final blogDetail = vm.blogDetails;

        if (vm.isLoading || blogDetail == null) {
          return Scaffold(body: _buildShimmer());
        }

        BlogTranslationDetails? translation;
        if (blogDetail.translations != null &&
            blogDetail.translations!.isNotEmpty) {
          translation = blogDetail.translations!.firstWhere(
            (t) => t.languageCode == 'kn',
            orElse: () => blogDetail.translations!.first,
          );
        } else {
          translation = null;
        }

        final title = translation?.name ?? blogDetail.name;
        final description = translation?.description ?? blogDetail.description;
        final sections =
            translation?.articleSections ?? blogDetail.articleSections;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorConstant.buttonColor,
            elevation: 0,
            title: nammaDaivaAppBar(),
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

  Widget nammaDaivaAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.blogs_details,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const SizedBox(width: 48),
        const Spacer(),
      ],
    );
  }

  Widget _buildSection(ArticleSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: AppTextStyles.templeNameDetailsStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Paragraphs
        ...section.paragraphs.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              p.paragraph,
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          ),
        ),

        // Lists
        ...section.lists.map((list) => _buildList(list)),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildList(SectionList list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (list.heading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              list.heading,
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        ...list.points.asMap().entries.map((entry) {
          final index = entry.key;
          final point = entry.value;
          final prefix = list.listType == 'ordered' ? '${index + 1}. ' : '• ';
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Text(
              '$prefix${point.point}',
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          );
        }).toList(),
      ],
    );
  }
}
