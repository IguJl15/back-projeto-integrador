import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../../core/errors/application_error.dart';
import '../../algorithms/ifpi.dart';
import '../../algorithms/scrap_algorithm.dart';

class ScrapperResource implements Resource {
  @override
  
  // /scrapper
  List<Route> get routes => [Route.post('/:portal', runScrap)];

  Future<Response> runScrap(ModularArguments args) async {
    final scrapAlgorithm = _selectScrap(args.params['portal']);

    try {
      final scrapResult = await scrapAlgorithm.scrap();

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
}
