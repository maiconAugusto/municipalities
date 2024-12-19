import 'package:get_it/get_it.dart';
import 'package:municipalities/app/core/network/dio.dart';

void configureDependencies() {
  final injector = GetIt.instance;
  injector.registerLazySingleton(
    () => DioClient('').client,
  );
}
