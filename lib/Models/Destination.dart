class Destination {
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final String description;


  // Constructor
  Destination({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.description,
  });

  // Factory constructor to create a User from JSON (Map)
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: json['rating'] as double,
      description: json['description'] as String,


    );
  }

  // Convert a User to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,

    };
  }
}
