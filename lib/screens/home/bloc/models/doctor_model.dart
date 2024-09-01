class Doctor {
  final String name;
  final String speciality;
  final String workplace;
  final String city;
  final String phone;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.speciality,
    required this.workplace,
    required this.city,
    required this.phone,
    required this.imageUrl,
  });

  factory Doctor.fromFirestore(Map<String, dynamic> data) {
    return Doctor(
      name: data['name'] ?? '',
      speciality: data['speciality'] ?? '',
      workplace: data['workplace'] ?? '',
      city: data['city'] ?? '',
      phone: data['phone'] ?? '',
      imageUrl: data['imageUrl']?.isNotEmpty == true
          ? data['imageUrl']
          : 'https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png',
    );
  }
}