import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/models/doctor_model.dart';
import '../bloc/models/institution_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final querySnapshot = await _firestore.collection('users').where('type', isEqualTo: 'UserType.doctor').get();
      return querySnapshot.docs.map((doc) {
        return Doctor.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      // handle errors
      return [];
    }
  }

  Future<List<Institution>> fetchInstitutions() async {
    try {
      final querySnapshot = await _firestore.collection('institutions').get();
      return querySnapshot.docs.map((doc) {
        return Institution.fromFirestore(doc.data());
      }).toList();
    } catch (e) {
      // handle errors
      return [];
    }
  }
}
