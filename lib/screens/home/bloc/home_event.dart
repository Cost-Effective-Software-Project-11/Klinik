part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadInitialData extends HomeEvent {}

class UpdateSearchText extends HomeEvent {
  final String query;
  UpdateSearchText(this.query);
}

class ToggleSpecialization extends HomeEvent {
  final String specialization;
  ToggleSpecialization(this.specialization);
}

class ToggleCity extends HomeEvent {
  final String city;
  ToggleCity(this.city);
}

class ClearFilters extends HomeEvent {}

class ToggleViewType extends HomeEvent {
  final ViewType viewType;
  ToggleViewType(this.viewType);
}

class UpdateSpecializationSearchQuery extends HomeEvent {
  final String query;
  UpdateSpecializationSearchQuery(this.query);
}

class UpdateCitySearchQuery extends HomeEvent {
  final String query;
  UpdateCitySearchQuery(this.query);
}