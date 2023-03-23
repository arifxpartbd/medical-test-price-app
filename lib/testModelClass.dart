class TestModelClass {
  final String name;
  final String hospital;
  final String id;
  final String price;

  TestModelClass(
      {required this.name,
      required this.id,
      required this.hospital,
      required this.price});

  factory TestModelClass.fromJson(Map<String, dynamic> json) {
    return TestModelClass(
      name: json["name"],
      hospital: json["hospital"],
      id: json["id"],
      price: json["price"],
    );
  }
}
