// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../APIManager/CreatePetProfile/pet_profile_create_request_model.dart';
import '../../../APIManager/CreatePetProfile/pet_profile_create_service.dart';
import '../../../Utilities/app_colors.dart';
import '../../../app_init_page.dart';
import 'owner_profile_model.dart';
import 'vaccination_model.dart';
import 'pet_form_model.dart';

class CreatePetProfilePage extends StatefulWidget {
  final OwnerProfileModel owner;

  const CreatePetProfilePage({super.key, required this.owner});

  @override
  State<CreatePetProfilePage> createState() => _CreatePetProfilePageState();
}

class _CreatePetProfilePageState extends State<CreatePetProfilePage> {
  final picker = ImagePicker();

  final List<PetFormModel> pets = [PetFormModel()];

  Future<void> _pickPetImages(PetFormModel pet) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      pet.petImages.add(File(image.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final images = await picker.pickMultiImage(imageQuality: 80);
                  setState(() {
                    pet.petImages.addAll(images.map((e) => File(e.path)));
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate(VaccinationModel model) async {
    final date = await showDatePicker(
      context: context,
      initialDate: model.date ?? DateTime.now(),
      firstDate: DateTime(2000), // allows previous dates
      lastDate: DateTime(2100), // allows future dates ✅
    );

    if (date != null) {
      setState(() {
        model.date = date;
      });
    }
  }

  void _addAnotherPet() {
    setState(() {
      pets.add(PetFormModel());
    });
  }

  void _submitAllPets() async {
    for (final pet in pets) {
      if (!pet.formKey.currentState!.validate()) return;
    }

    final request = PetProfileCreateRequestModel(
      ownerDetails: OwnerDetails(
        name: widget.owner.fullName,
        email: widget.owner.email,
        number: widget.owner.mobile,
        gender: widget.owner.gender,
      ),
      petDetails: pets.map((pet) {
        return PetDetails(
          name: pet.petNameCtrl.text,
          species: pet.species,
          breed: pet.breedCtrl.text,
          gender: pet.gender,
          age: "${pet.yearCtrl.text}.${pet.monthCtrl.text}",
          weight: "${pet.kgCtrl.text}.${pet.gmCtrl.text}",
          notes: pet.notesCtrl.text,
          images: pet.petImages,
          vaccination: [
            if (pet.rabies.isSelected)
              VaccinationDetails(
                rabbies: true,
                expDate: pet.rabies.date != null
                    ? DateFormat('dd/MM/yyyy').format(pet.rabies.date!)
                    : null,
              ),
            if (pet.dhppi.isSelected)
              VaccinationDetails(
                ddhp: true,
                expDate: pet.rabies.date != null
                    ? DateFormat('dd/MM/yyyy').format(pet.rabies.date!)
                    : null,
              ),
            if (pet.kennel.isSelected) VaccinationDetails(kenneCough: true),
          ],
        );
      }).toList(),
      profileImage: widget.owner.profileImage,
      userId: "string",
      deviceId: "string",
      token: "string",
    );

    final service = PetProfileCreateService();
    final response = await service.createProfile(request);

    if (response.status) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AppInitPage(fromLoginFlow: true),
        ),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  @override
  void dispose() {
    for (final pet in pets) {
      pet.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Pet’s Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...pets.asMap().entries.map(
              (entry) => _petSection(entry.key, entry.value),
            ),

            const SizedBox(height: 16),

            /// ➕ ADD PET
            OutlinedButton.icon(
              onPressed: _addAnotherPet,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Pet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// ✅ SUBMIT
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitAllPets,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit All Pets',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PET UI (UNCHANGED DESIGN) =================

  Widget _petSection(int index, PetFormModel pet) {
    return Form(
      key: pet.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pet ${index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          _field(
            'Pet Name *',
            pet.petNameCtrl,
            hint: 'Enter pet name',
            keyboardType: TextInputType.name,
          ),
          _dropdown('Species', pet),
          _field(
            'Breed *',
            pet.breedCtrl,
            hint: 'Eg: Labrador',
            keyboardType: TextInputType.name,
          ),

          const SizedBox(height: 8),
          _genderField(pet),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _field(
                  'Years',
                  pet.yearCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  'Months',
                  pet.monthCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _field(
                  'Kg',
                  pet.kgCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  'Gms',
                  pet.gmCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _vaccine('Rabies', pet.rabies),
          _vaccine('DHPPi+L', pet.dhppi),
          _vaccine('Kennel Cough', pet.kennel),

          const SizedBox(height: 12),
          _notes(pet),

          const SizedBox(height: 16),
          Text('Add Pet Images'),
          Wrap(
            spacing: 8,
            children: [
              ...pet.petImages.map(
                (e) => Image.file(e, width: 70, height: 70, fit: BoxFit.cover),
              ),
              InkWell(
                onTap: () => _pickPetImages(pet),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ================= COMMON WIDGETS =================

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    TextInputType? keyboardType, // Added this
  }) {
    final required = label.contains('*');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboardType, // Use the optional keyboard type
            decoration: InputDecoration(
              hintText: hint ?? label.replaceAll('*', ''),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (v) =>
                required && (v == null || v.isEmpty) ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, PetFormModel pet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: pet.species,
            items: const [
              'Dog',
              'Cat',
              'Goat',
              'Other',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => pet.species = v!),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notes(PetFormModel pet) {
    return TextFormField(
      controller: pet.notesCtrl,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Notes',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _genderField(PetFormModel pet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender *',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          Row(
            children: ['Male', 'Female'].map((e) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(e),
                  value: e,
                  groupValue: pet.gender,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => pet.gender = v!),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _vaccine(String title, VaccinationModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Checkbox(
            value: model.isSelected,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => model.isSelected = v!),
          ),
          Expanded(child: Text(title)),
          TextButton(
            onPressed: model.isSelected ? () => _pickDate(model) : null,
            child: Text(
              model.date == null
                  ? 'Select date'
                  : '${model.date!.day}/${model.date!.month}/${model.date!.year}',
            ),
          ),
        ],
      ),
    );
  }
}
