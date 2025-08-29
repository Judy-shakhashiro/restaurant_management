import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLottiHumb extends StatelessWidget {
  const MyLottiHumb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotti/hamburger (3).json',
        fit: BoxFit.cover,
        width: 250,
        height: 250,
      ),
    );
  }
}
class MyLottiCat extends StatelessWidget {
  const MyLottiCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotti/cat.json',
        fit: BoxFit.cover,
        width: 150,
        height: 160,
      ),
    );
  }
}
class MyLottiNodata extends StatelessWidget {
  const MyLottiNodata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotti/sad.json',
        fit: BoxFit.cover,
        width: 250,
        height: 250,
      ),
    );
  }
}