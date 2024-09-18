import 'package:equatable/equatable.dart';

abstract class DoctorEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDoctorDetails extends DoctorEvents {
  final String doctorId;

  GetDoctorDetails(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}