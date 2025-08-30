import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:flutter_application_restaurant/view/wallet/charge_page.dart';
import 'package:get/get.dart';
import 'wallet_controller.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WalletController walletController = Get.put(WalletController());
  final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
    //  backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle( fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        backgroundColor:  Colors.grey.shade300,
       // centerTitle: true,
        elevation: 0,
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16.0),
        //     child: Icon(Icons.notifications, color: Colors.white),
        //   )
        // ],
      ),
      body: Obx(() {
        if (walletController.isLoading.value) {
          return const MyLottiLoading();
        }

        if (walletController.errorMessage.isNotEmpty) {
          return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 20),
                      const Text(
                        'Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.red)
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                   onPressed: () {
                      walletController.fetchWalletData();
                        }, // Retry fetch
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                  
                ),
                    ],
                  ),
                );
        }

        if (walletController.wallet.value == null) {
          return const MyLottiNodata();
        }

        final wallet = walletController.wallet.value!;
        return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const SizedBox(height: 30,),
            _buildBalanceCard(wallet.balance),
           const SizedBox(height: 15,),
            _buildTransactionHistory(wallet.transactions),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        elevation: 6,
                      ),
                      onPressed: () {
                        Get.to(ChargeView());
                      },
                      icon: const Icon(Icons.price_change_rounded, size: 25),
                      label: const Text(
                        'charge wallet ', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                      ),),
              ),
            ),
           
          ],
        ),
                  );
      }),
    );
  }}

Widget _buildBalanceCard(double balance) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white54, width: 2), 
        gradient: const LinearGradient(
          colors: [Colors.deepOrange, Colors.orange, Colors.deepOrange],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 40,
              ),
              Transform.rotate(
                angle: 90 * 3.14 / 180,
                child: const Icon(
                  Icons.signal_cellular_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            '${balance.toStringAsFixed(2)} \$',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'current balance ',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTransactionHistory(List<Transaction> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'transactions : ',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          if (transactions.isEmpty)
            const Center(
              child: MyLottiLoading()
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionItem(transaction);
              },
            ),
        ],
      ),
    );
  }

Widget _buildTransactionItem(Transaction transaction) {
  IconData iconData;
  Color iconColor;
  String amountSign;
  if (transaction.type == 'debit') {
    iconData = Icons.arrow_downward; 
    iconColor = Colors.red;

    amountSign = '-';
  } else if (transaction.type == 'administrative_deposit') {
    iconData = Icons.arrow_upward; 
    iconColor = Colors.green;
    amountSign = '+';
  } else {
    iconData = Icons.sync_alt;
    iconColor = Colors.blue;
    amountSign = '';
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Card(
    //  margin: const EdgeInsets.only(bottom: 12),
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData, size: 25, color: iconColor),
                const SizedBox(width: 8),
               const Text(
                  'type: ',
                  style:  TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  transaction.type,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
           const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12,horizontal: 5),
              child: Divider(height: 2,),
            ),
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, size: 25, color: Colors.deepOrange,),
                const SizedBox(width: 8),
                const Text(
                  'amount:   ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$amountSign${transaction.amount} \$',
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12,horizontal: 5),
              child: Divider(height: 2,),
            ),
            Row(
              children: [
                const Icon(Icons.date_range_outlined, size: 25, color: Colors.deepOrange),
                const SizedBox(width: 8),
                const Text(
                  'date: ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Text(
                    transaction.createdAt,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
           const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12,horizontal: 5),
              child: Divider(height: 2,),
            ),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 25, color: Colors.deepOrange),
                const SizedBox(width: 8),
                const Text(
                  'description: ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Text(
                    transaction.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
          ],
        ),
      ),
    ),
  );
}