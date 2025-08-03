import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/static/config.dart';
import '../model/cart_model.dart';


class DishDetailsService{
  Future<DishDetails> getDishDetails(int id ) async{
    final url=Uri.parse('${Linkapi.backUrl}/products/$id');
    final response=await http.get(url,
    headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {

    final parsed = jsonDecode(response.body);
    DishDetails dish = DishDetails.fromJson(parsed);
      print('suuuuuuuuuu');
    return dish;
    } else {
      throw Exception('error fetching dish details');
      print('hhhhh');

    }
  }

  }


