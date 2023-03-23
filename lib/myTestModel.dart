class MyTestModel {
  final String name;
  final String hospital;
  final String id;
  final String price;

  MyTestModel(
      {required this.name,
        required this.id,
        required this.hospital,
        required this.price});

  factory MyTestModel.fromJson(Map<String, dynamic> json) {
    return MyTestModel(
      name: json["name"],
      hospital: json["hospital"],
      id: json["id"],
      price: json["price"],
    );
  }
}
