import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/static/routes.dart';
import '../model/dish.dart';

class SearchService {
  Future<List<Dish>>fetchSearchResults(String text,List<int> t) async {
  String tags = '';
  for (int i = 0; i < t.length; i++) {
    tags += 'tag_ids[]=${t[i]}&';
  }
  final uri = Uri.parse('${Linkapi.backUrl}/products/search?searched_text=$text&$tags');


  final resp = await http.get(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',},
  );
print(resp.body);
  if (resp.statusCode == 200) {
    final parsed = jsonDecode(resp.body);
    final List<dynamic> productsJson = parsed['products'];

    List<Dish> dishes =
    productsJson.map((e) => Dish.fromJson(e)).toList();

    print("dishes $dishes");
    print(t);
    return dishes;
  } else {
    return [];
  }
}}