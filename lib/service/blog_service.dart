import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_list_response.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_response.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class BlogService {
  final HttpApiService apiService = HttpApiService();

  Future<CreateBlogResponse> createBlog(BlogModel request) async {
    try {
      final loginRequest = request;

      final data = await apiService.post(
        UrlConstant.create_blog,
        request.toJson(),
      );

      return CreateBlogResponse.fromJson(data);
    } catch (e) {
      print("Auth service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

Future<BlogResponse> getBlogs({
  required int page,
  required int limit,
  String? search,
  required String language,
}) async {
  try {
    final query = {
      "page": page.toString(),
      "limit": limit.toString(),
      "language": language,
      if (search != null && search.isNotEmpty) "search": search,
    };

    final uri = Uri.parse(UrlConstant.getBlogs).replace(queryParameters: query);

    print('Fetching blogs: $uri');

    final data = await apiService.get(uri.toString());
    return BlogResponse.fromJson(data);
  } catch (e) {
    print("Blog service failed: $e");
    throw Exception('API failed: $e');
  }
}

}
