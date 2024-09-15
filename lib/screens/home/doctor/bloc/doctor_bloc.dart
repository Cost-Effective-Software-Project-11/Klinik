import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../repos/user/user_repository.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvents, DoctorStates> {
  final UserRepository _userRepository;

  DoctorBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(DoctorLoadingState()) {
    on<GetDoctorDetails>(_onGetDoctorDetails);
  }

  Future<void> _onGetDoctorDetails(
      GetDoctorDetails event,
      Emitter<DoctorStates> emit,
      ) async {
    emit(DoctorLoadingState());
    try {
      final doctorDetail = await _userRepository.getDoctorDetail(event.doctorId);
      if (doctorDetail != null) {
        emit(DoctorLoadedState(doctorDetail));
      } else {
        emit(DoctorErrorState('Failed to load doctor details'));
      }
    } catch (e) {
      emit(DoctorErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
