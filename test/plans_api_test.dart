// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reading_plan/bible/models/plan.dart';
import 'package:reading_plan/bible/models/verse_selection.dart';

void main() {
  test('parse api response', () {
    const response = '''
{
    "day": 1,
    "segments": [
        {
            "content": [
                "ISA.9.1+ISA.9.2+ISA.9.3+ISA.9.4+ISA.9.5+ISA.9.6+ISA.9.7",
                "MIC.5.2+MIC.5.3+MIC.5.4+MIC.5.5",
                "JHN.1.1+JHN.1.2+JHN.1.3+JHN.1.4+JHN.1.5+JHN.1.6+JHN.1.7+JHN.1.8+JHN.1.9+JHN.1.10+JHN.1.11+JHN.1.12+JHN.1.13+JHN.1.14+JHN.1.15+JHN.1.16+JHN.1.17+JHN.1.18"
            ],
            "kind": "reference"
        },
        {
            "content": "Kan du ut fra det du har lest i dag fortelle om en ting Gud sier deg?",
            "kind": "talk-it-over"
        }
    ]
}
''';

    final Map<String, dynamic> parsedResponse = jsonDecode(response);
    final Plan plan = Plan.fromJson(parsedResponse);

    assert(plan.segments.length == 2);
    assert(plan.day == 1);

    () {
      final segment = plan.segments[0] as ReferencePlanSegment;
      assert(segment.content.length == 3);
      assert(segment.kind == 'reference');
    }();
  });
}
