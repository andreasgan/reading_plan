// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reading_plan/bible/models/verse_selection.dart';

import 'package:reading_plan/main.dart';

void main() {
  group('verse range parser', () {
    test('range and single', () {
      final result = parseVerseSelection(
          "ISA.9.1+ISA.9.2+ISA.9.3+ISA.9.4+ISA.9.5+ISA.9.6+EZR.100.10");
      // Verify that our counter has incremented.
      assert(result.length == 2);

      () {
        final part1 = result[0] as VerseRange;
        assert(part1.book == 'ISA' && part1.chapter == 9,
            part1.from == 1 && part1.to == 6);
      }();

      () {
        final part2 = result[1] as VerseSingle;
        assert(
            part2.book == 'EZR' && part2.chapter == 100 && part2.verse == 10);
      }();
    });
    test('chapter', () {
      final result = parseVerseSelection("JOH.6");
      // Verify that our counter has incremented.
      assert(result.length == 1);

      () {
        final part1 = result[0] as VerseWholeChapter;
        assert(part1.book == 'JOH' && part1.chapter == 6);
      }();
    });
  });
}
