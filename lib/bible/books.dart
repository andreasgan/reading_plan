class Book {
  final String name;
  final String usfm;

  Book({required this.name, required this.usfm});
}

Book getBook(String version, String book) {
  return books[version]!.firstWhere((b) => b.usfm == book);
}

Map<String, List<Book>> books = {
  "NB": [
    Book(name: "1 Mosebok", usfm: "GEN"),
    Book(name: "2 Mosebok", usfm: "EXO"),
    Book(name: "3 Mosebok", usfm: "LEV"),
    Book(name: "4 Mosebok", usfm: "NUM"),
    Book(name: "5 Mosebok", usfm: "DEU"),
    Book(name: "Josva", usfm: "JOS"),
    Book(name: "Dommerne", usfm: "JDG"),
    Book(name: "Rut", usfm: "RUT"),
    Book(name: "1 Samuel", usfm: "1SA"),
    Book(name: "2 Samuel", usfm: "2SA"),
    Book(name: "1 Kongebok", usfm: "1KI"),
    Book(name: "2 Kongebok", usfm: "2KI"),
    Book(name: "1 Krønikebok", usfm: "1CH"),
    Book(name: "2 Krønikebok", usfm: "2CH"),
    Book(name: "Esra", usfm: "EZR"),
    Book(name: "Nehemja", usfm: "NEH"),
    Book(name: "Ester", usfm: "EST"),
    Book(name: "Job", usfm: "JOB"),
    Book(name: "Salmene", usfm: "PSA"),
    Book(name: "Salomos Ordspråk", usfm: "PRO"),
    Book(name: "Forkynneren", usfm: "ECC"),
    Book(name: "Høysangen", usfm: "SNG"),
    Book(name: "Jesaja", usfm: "ISA"),
    Book(name: "Jeremia", usfm: "JER"),
    Book(name: "Klagesangene", usfm: "LAM"),
    Book(name: "Esekiel", usfm: "EZK"),
    Book(name: "Daniel", usfm: "DAN"),
    Book(name: "Hosea", usfm: "HOS"),
    Book(name: "Joel", usfm: "JOL"),
    Book(name: "Amos", usfm: "AMO"),
    Book(name: "Obadja", usfm: "OBA"),
    Book(name: "Jona", usfm: "JON"),
    Book(name: "Mika", usfm: "MIC"),
    Book(name: "Nahum", usfm: "NAM"),
    Book(name: "Habakkuk", usfm: "HAB"),
    Book(name: "Sefanja", usfm: "ZEP"),
    Book(name: "Haggai", usfm: "HAG"),
    Book(name: "Sakarja", usfm: "ZEC"),
    Book(name: "Malaki", usfm: "MAL"),
    Book(name: "Matteus", usfm: "MAT"),
    Book(name: "Markus", usfm: "MRK"),
    Book(name: "Lukas", usfm: "LUK"),
    Book(name: "Johannes", usfm: "JHN"),
    Book(name: "Apostlenes gjerninger", usfm: "ACT"),
    Book(name: "Romerne", usfm: "ROM"),
    Book(name: "1 Korinter", usfm: "1CO"),
    Book(name: "2 Korinter", usfm: "2CO"),
    Book(name: "Galaterne", usfm: "GAL"),
    Book(name: "Efeserne", usfm: "EPH"),
    Book(name: "Filipperne", usfm: "PHP"),
    Book(name: "Kolosserne", usfm: "COL"),
    Book(name: "1 Tessaloniker", usfm: "1TH"),
    Book(name: "2 Tessaloniker", usfm: "2TH"),
    Book(name: "1 Timoteus", usfm: "1TI"),
    Book(name: "2 Timoteus", usfm: "2TI"),
    Book(name: "Titus", usfm: "TIT"),
    Book(name: "Filemon", usfm: "PHM"),
    Book(name: "Hebreerne", usfm: "HEB"),
    Book(name: "Jakob", usfm: "JAS"),
    Book(name: "1 Peter", usfm: "1PE"),
    Book(name: "2 Peter", usfm: "2PE"),
    Book(name: "1 Johannes", usfm: "1JN"),
    Book(name: "2 Johannes", usfm: "2JN"),
    Book(name: "3 Johannes", usfm: "3JN"),
    Book(name: "Judas", usfm: "JUD"),
    Book(name: "Åpenbaringen", usfm: "REV")
  ]
};
