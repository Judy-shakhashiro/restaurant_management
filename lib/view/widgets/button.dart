import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final VoidCallback onPressed;
  final BorderRadius? borderRadius;
  final Key? key;

  Button({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.deepOrange,
    this.foregroundColor = Colors.white,
    this.elevation = 6,
    this.borderRadius,
    this.key,
  });

  FloatingActionButton build() {
    return FloatingActionButton.extended(
      key: key,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(50),
      ),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Georgia',fontSize: 20),
      ),
      icon: Icon(icon),
    );
  }
}