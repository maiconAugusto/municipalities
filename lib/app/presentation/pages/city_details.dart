import 'package:flutter/material.dart';
import 'package:municipalities/app/data/models/city_model.dart';

class CityDetailsPage extends StatelessWidget {
  final CityModel city;

  const CityDetailsPage({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome do Município: ${city.name}',
            ),
            const SizedBox(height: 10),
            Text('Estado: ${city.state}'),
            Text('Sigla do Estado: ${city.stateAcronym}'),
            Text('Código do Município (ID): ${city.id}'),
            const SizedBox(height: 20),
            Text('Microrregião: ${city.microregion}'),
            Text('Mesorregião: ${city.mesoregion}'),
          ],
        ),
      ),
    );
  }
}
