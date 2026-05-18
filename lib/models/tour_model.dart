class TourModel {
  final String id;
  final String title;
  final String image;
  final String description;
  final String price;
  final String location;

  TourModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.location,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      price: json['price'],
      location: json['location'],
    );
  }
}