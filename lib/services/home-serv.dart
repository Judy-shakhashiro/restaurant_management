import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/cat_model.dart';
import '../model/home_page_model.dart';

class HomeServ {
  Future<HomeModel> fetchHomeData() async {
    final response = await http.get(Uri.parse('$backUrl/products/home'));

    if (response.statusCode == 200) {
      return HomeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error');
    }
  }

Future<CategoriesResponse> fetchCategories() async {
  final response = await http.get(Uri.parse('$backUrl/categories'));

  if (response.statusCode == 200) {
    return CategoriesResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('فشل في تحميل التصنيفات');
  }
}}

