import '../models/chapter.dart';
import 'ch1_data.dart';
import 'ch2_data.dart';
import 'ch3_data.dart';
import 'ch4_data.dart';
import 'ch5_data.dart';
import 'ch6_data.dart';
import 'ch7_data.dart';
import 'ch8_data.dart';
import 'ch9_data.dart';

const List<Chapter> allChapters = [
  chapter1,
  chapter2,
  chapter3,
  chapter4,
  chapter5,
  chapter6,
  chapter7,
  chapter8,
  chapter9,
];

Chapter? findChapter(int number) {
  try {
    return allChapters.firstWhere((c) => c.number == number);
  } catch (_) {
    return null;
  }
}

String chapterLabel(Chapter c) => 'Chapter ${c.number}';
