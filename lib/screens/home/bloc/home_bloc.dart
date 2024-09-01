import 'package:bloc/bloc.dart';
import '../../../enums/viewtype.dart';
import '../repository/home_repository.dart';
import 'models/doctor_model.dart';
import 'models/institution_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeState()) {
    on<LoadInitialData>((event, emit) async {
      final doctors = await _repository.fetchDoctors();
      final institutions = await _repository.fetchInstitutions();
      final specializations = _getUniqueSpecializations(doctors, institutions);
      final cities = _getUniqueCities(doctors, institutions);

      emit(state.copyWith(
        doctors: doctors,
        institutions: institutions,
        specializations: specializations,
        cities: cities,
        allDoctors: doctors,
        allInstitutions: institutions,
      ));
    });

    on<UpdateSearchText>((event, emit) {
      final filteredDoctors = _filterDoctors(event.query, state.selectedSpecializations, state.selectedCities, state.allDoctors);
      final filteredInstitutions = _filterInstitutions(event.query, state.selectedSpecializations, state.selectedCities, state.allInstitutions);
      emit(state.copyWith(doctors: filteredDoctors, institutions: filteredInstitutions, searchQuery: event.query));
    });

    on<UpdateSpecializationSearchQuery>((event, emit) {
      emit(state.copyWith(specializationSearchQuery: event.query));
    });

    on<ToggleSpecialization>((event, emit) {
      final updatedSpecializations = List<String>.from(state.selectedSpecializations);
      if (updatedSpecializations.contains(event.specialization)) {
        updatedSpecializations.remove(event.specialization);
      } else {
        updatedSpecializations.add(event.specialization);
      }

      final filteredDoctors = _filterDoctors(state.searchQuery, updatedSpecializations, state.selectedCities, state.allDoctors);
      final filteredInstitutions = _filterInstitutions(state.searchQuery, updatedSpecializations, state.selectedCities, state.allInstitutions);

      emit(state.copyWith(selectedSpecializations: updatedSpecializations, doctors: filteredDoctors, institutions: filteredInstitutions));
    });

    on<ToggleCity>((event, emit) {
      final updatedCities = List<String>.from(state.selectedCities);
      if (updatedCities.contains(event.city)) {
        updatedCities.remove(event.city);
      } else {
        updatedCities.add(event.city);
      }

      final filteredDoctors = _filterDoctors(state.searchQuery, state.selectedSpecializations, updatedCities, state.allDoctors);
      final filteredInstitutions = _filterInstitutions(state.searchQuery, state.selectedSpecializations, updatedCities, state.allInstitutions);

      emit(state.copyWith(selectedCities: updatedCities, doctors: filteredDoctors, institutions: filteredInstitutions));
    });

    on<UpdateCitySearchQuery>((event, emit) {
      emit(state.copyWith(citySearchQuery: event.query));
    });

    on<ClearFilters>((event, emit) {
      _clearFilters(emit);
    });

    on<ToggleViewType>((event, emit) {
      emit(state.copyWith(viewType: event.viewType));
    });
  }

  // Extract unique specializations from both doctors and institutions
  List<String> _getUniqueSpecializations(List<Doctor> doctors, List<Institution> institutions) {
    final specializations = <String>{};
    for (var doctor in doctors) {
      specializations.add(doctor.speciality);
    }
    for (var institution in institutions) {
      specializations.addAll(institution.specialities);
    }
    return specializations.toList();
  }

  // Extract unique cities from both doctors and institutions
  List<String> _getUniqueCities(List<Doctor> doctors, List<Institution> institutions) {
    final cities = <String>{};
    for (var doctor in doctors) {
      cities.add(doctor.city);
    }
    for (var institution in institutions) {
      cities.add(institution.city);
    }
    return cities.toList();
  }

  void _clearFilters(Emitter<HomeState> emit) {
    emit(state.copyWith(
      selectedSpecializations: [],
      selectedCities: [],
      doctors: state.allDoctors,
      institutions: state.allInstitutions,
      searchQuery: '',
    ));
  }

  List<Doctor> _filterDoctors(String query, List<String> specializations, List<String> cities, List<Doctor> allDoctors) {
    return allDoctors.where((doctor) {
      final matchesQuery = doctor.name.toLowerCase().contains(query.toLowerCase());
      final matchesSpecialization = specializations.isEmpty || specializations.contains(doctor.speciality);
      final matchesCity = cities.isEmpty || cities.contains(doctor.city);
      return matchesQuery && matchesSpecialization && matchesCity;
    }).toList();
  }

  List<Institution> _filterInstitutions(String query, List<String> specializations, List<String> cities, List<Institution> allInstitutions) {
    return allInstitutions.where((institution) {
      final matchesQuery = institution.name.toLowerCase().contains(query.toLowerCase());
      final matchesCity = cities.isEmpty || cities.contains(institution.city);
      final matchesSpecialization = specializations.isEmpty ||
          institution.specialities.any((specialization) => specializations.contains(specialization));
      return matchesQuery && matchesCity && matchesSpecialization;
    }).toList();
  }
}
