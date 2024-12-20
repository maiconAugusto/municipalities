import 'package:get_it/get_it.dart';
import 'package:municipalities/app/core/network/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void configureDependencies() {
  final injector = GetIt.instance;
  injector.registerLazySingleton(
    () => DioClient(dotenv.env['BASE_URL'] as String).client,
  );
}
