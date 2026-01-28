import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_detail_res_model.dart';
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

  Future<CreateBlogResponse> updateBlog(BlogModel request ) async {
    try {
      final data = await apiService.put(
        UrlConstant.updateBlog,
        request.toJson(),
      );

      print("✅ updateBlog API Response >>>> $data");
      return CreateBlogResponse.fromJson(data);
    } catch (e) {
      print("❌ updateBlog Update service failed: $e");
      throw Exception('Temple update API failed: $e');
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

      final uri = Uri.parse(
        UrlConstant.getBlogs,
      ).replace(queryParameters: query);

      print('Fetching blogs: $uri');

      final data = await apiService.get(uri.toString());
      return BlogResponse.fromJson(data);
    } catch (e) {
      print("Blog service failed: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<BlogDetailsResponse> getBlogDetail({
    required String slug_name,
    required String language,
  }) async {
    try {
      final uri = Uri.parse(
        "${UrlConstant.blogDetails}?slug=$slug_name&language=kn",
      );

      print('Fetching blog details: $uri');

      final data = await apiService.get(uri.toString());

      if (data == null || data.isEmpty) {
        throw Exception("API returned null or empty for blog detail");
      }

      return BlogDetailsResponse.fromJson(data);
    } catch (e) {
      print("Blog service failed: $e");
      throw Exception('API failed: $e');
    }
  }
}
