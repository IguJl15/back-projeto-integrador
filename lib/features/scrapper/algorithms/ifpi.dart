import 'package:back_projeto_integrador/features/scrapper/algorithms/scrap_algorithm.dart';
import 'package:back_projeto_integrador/features/scrapper/models/news.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';

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

    return News(
      id: '',
      title: title,
      url: url,
      imageUrl: imageUrl,
      content: content,
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

    return (content?.text.length ?? 0) >= 300 ? content!.text.substring(0, 300) : content?.text ?? '';
  }
}
