class DoctorDetail {
  final String id;
  final String name;
  final String speciality;
  final String description;
  final String imageUrl;

  DoctorDetail({
    required this.id,
    required this.name,
    required this.speciality,
    required this.description,
    required this.imageUrl,
  });

  factory DoctorDetail.fromMap(Map<String, dynamic> data) {
    return DoctorDetail(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      speciality: data['speciality'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}