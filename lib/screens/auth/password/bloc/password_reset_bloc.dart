import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  final FirebaseAuth _firebaseAuth;

  EmailBloc(this._firebaseAuth) : super(EmailInitial()) {
    on<SendEmailEvent>(_onSendEmailEvent);
  }

  Future<void> _onSendEmailEvent(
      SendEmailEvent event, Emitter<EmailState> emit) async {
    emit(EmailLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(EmailSentSuccess());
    } catch (e) {
      emit(EmailSentFailure(errorMessage: e.toString()));
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users2')
            .where('email', isEqualTo: email)
            .get();
      }
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
