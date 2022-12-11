class Category {
  String thumbnail;
  String name;

  Category({
    required this.name,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Temperatura apa',
    thumbnail: 'assets/icons/laptop.jpg',
  ),
  Category(
    name: 'Nivel apa',
    thumbnail: 'assets/icons/accounting.jpg',
  ),
  Category(
    name: 'Presiune ulei',
    thumbnail: 'assets/icons/photography.jpg',
  ),
  Category(
    name: 'Rotatii/minut',
    thumbnail: 'assets/icons/design.jpg',
  ),
  Category(
    name: 'Nivel combustibil',
    thumbnail: 'assets/icons/design.jpg',
  ),
];
