import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/static/routes.dart';
import '../model/dish.dart';
import '../model/favorite_model.dart';
import 'api_service_base.dart';


class ApiService extends ApiBase {

  @override
  Future<List<Tag>> fetchTags() async {
    final resp = await http.get(
      Uri.parse('${Linkapi.backUrl}/tags'),
      headers: {'Accept': 'application/json',
      'Content-Type':'application/json'},
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      List<Tag> result = (data['tags'] as List)
          .map((e) => Tag.fromJson(e))
          .toList();
      return result;
    } else {
      print(resp.body);
      print(resp.statusCode);
      print(resp.reasonPhrase);
      throw Exception('Failed to load tags');
    }
  }


  @override
  Future<List<Dish>> fetchDishesByCategory(int categoryId, List<int> t) async {
    String tags = '';
    for (int i = 0; i < t.length; i++) {
      tags += 'tag_ids[]=${t[i]}&';
    }

    final url = '${Linkapi.backUrl}/categories/$categoryId/products?$tags';
    print(url);

    final resp = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final parsed = jsonDecode(resp.body);
      final List<dynamic> productsJson = parsed['products'];

      List<Dish> dishes =
      productsJson.map((e) => Dish.fromJson(e)).toList();

      print("dishes $dishes");
      print(t);
      return dishes;
    } else {
      throw Exception('Failed to load dishes');
    }
  }

}
