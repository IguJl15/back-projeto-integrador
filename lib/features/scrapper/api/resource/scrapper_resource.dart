import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../../core/errors/application_error.dart';
import '../../algorithms/ifpi.dart';
import '../../algorithms/scrap_algorithm.dart';
import '../../data/scrapper_respository.dart';

class ScrapperResource implements Resource {
  @override
  List<Route> get routes => [
        Route.get('/', getAllNews),
        Route.post('/:portal', runScrap),
      ];

  Future<Response> runScrap(ModularArguments args, Injector injector) async {
    final scrapAlgorithm = _selectScrap(args.params['portal']);
    final repo = injector<ScrapperRepository>();

    try {
      final scrapResult = await scrapAlgorithm.scrap();

      repo.saveAll(scrapResult);

      return Response.ok(jsonEncode({"news": scrapResult.map((e) => e.toMap()).toList()}));
    } on ApplicationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({"error": e.toMap()}),
      );
    }
  }

  ScrapAlgorithm _selectScrap(String portal) {
    return switch (portal) {
      'ifpi' => IfpiScrapAlgorithm(),
      _ => throw FormatException(),
    };
  }

  Future<Response> getAllNews(ModularArguments args, Injector injector) async {
    final repo = injector<ScrapperRepository>();

    try {
      final news = repo.getAllNews();
      return Response.ok(jsonEncode({"news": news.map((e) => e.toMap()).toList()}));
    } on ApplicationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({"error": e.toMap()}),
      );
    }
  }
}
