import 'package:reading_plan/bible/models/verse_selection.dart';

class Plan {
  late int day;
  List<PlanSegment> segments;
  Plan({required this.day, required this.segments});

  factory Plan.fromJson(Map<String, dynamic> json) {
    final segments = List<Map<String, dynamic>>.from(json['segments']);
    final parsedSegments =
        segments.map((segment) => PlanSegment.fromJson(segment)).toList();
    return Plan(day: json['day'], segments: parsedSegments);
  }
}

class PlanSegment {
  PlanSegment();
  factory PlanSegment.fromJson(Map<String, dynamic> json) {
    List<List<VerseSelection>>? parsedVerses;
    if (json['kind'] == 'reference') {
      final verseLists = List<String>.from(json['content']);
      parsedVerses =
          verseLists.map((content) => parseVerseSelection(content)).toList();
      return ReferencePlanSegment(
        kind: json['kind'],
        content: json['content'],
        verseSelections: parsedVerses,
      );
    }
    return PlanSegment();
  }
}

class ReferencePlanSegment implements PlanSegment {
  String kind = 'reference';
  List<dynamic> content;
  List<List<VerseSelection>> verseSelections;
  ReferencePlanSegment({
    required this.kind,
    required this.content,
    required this.verseSelections,
  });
}
