class UserProfileDetailsResponseModel {
  final bool status;
  final OwnerDetails? ownerDetails;
  final List<PetDetails> pets;
  final String message;

  UserProfileDetailsResponseModel({
    required this.status,
    this.ownerDetails,
    required this.pets,
    required this.message,
  });

  factory UserProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileDetailsResponseModel(
      status: json['status'] ?? false,
      ownerDetails: json['owner_details'] != null
          ? OwnerDetails.fromJson(json['owner_details'])
          : null,
      pets: (json['pet_details'] as List? ?? [])
          .map((e) => PetDetails.fromJson(e))
          .toList(),
      message: json['message'] ?? '',
    );
  }

  // ✅ ADD THIS
  factory UserProfileDetailsResponseModel.failure(String message) {
    return UserProfileDetailsResponseModel(
      status: false,
      ownerDetails: null,
      pets: [],
      message: message,
    );
  }
}

class OwnerDetails {
  final String name;
  final String email;
  final String number;
  final String gender;
  final String? profileImage; // 👈 NEW

  OwnerDetails({
    required this.name,
    required this.email,
    required this.number,
    required this.gender,
    this.profileImage,
  });

  factory OwnerDetails.fromJson(Map<String, dynamic> json) {
    return OwnerDetails(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      gender: json['gender'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}

class PetDetails {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String weight;
  final String notes;
  final List<Vaccination> vaccination;
  final List<String> images; // 👈 CHANGED

  PetDetails({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.notes,
    required this.vaccination,
    required this.images,
  });

  factory PetDetails.fromJson(Map<String, dynamic> json) {
    return PetDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? '',
      weight: json['weight'] ?? '',
      notes: json['notes'] ?? '',
      vaccination: (json['vaccination'] as List? ?? [])
          .map((e) => Vaccination.fromJson(e))
          .toList(),
      images: (json['images'] as List? ?? []).cast<String>(),
    );
  }
}

class Vaccination {
  final bool? rabbies;
  final bool? ddhp;
  final bool? kenneCough;
  final String expDate;

  Vaccination({
    this.rabbies,
    this.ddhp,
    this.kenneCough,
    required this.expDate,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      rabbies: json['rabbies'],
      ddhp: json['ddhp'],
      kenneCough: json['kenne_cough'],
      expDate: json['exp_date'] ?? '',
    );
  }
}
