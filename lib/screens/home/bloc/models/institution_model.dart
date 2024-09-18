class Institution {
  final String name;
  final String city;
  final List<String> specialities;
  final String imageUrl;

  Institution({
    required this.name,
    required this.city,
    required this.specialities,
    required this.imageUrl,
  });

  factory Institution.fromFirestore(Map<String, dynamic> data) {
    return Institution(
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      specialities: List<String>.from(data['specialities'] ?? []),
      imageUrl: data['imageUrl']?.isNotEmpty == true
          ? data['imageUrl']
          : 'https://static.vecteezy.com/system/resources/previews/028/078/799/original/hospital-cartoon-cute-ai-generative-png.png',
    );
  }
}