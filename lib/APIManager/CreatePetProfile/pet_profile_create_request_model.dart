class PetProfileCreateRequestModel {
  final String ownerName;
  final String mobileNumber;
  final String email;
  final String petName;
  final String species;
  final String breed;
  final int age;
  final String gender;
  final int weight;
  final String vaccinationHistory;
  final String notes;
  final String photoUrl;
  final String documentsUrl;
  final String userId;
  final String deviceId;

  PetProfileCreateRequestModel({
    required this.ownerName,
    required this.mobileNumber,
    required this.email,
    required this.petName,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.vaccinationHistory,
    required this.notes,
    required this.photoUrl,
    required this.documentsUrl,
    required this.userId,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "owner_name": ownerName,
      "mobile_number": mobileNumber,
      "email": email,
      "pet_name": petName,
      "species": species,
      "breed": breed,
      "age": age,
      "gender": gender,
      "weight": weight,
      "vaccination_history": vaccinationHistory,
      "notes": notes,
      "photo_url": photoUrl,
      "documents_url": documentsUrl,
      "userid": userId,
      "device_id": deviceId,
      // 🔐 token will be auto-added by ApiServiceManager interceptor
    };
  }
}
