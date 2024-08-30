class Person {
  final String email;
  final String id;
  final String name;
  final String photo;

  const Person({
    required this.name,
    required this.id,
    required this.email,
    required this.photo,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    try {
      return Person(
        email: json['email']! as String,
        id: json['id']! as String,
        name: json['name']! as String,
        photo: json['photo']! as String,
      );
    } catch (e) {
      throw Exception('Error converting JSON data to "Person": $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id,
      'name': name,
      'photo': photo,
    };
  }
}
