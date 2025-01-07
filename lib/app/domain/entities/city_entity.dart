class CityEntity {
  final String name;
  final String state;
  final String stateAcronym;
  final int id;
  final String microregion;
  final String mesoregion;

  CityEntity({
    required this.name,
    required this.state,
    required this.stateAcronym,
    required this.id,
    required this.microregion,
    required this.mesoregion,
  });
  CityEntity toEntity() {
    return CityEntity(
      id: id,
      name: name,
      mesoregion: mesoregion,
      microregion: microregion,
      state: state,
      stateAcronym: stateAcronym,
    );
  }
}
