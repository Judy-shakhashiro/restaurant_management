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


class MyLottiLoading extends StatelessWidget {
  const MyLottiLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotti/Potato.json',
        fit: BoxFit.cover,
        width: 200,
        height: 200,
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
        'assets/lotti/Empty State.json',
        fit: BoxFit.cover,
        width: 250,
        height: 250,
      ),
    );
  }
}

class MyLottiFavorite extends StatelessWidget {
  const MyLottiFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotti/favorite.json',
        fit: BoxFit.cover,
        width: 250,
        height: 250,
      ),
    );
  }
}

class MyLottiMario extends StatelessWidget {
  const MyLottiMario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotti/mario.json',
        fit: BoxFit.cover,
        width: 250,
        height: 250,
      ),
    );
  }
}