import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../core/static/routes.dart';

class Address{
  final int id;
   final  String latitude;
   final  String longitude;
   final String name;
   final String label;
   final String city;
   final String area;
   final String street;
   final  String? mobile;
   final String? additionalDetails;
   final bool is_deliverable;
      Address( {
        required this.id,
        required this.latitude,
   required this.longitude,
   required this.name,
   required this.label,
   required this.city,
   required this.area,
   required this.street,
   this.mobile,
   this.additionalDetails,
       required this.is_deliverable, });
      factory Address.fromJson(Map<String,dynamic> json){
        return Address(id: json['id'], latitude:json['latitude'] , longitude: json['longitude'], name: json['name'], label: json['label'], city: json['city'], area: json['area'], street: json['street'], is_deliverable: json['is_deliverable'],additionalDetails: json['additional_details']);
  }

}
class AddressInShort{
  final int id;
  final String name;
  final String city;
  final String area;
  final String street;

  AddressInShort( {
    required this.id,
    required this.name,
    required this.city,
    required this.area,
    required this.street,
  });
  factory AddressInShort.fromJson(Map<String,dynamic> json){
    return AddressInShort(id: json['id'], name: json['name'], city: json['city'], area: json['area'], street: json['street']);

  }

}
class AddressService extends GetxService {
  Future<List<AddressInShort>?> getAddresses() async{
    final url = Uri.parse('${Linkapi.backUrl}/addresses');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if ({token}.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token}';
    }
    try{
      final response=await http.get(url,headers:headers);
      if(response.statusCode==200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic>addressesJson=parsed['addresses'];
        final ans=addressesJson.map((e)=>AddressInShort.fromJson(e)).toList();
        print('success getting user addressessssssssss');
       return ans;
      }
      else{
        print('error fetching user addresses');
        return null;
      }

    }
    catch(e){
      print('exception in fetching user addresses');
    }
    return null;

  }
  Future<Address?> getAddressById(int id) async{
    final url = Uri.parse('${Linkapi.backUrl}/addresses/$id');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if ({token}.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token}';
    }
    try{
      final response=await http.get(url,headers:headers);
      if(response.statusCode==200) {
        final parsed = jsonDecode(response.body);
        final addressesJson=parsed['address'];
        final ans=Address.fromJson(addressesJson);
        print('success got address');
        return ans;
      }
      else{
        print('error fetching  address');
        return null;
      }

    }
    catch(e){
      print('exception in fetching address $e');
    }
    print('exception in fetching address');
    return null;

  }
  Future<bool?> deleteAddress(int id) async{
    final url = Uri.parse('${Linkapi.backUrl}/addresses/$id');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if (token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token}';
    }
    try{
      final response=await http.delete(url,headers:headers);
      if(response.statusCode==200) {
        print('address deleted successfully');
     return true;
      }
      else{
        print('error deleting address');
        return null;
      }

    }
    catch(e){
      print('exception deleting address');
      Get.snackbar(
        'Error',
        'Error deleting address: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return null;

  }
  Future<bool> postAddress({
    required double latitude,
    required double longitude,
    required String name,
    required String label,
    required String city,
    required String area,
    required String street,
    String? mobile,
    String? additionalDetails,

  }) async {
    final url = Uri.parse('${Linkapi.backUrl}/addresses');

    final Map<String, dynamic> data = {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'label': label,
      'city': city,
      'area': area,
      'street': street,
      'additional_details': additionalDetails,
    };

    if (mobile != null && mobile.isNotEmpty) {
      data['mobile'] = mobile;
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if ({token}.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token}';
    }

    // Convert the map to URL-encoded string for the body
    final String encodedBody = data.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value.toString())}')
        .join('&');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: encodedBody, // Use the encoded body
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Address posted successfully: ${response.body}');
        return true;
      } else {
        print('Failed to post address. Status: ${response.statusCode}, Body: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to save address: ${response.statusCode} - ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error posting address: $e');
      Get.snackbar(
        'Error',
        'Error posting address: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}