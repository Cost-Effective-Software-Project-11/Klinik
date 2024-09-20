import 'package:equatable/equatable.dart';
import '../../bloc/models/detailed_doctor_model.dart';

abstract class DoctorStates extends Equatable {
  @override
  List<Object> get props => [];
}

class DoctorLoadingState extends DoctorStates {}

class DoctorLoadedState extends DoctorStates {
  final DoctorDetail doctorDetail;

  DoctorLoadedState(this.doctorDetail);

  @override
  List<Object> get props => [doctorDetail];
}

class DoctorErrorState extends DoctorStates {
  final String error;

  DoctorErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class DoctorUnauthenticatedState extends DoctorStates {}