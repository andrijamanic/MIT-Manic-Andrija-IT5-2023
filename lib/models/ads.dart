class Ad {
  final String id;
  final String title;
  final String description;
  final String price;
  final String category;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
  });
}

// Primer placeholder liste oglasa
final List<Ad> dummyAds = [
  Ad(
    id: '1',
    title: 'Jednosoban stan',
    description: 'Beograd, Vračar, 35m²',
    price: '400€',
    category: 'Stanovi',
  ),
  Ad(
    id: '2',
    title: 'Dvosoban stan',
    description: 'Novi Sad, 55m²',
    price: '550€',
    category: 'Stanovi',
  ),
  Ad(
    id: '3',
    title: 'IT praksa',
    description: 'Frontend developer, Beograd',
    price: 'Besplatno',
    category: 'Prakse',
  ),
  Ad(
    id: '4',
    title: 'Bicikl',
    description: 'Road bike, korišćen',
    price: '150€',
    category: 'Ostalo',
  ),
];
