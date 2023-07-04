import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../../core/errors/application_error.dart';
import '../../../auth/domain/utils/extractor.dart';
import '../../../term/domain/models/term.dart';
import '../../domain/dtos/create_direction_dto.dart';
import '../../domain/dtos/patch_direction_dto.dart';
import '../../domain/usecases/create_direction.dart';
import '../../domain/usecases/delete_direction.dart';
import '../../domain/usecases/get_all_direction.dart';
import '../../domain/usecases/get_direction.dart';
import '../../domain/usecases/update_direction.dart';

class DirectionResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', getAll),
        Route.post('/', createDirection),
        Route.get('/:id', getDirection),
        Route.delete('/:id', deleteDirection),
        Route.path('/:id', updateDirection),
      ];

  Future<Response> getAll(
      Request request, Injector injector, ModularArguments args) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<GetAllDirection>();

    try {
      final user = extractor.getUser(request);
      final response = await usecase(GetDirectionsDto(user.id));

      return Response(HttpStatus.ok,
          body: jsonEncode(
              {'directions': response.map((e) => e.toMap()).toList()}));
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }

  Future<Response> getDirection(
      Request request, Injector injector, ModularArguments args) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<GetDirection>();

    try {
      final id = args.params['id'] ?? '';
      final user = extractor.getUser(request);

      final response = await usecase(user, id);

      return Response(HttpStatus.ok, body: jsonEncode(response.toMap()));
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }

  Future<Response> createDirection(
      Request request, ModularArguments args, Injector injector) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<CreateDirection>();

    try {
      final user = extractor.getUser(request);
      final inclusionTerms = (args.data['inclusionTerms'] as List)
          .map((e) => Term.fromClearMap(e))
          .toList();
      final exclusionTerms = (args.data['exclusionTerms'] as List)
          .map((e) => Term.fromClearMap(e))
          .toList();
      String? email = args.data['redirectEmail'];
      if (email == null || email.isEmpty) email = user.email;

      final response = await usecase(CreateDirectionDto(
        user.id,
        args.data['title'] ?? '',
        email,
        inclusionTerms,
        exclusionTerms,
      ));

      return Response(HttpStatus.created, body: jsonEncode(response.toMap()));
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }

  Future<Response> deleteDirection(
      Request request, ModularArguments args, Injector injector) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<DeleteDirection>();

    try {
      final user = extractor.getUser(request);
      final id = args.params['id'] ?? '';

      await usecase(user, id);

      return Response.ok("Deleted successfully");
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }

  Future<Response> updateDirection(
      Request request, ModularArguments args, Injector injector) async {
    final extractor = injector<RequestExtractor>();
    final usecase = injector<UpdateDirection>();

    try {
      final user = extractor.getUser(request);

      final updatedDirection = await usecase(
          PatchDirectionDto.fromMap(user, args.params['id'], args.data));

      return Response(HttpStatus.ok,
          body: jsonEncode(updatedDirection.toMap()));
    } on ApplicationError catch (e) {
      return Response(e.statusCode, body: jsonEncode({'error': e.toMap()}));
    }
  }
}
