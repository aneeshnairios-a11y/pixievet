import 'dart:convert';
import 'dart:io';

class PetProfileCreateRequestModel {
  final OwnerDetails ownerDetails;
  final List<PetDetails> petDetails;
  final File? profileImage;
  final String userId;
  final String deviceId;
  final String token;

  PetProfileCreateRequestModel({
    required this.ownerDetails,
    required this.petDetails,
    this.profileImage,
    required this.userId,
    required this.deviceId,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      "owner_details": ownerDetails.toJson(),
      "pet_details": petDetails.map((e) => e.toJson()).toList(),
      "profile_image_base64": profileImage != null
          ? base64Encode(profileImage!.readAsBytesSync())
          : "",
      "userid": userId,
      "device_id": deviceId,
      "token": token,
    };
  }
}

class OwnerDetails {
  final String name;
  final String email;
  final String number;
  final String gender;

  OwnerDetails({
    required this.name,
    required this.email,
    required this.number,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "number": number, "gender": gender};
  }
}

class PetDetails {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age; // "4.2"
  final String weight; // "6.5"
  final String notes;
  final List<File> images;
  final List<VaccinationDetails> vaccination;

  PetDetails({
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.notes,
    required this.images,
    required this.vaccination,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "species": species,
      "breed": breed,
      "gender": gender,
      "age": age,
      "weight": weight,
      "notes": notes,
      "Images": images
          .map((file) => base64Encode(file.readAsBytesSync()))
          .toList(),
      "vaccination": vaccination.map((v) => v.toJson()).toList(),
    };
  }
}

class VaccinationDetails {
  final bool? rabbies;
  final bool? ddhp;
  final bool? kenneCough;
  final String? expDate;

  VaccinationDetails({this.rabbies, this.ddhp, this.kenneCough, this.expDate});

  Map<String, dynamic> toJson() {
    return {
      if (rabbies != null) "rabbies": rabbies,
      if (ddhp != null) "ddhp": ddhp,
      if (kenneCough != null) "kenne_cough": kenneCough,
      if (expDate != null) "exp_date": expDate,
    };
  }
}
