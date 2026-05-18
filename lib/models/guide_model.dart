class Guide {
  final String id;
  final String name;
  final String image;
  final List<PriceGroup> priceGroups;
  final String introduction;

  Guide({
    required this.id,
    required this.name,
    required this.image,
    required this.priceGroups,
    required this.introduction,
  });
}

class PriceGroup {
  final String title;
  final String price;

  PriceGroup({required this.title, required this.price});
}
