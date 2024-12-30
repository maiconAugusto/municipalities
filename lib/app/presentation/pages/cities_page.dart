import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cities_bloc.dart';

class MunicipioListPage extends StatefulWidget {
  const MunicipioListPage({super.key});

  @override
  State<MunicipioListPage> createState() => _MunicipioListPageState();
}

class _MunicipioListPageState extends State<MunicipioListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0) {
        context.read<CitiesBloc>().fetchCities();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Municípios'),
      ),
      body: BlocBuilder<CitiesBloc, CityState>(
        builder: (context, state) {
          if (state.status == CityStatus.loading && state.cities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CityStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${state.errorMessage}'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CitiesBloc>().fetchCities();
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.cities.length
                : state.cities.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.cities.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final city = state.cities[index];
              return ListTile(
                key: ValueKey(city.id),
                title: Text(city.name),
                subtitle: Text('${city.state} - ${city.stateAcronym}'),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
