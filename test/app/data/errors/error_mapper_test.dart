import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:municipalities/app/data/errors/error_mapper.dart';

void main() {
  group('ErrorMapper Tests', () {
    test('should return connection timeout error message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );

      final result = ErrorMapper.mapError(error);

      expect(result, isA<Exception>());
      expect(result.toString(), contains('Tempo de conexão excedido'));
    });

    test('should return receive timeout error message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.receiveTimeout,
      );

      final result = ErrorMapper.mapError(error);

      expect(result, isA<Exception>());
      expect(result.toString(), contains('Tempo de conexão excedido'));
    });

    test('should return no internet connection error message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );

      final result = ErrorMapper.mapError(error);

      expect(result, isA<Exception>());
      expect(result.toString(), contains('Sem conexão com a internet'));
    });

    test('should return server error message for 500 status code', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
        ),
      );

      final result = ErrorMapper.mapError(error);

      expect(result, isA<Exception>());
      expect(result.toString(), contains('Serviço fora do ar'));
    });

    test('should return a generic error message for other Dio exceptions', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      );

      final result = ErrorMapper.mapError(error);

      expect(result, isA<Exception>());
      expect(result.toString(), contains('Erro ao se comunicar com o serviço'));
    });

    test('should return a default error message for non-Dio errors', () {
      final error = Exception('Unknown error');

      final result = ErrorMapper.mapError(error);

      expect(result, isA<Exception>());
      expect(result.toString(), contains('Erro ao buscar municípios'));
    });
  });
}
