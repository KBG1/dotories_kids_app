class Cafe {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
  final double? rating;
  final String? imageUrl;
  final String? businessHours;
  final List<String>? amenities;
  final String? description;
  final int? priceRange;

  Cafe({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
    this.rating,
    this.imageUrl,
    this.businessHours,
    this.amenities,
    this.description,
    this.priceRange,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      latitude: (json['lat'] ?? 0.0).toDouble(),  // 'latitude' → 'lat'
      longitude: (json['lng'] ?? 0.0).toDouble(), // 'longitude' → 'lng'
      address: json['address'] ?? '',
      phone: json['number'],  // 'phone' → 'number'
      rating: json['rating']?.toDouble(),
      imageUrl: json['image'], // 'imageUrl' → 'image'
      businessHours: json['businessHours'],
      amenities: json['amenities'] != null 
          ? List<String>.from(json['amenities']) 
          : null,
      description: json['description'],
      priceRange: json['priceRange'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'rating': rating,
      'imageUrl': imageUrl,
      'businessHours': businessHours,
      'amenities': amenities,
      'description': description,
      'priceRange': priceRange,
    };
  }

  @override
  String toString() {
    return 'Cafe(id: $id, name: $name, address: $address)';
  }
}

class CafeResponse {
  final List<Cafe> cafes;
  final bool hasNext;
  final int? totalCount;
  final int? currentPage;

  CafeResponse({
    required this.cafes,
    required this.hasNext,
    this.totalCount,
    this.currentPage,
  });

  factory CafeResponse.fromJson(Map<String, dynamic> json) {
    return CafeResponse(
      cafes: (json['items'] as List<dynamic>?)  // 'cafes' → 'items'로 변경
          ?.map((cafeJson) => Cafe.fromJson(cafeJson))
          .toList() ?? [],
      hasNext: json['hasNext'] ?? false,
      totalCount: json['totalCount'],
      currentPage: json['currentPage'],
    );
  }
}
