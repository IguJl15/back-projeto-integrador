import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../../term/domain/models/term.dart';
import '../models/news.dart';
import 'scrap_algorithm.dart';

class IfpiScrapAlgorithm implements ScrapAlgorithm {
  final Uri initPage = Uri.parse("https://www.ifpi.edu.br/ultimas-noticias");

  @override
  Future<List<News>> scrap() async {
    final response = await http.get(initPage);

    Document document = parser.parse(response.body);

    List<Element> noticias = document.querySelectorAll('div.tileItem');

    final news = await Future.wait<News>(noticias.map((e) => _getNewFromElement(e)));

    return news;
  }

  Future<News> _getNewFromElement(Element noticia) async {
    String title = noticia.querySelector('h2.tileHeadline')!.text.trim();
    String url = noticia.querySelector('a')!.attributes['href']!;

    String dateTimeInformationDiv = noticia.querySelector('.documentByLine')!.text.trim();
    //                      Groups  (  2  ) (  3  ) (  4  )       (  6  ) (  7  )
    final dateTimeRegex = RegExp(r"((\d{2})/(\d{2})/(\d{4}))[\W]*((\d{2})h(\d{2}))?");

    final [day, month, year, hour, minute] = dateTimeRegex
        .firstMatch(dateTimeInformationDiv)!
        .groups([2, 3, 4, 6, 7])
        .map<int?>((e) => int.tryParse(e ?? ''))
        .toList();

    final publishedDateTime = DateTime(year!, month!, day!, hour ?? 0, minute ?? 0);

    Element imgElement = noticia.querySelector('img.tileImage')!;
    String imageUrl = imgElement.attributes['src']!;

    final content = await _getNewContent(url);
    final terms = <Term>[];
    if (content != null && content.isNotEmpty) {
      terms.addAll(
        getKeywordCount('$title. $content')
            .entries
            .takeWhile(
              (value) => value.value > 1,
            )
            .map(
              (e) => Term.newfound(e.key),
            ),
      );
    }

    return News(
      id: '',
      title: title,
      url: url,
      imageUrl: imageUrl,
      content: content,
      terms: terms,
      publishedAt: publishedDateTime,
    );
  }

  Future<String?> _getNewContent(String newUrl) async {
    final newPage = await http.get(Uri.parse(newUrl));

    final content = parser
        .parse(newPage.body)
        .querySelector('#content > article')
        ?.children
        .firstWhere((element) => element.attributes['property'] == 'rnews:articleBody');

    return (content?.text.length ?? 0) >= 300 ? content!.text : content?.text ?? '';
  }

  Map<String, int> getKeywordCount(String text) {
    // Define os caracteres que devem ser removidos do texto
    String punctuation = '.,;:!?(){}[]\n';

    // Remove a pontuação do texto
    String cleanedText = text.replaceAll(RegExp('[$punctuation]'), '');

    // Divide o texto em palavras individuais
    List<String> words = cleanedText.split(' ');

    // Cria um mapa para armazenar a contagem de palavras
    Map<String, int> wordCount = {};

    // Itera sobre as palavras e conta sua ocorrência
    for (String word in words) {
      // Ignora palavras muito curtas (menos de 3 caracteres)
      if (word.length < 3) continue;

      // Converte todas as palavras para letras minúsculas
      String lowercaseWord = word.toLowerCase();

      // Incrementa a contagem da palavra no mapa
      wordCount[lowercaseWord] = (wordCount[lowercaseWord] ?? 0) + 1;
    }

    return wordCount;
  }
}
