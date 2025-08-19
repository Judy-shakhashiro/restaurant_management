import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/static/routes.dart';
import '../model/category_model.dart';


class CategoryService extends GetConnect {
  Future<List<CategoryR>> fetchCategories() async {
    print(('${Linkapi.backUrl}/categories'));
    final response = await http.get(Uri.parse('${Linkapi.backUrl}/categories'),
    headers: {'Accept': 'application/json'});
    final parsed=jsonDecode(response.body);
    if (parsed['status'] == true) {
      List data = parsed['categories'];
      return data.map((item) => CategoryR.fromJson(item)).toList();
    } else {

      throw Exception("error fetching categories");
    }
  }
}
