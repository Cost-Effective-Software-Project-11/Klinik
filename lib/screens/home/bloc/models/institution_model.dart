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
      imageUrl: data['imageUrl'] ?? 'https://png.pngtree.com/png-vector/20231023/ourmid/pngtree-simple-buildings-office-png-image_10312300.png',
    );
  }
}