import 'package:cloud_firestore/cloud_firestore.dart';

class Trial {
  final String id;
  final String title;
  final String category;
  final String? disease;
  final String? medication;
  final String duration;
  final String description;
  final List<String> eligibilityCriteria;

  Trial({
    required this.id,
    required this.title,
    required this.category,
    this.disease,
    this.medication,
    required this.duration,
    required this.description,
    required this.eligibilityCriteria,
  });

  factory Trial.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Trial(
      id: doc.id,
      title: data['title'],
      category: data['category'],
      disease: data['disease'],
      medication: data['medication'],
      duration: data['duration'],
      description: data['description'],
      eligibilityCriteria: List<String>.from(data['eligibilityCriteria']),
    );
  }
}
