import 'package:back_projeto_integrador/features/scrapper/algorithms/scrap_algorithm.dart';
import 'package:back_projeto_integrador/features/scrapper/models/news.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';

class IfpiScrapAlgorithm implements ScrapAlgorithm<List<News>> {
  final Uri initPage = Uri.parse("");

  @override
  Future<List<News>> scrap() async {
    final html = http.get(initPage);

    Document document = parser.parse(html);

    List<Element> noticias = document.querySelectorAll('div.tileItem');
    for (Element noticia in noticias) {
      String titulo = noticia.querySelector('h2.tileHeadline')!.text.trim();

      Element? dataPublicacaoElement = noticia.querySelector('span.summary-view-icon');
      String dataPublicacao =
          dataPublicacaoElement != null ? dataPublicacaoElement.text.trim() : 'Data de publicação não encontrada';

      Element? horaPublicacaoElement = noticia.querySelector('span.summary-view-icon');
      String horaPublicacao =
          horaPublicacaoElement != null ? horaPublicacaoElement.text.trim() : 'Hora de publicação não encontrada';

      Element? imgElement = noticia.querySelector('img.tileImage');
      String urlImagem = imgElement != null ? imgElement.attributes['src']! : 'URL da imagem não encontrada';

      print('Título: $titulo');
      print('Data de Publicação: $dataPublicacao');
      print('Hora de Publicação: $horaPublicacao');
      print('URL da Imagem: $urlImagem');
    }
  }
}
