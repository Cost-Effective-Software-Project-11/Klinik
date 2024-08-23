part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialData extends HomeEvent {
  const LoadInitialData();
}

class LoadCities extends HomeEvent {
  const LoadCities();
}

class LoadSpecializations extends HomeEvent {
  const LoadSpecializations();
}

class ToggleSpecialization extends HomeEvent {
  final String specialization;

  const ToggleSpecialization(this.specialization);

  @override
  List<Object> get props => [specialization];
}

class ToggleCity extends HomeEvent {
  final String city;

  const ToggleCity(this.city);

  @override
  List<Object> get props => [city];
}

class UpdateSearchText extends HomeEvent {
  final String searchText;

  const UpdateSearchText(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class ClearFilters extends HomeEvent {
  const ClearFilters();
}

class LoadFilteredDoctors extends HomeEvent {
  const LoadFilteredDoctors();
}

class LoadFilteredInstitutions extends HomeEvent {
  const LoadFilteredInstitutions();
}