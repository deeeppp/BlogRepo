import 'dart:convert';
import 'package:http/http.dart' as http;
import './Blog.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Blog>> fetchBlogs() async {
    final response = await http.get(Uri.parse('$baseUrl/postt/'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((blog) => Blog.fromJson(blog)).toList();
    } else {
      throw Exception("Failed to load blogs");
    }
  }

  Future<void> deleteBlog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/postt/delete/$id/'));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete blog");
    }
  }
}
