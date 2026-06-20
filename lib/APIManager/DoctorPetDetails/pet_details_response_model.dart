class PetDetailsResponseModel {
  final bool status;
  final PetDetailsData? pet;
  final String message;

  PetDetailsResponseModel({
    required this.status,
    this.pet,
    required this.message,
  });

  factory PetDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return PetDetailsResponseModel(
      status: json['status'] ?? false,
      pet: json['pet'] != null ? PetDetailsData.fromJson(json['pet']) : null,
      message: json['message'] ?? '',
    );
  }

  factory PetDetailsResponseModel.failure(String message) {
    return PetDetailsResponseModel(status: false, pet: null, message: message);
  }
}

class PetDetailsData {
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
  final List<PetDetailVacination> vaccination;
  final DateTime createdAt;

  PetDetailsData({
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
    required this.vaccination,
    required this.createdAt,
  });

  factory PetDetailsData.fromJson(Map<String, dynamic> json) {
    return PetDetailsData(
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
      vaccination: json['vaccination'] != null
          ? List<PetDetailVacination>.from(
              json['vaccination'].map((e) => PetDetailVacination.fromJson(e)),
            )
          : [],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class PetDetailVacination {
  final String name;
  final String expDate;
  final bool taken;

  PetDetailVacination({
    required this.name,
    required this.expDate,
    required this.taken,
  });

  factory PetDetailVacination.fromJson(Map<String, dynamic> json) {
    String vaccineName = 'Unknown';
    bool taken = false;

    if (json.containsKey('rabbies')) {
      vaccineName = 'Rabies';
      taken = json['rabbies'] == true;
    } else if (json.containsKey('ddhp')) {
      vaccineName = 'DDHP';
      taken = json['ddhp'] == true;
    } else if (json.containsKey('kenne_cough')) {
      vaccineName = 'Kennel Cough';
      taken = json['kenne_cough'] == true;
    }

    return PetDetailVacination(
      name: vaccineName,
      taken: taken,
      expDate: json['exp_date']?.toString() ?? '',
    );
  }
}
