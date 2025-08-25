import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/static/routes.dart';
import '../model/cart_model.dart';
import '../model/dish_details_model.dart';


class DishDetailsService{
  Future<DishDetails> getDishDetails(int id ) async{
    final url=Uri.parse('${Linkapi.backUrl}/products/$id');
    final response=await http.get(url,
    headers: {'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',},
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


