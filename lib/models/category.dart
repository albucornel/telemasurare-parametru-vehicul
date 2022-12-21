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
    thumbnail: 'assets/icons/w.jpeg',
  ),
  Category(
    name: 'Nivel apa',
    thumbnail: 'assets/icons/level.png',
  ),
  Category(
    name: 'Presiune ulei',
    thumbnail: 'assets/icons/p.jpg',
  ),
  Category(
    name: 'Nivel combustibil',
    thumbnail: 'assets/icons/comb.jpeg',
  ),
];
