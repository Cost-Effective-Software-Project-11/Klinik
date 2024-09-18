part of 'home_bloc.dart';

class HomeState {
  final List<Doctor> doctors;
  final List<Institution> institutions;
  final List<String> specializations;
  final List<String> cities;
  final List<String> selectedSpecializations;
  final List<String> selectedCities;
  final String searchQuery;
  final List<Doctor> allDoctors; // Unfiltered list of all doctors
  final List<Institution> allInstitutions; // Unfiltered list of all institutions
  final ViewType viewType;
  final String specializationSearchQuery;
  final String citySearchQuery;

  HomeState({
    this.doctors = const [],
    this.institutions = const [],
    this.specializations = const [],
    this.cities = const [],
    this.selectedSpecializations = const [],
    this.selectedCities = const [],
    this.searchQuery = '',
    this.allDoctors = const [],
    this.allInstitutions = const [],
    this.viewType = ViewType.doctors,
    this.specializationSearchQuery = '',
    this.citySearchQuery = '',
  });

  HomeState copyWith({
    List<Doctor>? doctors,
    List<Institution>? institutions,
    List<String>? specializations,
    List<String>? cities,
    List<String>? selectedSpecializations,
    List<String>? selectedCities,
    String? searchQuery,
    List<Doctor>? allDoctors,
    List<Institution>? allInstitutions,
    ViewType? viewType,
    String? specializationSearchQuery,
    String? citySearchQuery,
  }) {
    return HomeState(
      doctors: doctors ?? this.doctors,
      institutions: institutions ?? this.institutions,
      specializations: specializations ?? this.specializations,
      cities: cities ?? this.cities,
      selectedSpecializations: selectedSpecializations ?? this.selectedSpecializations,
      selectedCities: selectedCities ?? this.selectedCities,
      searchQuery: searchQuery ?? this.searchQuery,
      allDoctors: allDoctors ?? this.allDoctors,
      allInstitutions: allInstitutions ?? this.allInstitutions,
      viewType: viewType ?? this.viewType,
      specializationSearchQuery: specializationSearchQuery ?? this.specializationSearchQuery,
      citySearchQuery: citySearchQuery ?? this.citySearchQuery,
    );
  }
}

class LoadingState extends HomeState {
  List<Object> get props=> [];
}