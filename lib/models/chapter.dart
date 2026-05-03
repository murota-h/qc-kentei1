import 'package:flutter/material.dart';
import 'content_block.dart';

class Chapter {
  final int number;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final List<ContentBlock> blocks;
  const Chapter({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.blocks,
  });
}
