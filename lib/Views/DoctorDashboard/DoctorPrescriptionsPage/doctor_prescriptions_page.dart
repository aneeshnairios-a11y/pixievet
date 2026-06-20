// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pixievet_app/APIManager/DoctorPrescriptionSubmit/doctor_prescription_submit_request_model.dart';
import 'package:pixievet_app/APIManager/DoctorPrescriptionSubmit/doctor_prescription_submit_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:pixievet_app/app_init_page.dart';

class DoctorPrescriptionsPage extends StatefulWidget {
  final String appointmentId;

  const DoctorPrescriptionsPage({super.key, required this.appointmentId});

  @override
  State<DoctorPrescriptionsPage> createState() =>
      _DoctorPrescriptionsPageState();
}

class _DoctorPrescriptionsPageState extends State<DoctorPrescriptionsPage> {
  final TextEditingController notesController = TextEditingController();
  final List<MedicineModel> medicines = [];
  File? attachedFile; // Only one file allowed
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  // ---------------- ADD MEDICINE ----------------

  void _addMedicine() {
    setState(() {
      medicines.add(MedicineModel());
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  // ---------------- FILE PICKERS ----------------

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        attachedFile = File(image.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        attachedFile = File(image.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        attachedFile = File(result.files.single.path!);
      });
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Add Prescription',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Medicines'),
                  const SizedBox(height: 12),
                  ...List.generate(
                    medicines.length,
                    (index) => _medicineCard(index),
                  ),
                  TextButton.icon(
                    onPressed: _addMedicine,
                    icon: const Icon(Icons.add, color: AppColors.primary),
                    label: Text(
                      'Add Medicine',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Other Notes'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter additional instructions or notes',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Attach Document / Image'),
                  const SizedBox(height: 12),
                  _uploadButtons(),
                  if (attachedFile != null) ...[
                    const SizedBox(height: 12),
                    _attachedFileCard(),
                  ],
                ],
              ),
            ),
          ),
          _bottomSaveButton(),
        ],
      ),
    );
  }

  // ---------------- COMPONENTS ----------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _medicineCard(int index) {
    final medicine = medicines[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Medicine ${index + 1}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: () => _removeMedicine(index),
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => medicine.name = v,
            decoration: const InputDecoration(hintText: 'Medicine Name'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => medicine.dosage = v,
                  decoration: const InputDecoration(
                    hintText: 'Dosage (e.g. 1-0-1)',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: (v) => medicine.duration = v,
                  decoration: const InputDecoration(
                    hintText: 'Duration (days)',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _uploadButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _uploadButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          onTap: _pickFromCamera,
        ),
        _uploadButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          onTap: _pickFromGallery,
        ),
        _uploadButton(
          icon: Icons.attach_file,
          label: 'Document',
          onTap: _pickDocument,
        ),
      ],
    );
  }

  Widget _uploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            color: AppColors.white,
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(label, style: GoogleFonts.poppins(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachedFileCard() {
    final fileName = attachedFile!.path.split('/').last;
    final isImage = [
      'jpg',
      'jpeg',
      'png',
    ].contains(fileName.split('.').last.toLowerCase());

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isImage
                ? Image.file(attachedFile!, fit: BoxFit.cover)
                : const Icon(Icons.insert_drive_file, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                attachedFile = null;
              });
            },
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _bottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: _isSubmitting ? null : _submitPrescription,
          child: _isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Save Prescription',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }

  String _buildMedicinesJson() {
    final medicinesList = medicines
        .where(
          (m) =>
              m.name.trim().isNotEmpty &&
              m.dosage.trim().isNotEmpty &&
              m.duration.trim().isNotEmpty,
        )
        .map(
          (m) => {
            'name': m.name.trim(),
            'dosage': m.dosage.trim(),
            'duration': m.duration.trim(),
          },
        )
        .toList();

    return jsonEncode(medicinesList);
  }

  Future<void> _submitPrescription() async {
    if (_isSubmitting) return;

    if (medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one medicine')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final userId = await SessionManager().getUserId();
    final deviceId = await DeviceUtils.getDeviceId();
    final token = await SessionManager().getToken();

    try {
      final service = DoctorPrescriptionSubmitService();

      final request = DoctorPrescriptionSubmitRequestModel(
        userId: userId ?? '',
        token: token ?? '',
        deviceId: deviceId,
        appointmentId: widget.appointmentId,
        description: 'Doctor prescription',
        medicinesJson: _buildMedicinesJson(),
        notes: notesController.text.trim(),
        files: attachedFile != null ? [attachedFile!] : null,
      );

      final response = await service.submitPrescription(request);

      if (!mounted) return;

      if (response.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AppInitPage(fromLoginFlow: false),
          ),
          (_) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

// ---------------- MODEL ----------------

class MedicineModel {
  String name = '';
  String dosage = '';
  String duration = '';
}
