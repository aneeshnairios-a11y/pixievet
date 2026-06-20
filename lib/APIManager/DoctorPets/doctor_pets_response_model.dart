// ---------------- PET MODEL ----------------
class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String weight;
  final String notes;
  final List<String> images;
  final DateTime createdAt;

  PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.notes,
    required this.images,
    required this.createdAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? '',
      weight: json['weight'] ?? '',
      notes: json['notes'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'].map((e) => e.toString()))
          : [],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

// ---------------- RESPONSE MODEL ----------------
class DoctorPetsResponseModel {
  final bool status;
  final List<PetModel> pets;
  final String message;

  DoctorPetsResponseModel({
    required this.status,
    required this.pets,
    required this.message,
  });

  factory DoctorPetsResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorPetsResponseModel(
      status: json['status'] ?? false,
      pets: json['pets'] != null
          ? List<PetModel>.from(json['pets'].map((e) => PetModel.fromJson(e)))
          : [],
      message: json['message'] ?? '',
    );
  }

  factory DoctorPetsResponseModel.failure(String message) {
    return DoctorPetsResponseModel(status: false, pets: [], message: message);
  }
}
