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
  final String doctorId;
  final bool isPublished;

  Trial({
    required this.id,
    required this.title,
    required this.category,
    this.disease,
    this.medication,
    required this.duration,
    required this.description,
    required this.eligibilityCriteria,
    required this.doctorId,
    required this.isPublished,
  });

  factory Trial.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Trial(
      id: doc.id,
      title: data['title'] ?? 'Untitled Trial',
      category: data['category'] ?? 'Uncategorized',
      disease: data['disease'] as String?,
      medication: data['medication'] as String?,
      duration: data['duration'] ?? 'Not specified',
      description: data['description'] ?? 'No description',
      eligibilityCriteria: (data['eligibilityCriteria'] is Iterable)
          ? List<String>.from(data['eligibilityCriteria'])
          : [],

      doctorId: data['doctorId'] ?? 'Unknown Doctor',
      isPublished: data['isPublished'] ?? false,
    );
  }
}
