import 'package:flutter/material.dart';

class Sending {
  final String message;
  final IconData icon;

  const Sending({required this.message, required this.icon});
}

const List<Sending> sending = [
  Sending(message: 'Sending...!', icon: Icons.hourglass_top),
  Sending(message: 'Send Message', icon: Icons.send),
];
