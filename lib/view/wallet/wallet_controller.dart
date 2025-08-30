import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// نماذج البيانات
class Wallet {
  final double balance;
  final List<Transaction> transactions;

  Wallet({required this.balance, required this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    var transactionsList = json['transactions'] as List;
    List<Transaction> transactions =
        transactionsList.map((i) => Transaction.fromJson(i)).toList();
    return Wallet(
      balance: double.parse(json['balance']),
      transactions: transactions,
    );
  }
}

class Transaction {
  final String type;
  final String amount;
  final String description;
  final String createdAt;

  Transaction({
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}

class WalletController extends GetxController {
  final Rx<Wallet?> wallet = Rx<Wallet?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final String apiUrl = '${Linkapi.backUrl}/wallet';
  final String userToken = '$token'; 

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken', 
        },
      );

      print('نجاااح Response from backend: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        if (decodedData['status'] == true) {
          final walletData = decodedData['wallet'];
          wallet.value = Wallet.fromJson(walletData);
        } else {
          errorMessage.value = decodedData['message'] ?? 'فشل في جلب البيانات.';
        }
      } else {
        errorMessage.value = 'خطأ في الخادم: ${response.body}';
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع. يرجى المحاولة لاحقًا.';
    } finally {
      isLoading.value = false;
    }
  }
}