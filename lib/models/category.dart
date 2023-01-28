class Category {
  String thumbnail;
  String name;
  String unit;

  Category({
    required this.name,
    required this.thumbnail,
    required this.unit
  });
}

List<Category> categoryList = [
  Category(
    name: 'Temperatură apă',
    unit: '°C',
    thumbnail: 'assets/icons/w.jpeg',
  ),
  Category(
    name: 'Nivel apă',
    unit: 'l',
    thumbnail: 'assets/icons/level.png',
  ),
  Category(
    name: 'Presiune ulei',
    unit: 'Bar',
    thumbnail: 'assets/icons/p.jpg',
  ),
  Category(
    name: 'Nivel combustibil',
    unit: 'L',
    thumbnail: 'assets/icons/comb.jpeg',
  ),
];
