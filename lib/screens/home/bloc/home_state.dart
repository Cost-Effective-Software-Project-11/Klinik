part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Map<String, dynamic>> doctors;
  final List<Map<String, dynamic>> filteredDoctors;
  final List<Map<String, dynamic>> institutions;
  final List<Map<String, dynamic>> filteredInstitutions;
  final List<String> specializations;
  final List<String> cities;
  final List<String> selectedSpecializations;
  final List<String> selectedCities;
  final String searchText;

  const HomeState({
    this.doctors = const [],
    this.filteredDoctors = const [],
    this.institutions = const [],
    this.filteredInstitutions = const [],
    this.specializations = const [],
    this.cities = const [],
    this.selectedSpecializations = const [],
    this.selectedCities = const [],
    this.searchText = '',
  });

  HomeState copyWith({
    List<Map<String, dynamic>>? doctors,
    List<Map<String, dynamic>>? filteredDoctors,
    List<Map<String, dynamic>>? institutions,
    List<Map<String, dynamic>>? filteredInstitutions,
    List<String>? specializations,
    List<String>? cities,
    List<String>? selectedSpecializations,
    List<String>? selectedCities,
    String? searchText,
  }) {
    return HomeState(
      doctors: doctors ?? this.doctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      institutions: institutions ?? this.institutions,
      filteredInstitutions: filteredInstitutions ?? this.filteredInstitutions,
      specializations: specializations ?? this.specializations,
      cities: cities ?? this.cities,
      selectedSpecializations: selectedSpecializations ?? this.selectedSpecializations,
      selectedCities: selectedCities ?? this.selectedCities,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object> get props => [
    doctors,
    filteredDoctors,
    institutions,
    filteredInstitutions,
    specializations,
    cities,
    selectedSpecializations,
    selectedCities,
    searchText,
  ];
}