import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../../core/errors/application_error.dart';
import '../../../auth/domain/utils/extractor.dart';
import '../../../term/domain/models/term.dart';
import '../../domain/dtos/create_direction_dto.dart';
import '../../domain/usecases/create_direction.dart';
import '../../domain/usecases/get_all_direction.dart';

class DirectionResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', getAll),
        Route.post('/', createDirection),
      ];

  Future<Response> getAll(Request request, Injector injector, ModularArguments args) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<GetAllDirection>();

    try {
      final user = extractor.getUser(request);
      final response = await usecase(GetDirectionsDto(user.id));

      return Response(HttpStatus.created, body: jsonEncode({'directions': response.map((e) => e.toMap()).toList()}));
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }

  Future<Response> createDirection(Request request, ModularArguments args, Injector injector) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<CreateDirection>();

    try {
      final user = extractor.getUser(request);
      final terms = (args.data['terms'] as List).map((e) => Term.fromClearMap(e)).toList();
      String? email = args.data['redirectEmail'];
      if (email == null || email.isEmpty) email = user.email;

      final response = await usecase(CreateDirectionDto(
        user.id,
        args.data['title'] ?? '',
        email,
        terms,
      ));

      return Response(HttpStatus.created, body: jsonEncode(response.toMap()));
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }
}
