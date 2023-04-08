import '../books.dart';

abstract class VerseSelection {
  abstract final String book;
  abstract final int chapter;

  String toLocalizedString(String bibleVersion);
}

class VerseWholeChapter extends VerseSelection {
  @override
  final String book;
  @override
  final int chapter;

  VerseWholeChapter({
    required this.book,
    required this.chapter,
  });

  @override
  String toLocalizedString(String bibleVersion) {
    final bookName = getBook(bibleVersion, book).name;
    return '$bookName $chapter';
  }
}

class VerseSingle extends VerseSelection {
  @override
  final String book;
  @override
  final int chapter;
  final int verse;

  VerseSingle({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  @override
  String toLocalizedString(String bibleVersion) {
    final bookName = getBook(bibleVersion, book).name;
    return '$bookName $chapter:$verse';
  }
}

class VerseRange extends VerseSelection {
  @override
  final String book;
  @override
  final int chapter;
  final int from;
  final int to;

  VerseRange({
    required this.book,
    required this.chapter,
    required this.from,
    required this.to,
  });

  @override
  String toLocalizedString(String bibleVersion) {
    final bookName = getBook(bibleVersion, book).name;
    return '$bookName $chapter:$from-$to';
  }
}

List<VerseSelection> parseVerseSelection(String verseSelection) {
  final verses = verseSelection.split("+");
  final result = <VerseSelection>[];

  for (final verse in verses) {
    final parts = verse.split(".");
    final book = parts[0];
    final chapter = int.parse(parts[1]);
    final verseNumber = parts.length > 2 ? int.parse(parts[2]) : null;

    if (result.isNotEmpty && verseNumber != null) {
      final lastVerse = result.last;

      if (lastVerse is VerseSingle &&
          lastVerse.book == book &&
          lastVerse.chapter == chapter &&
          lastVerse.verse == verseNumber - 1) {
        result.removeLast();
        result.add(VerseRange(
          book: book,
          chapter: chapter,
          from: lastVerse.verse,
          to: verseNumber,
        ));
        continue;
      } else if (lastVerse is VerseRange &&
          lastVerse.book == book &&
          lastVerse.chapter == chapter &&
          lastVerse.to == verseNumber - 1) {
        result.removeLast();
        result.add(VerseRange(
          book: book,
          chapter: chapter,
          from: lastVerse.from,
          to: verseNumber,
        ));
        continue;
      }
    }

    if (verseNumber != null) {
      result.add(VerseSingle(book: book, chapter: chapter, verse: verseNumber));
      continue;
    }
    result.add(VerseWholeChapter(book: book, chapter: chapter));
  }

  return result;
}
