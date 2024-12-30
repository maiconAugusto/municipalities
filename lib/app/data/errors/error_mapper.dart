import 'package:dio/dio.dart';

class ErrorMapper {
  static Exception mapError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return Exception('Tempo de conexão excedido');
      } else if (error.type == DioExceptionType.connectionError) {
        return Exception('Sem conexão com a internet');
      } else if (error.response != null && error.response?.statusCode == 500) {
        return Exception('Serviço fora do ar');
      } else {
        return Exception('Erro ao se comunicar com o serviço');
      }
    } else {
      return Exception('Erro ao buscar municípios');
    }
  }
}
