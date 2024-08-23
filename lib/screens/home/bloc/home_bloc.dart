import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<LoadCities>(_onLoadCities);
    on<LoadSpecializations>(_onLoadSpecializations);
    on<ToggleSpecialization>(_onToggleSpecialization);
    on<ToggleCity>(_onToggleCity);
    on<UpdateSearchText>(_onUpdateSearchText);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadInitialData(LoadInitialData event, Emitter<HomeState> emit) async {
    await _loadDoctorsData(emit);
    await _loadInstitutionsData(emit);
    add(const LoadSpecializations());
    add(const LoadCities());
  }

  void _onLoadCities(LoadCities event, Emitter<HomeState> emit) async {
    var snapshot = await FirebaseFirestore.instance.collection('institutions').get();
    var cities = snapshot.docs.map((doc) => doc.data()['city'] as String).toSet().toList();
    emit(state.copyWith(cities: cities));
  }

  void _onLoadSpecializations(LoadSpecializations event, Emitter<HomeState> emit) async {
    var snapshot = await FirebaseFirestore.instance.collection('specialities').get();
    var specializations = snapshot.docs.map((doc) => doc['name'] as String).toList();
    emit(state.copyWith(specializations: specializations));
  }

  Future<void> _loadDoctorsData(Emitter<HomeState> emit) async {
    var snapshot = await FirebaseFirestore.instance.collection('users').where('type', isEqualTo: 'Doctor').get();
    var doctors = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    emit(state.copyWith(doctors: doctors, filteredDoctors: doctors));
  }

  Future<void> _loadInstitutionsData(Emitter<HomeState> emit) async {
    var snapshot = await FirebaseFirestore.instance.collection('institutions').get();
    var institutions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    emit(state.copyWith(institutions: institutions, filteredInstitutions: institutions));
  }

  void _onToggleSpecialization(ToggleSpecialization event, Emitter<HomeState> emit) async {
    final updatedSpecializations = List<String>.from(state.selectedSpecializations);
    if (updatedSpecializations.contains(event.specialization)) {
      updatedSpecializations.remove(event.specialization);
    } else {
      updatedSpecializations.add(event.specialization);
    }
    emit(state.copyWith(selectedSpecializations: updatedSpecializations));
    await _filterData(emit);
  }

  Future<void> _onToggleCity(ToggleCity event, Emitter<HomeState> emit) async {
    final updatedCities = List<String>.from(state.selectedCities);
    if (updatedCities.contains(event.city)) {
      updatedCities.remove(event.city);
    } else {
      updatedCities.add(event.city);
    }
    emit(state.copyWith(selectedCities: updatedCities));
  }

  Future<void> _onUpdateSearchText(UpdateSearchText event, Emitter<HomeState> emit) async {
    emit(state.copyWith(searchText: event.searchText));
  }

  void _onClearFilters(ClearFilters event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      selectedSpecializations: [],
      selectedCities: [],
      searchText: '',
      filteredDoctors: state.doctors,
      filteredInstitutions: state.institutions,
    ));
  }

  Future<void> _filterData(Emitter<HomeState> emit) async {
    // Query for doctors
    Query<Map<String, dynamic>> doctorQuery = FirebaseFirestore.instance.collection('users').where('type', isEqualTo: 'Doctor');

    if (state.selectedSpecializations.isNotEmpty) {
      doctorQuery = doctorQuery.where('speciality', whereIn: state.selectedSpecializations);
    }
    if (state.selectedCities.isNotEmpty) {
      doctorQuery = doctorQuery.where('city', whereIn: state.selectedCities);
    }
    var doctorResult = await doctorQuery.get();
    var filteredDoctors = doctorResult.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    print('Filtered doctors: $filteredDoctors');

    // Query for institutions
    Query<Map<String, dynamic>> institutionQuery = FirebaseFirestore.instance.collection('institutions');

    if (state.selectedSpecializations.isNotEmpty) {
      institutionQuery = institutionQuery.where('specialities', arrayContainsAny: state.selectedSpecializations);
    }
    if (state.selectedCities.isNotEmpty) {
      institutionQuery = institutionQuery.where('city', whereIn: state.selectedCities);
    }
    var institutionResult = await institutionQuery.get();
    var filteredInstitutions = institutionResult.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    print('Filtered institutions: $filteredInstitutions');

    emit(state.copyWith(filteredDoctors: filteredDoctors, filteredInstitutions: filteredInstitutions));
  }
}