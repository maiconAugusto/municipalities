import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:municipalities/app/data/repositories/city_repository.dart';
import 'package:municipalities/app/domain/use_cases/cities_use_case.dart';
import 'package:municipalities/app/drivers/injects/injects.dart';
import 'package:municipalities/app/presentation/blocs/cities_bloc.dart';
import 'package:municipalities/app/presentation/pages/cities_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final CityRepositories cityRepositories = CityRepositories();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CitiesBloc(
          CitiesUseCase(
            cityRepositories,
          ),
        ),
        child: const MunicipioListPage(),
      ),
    );
  }
}
