import 'dart:io';
import 'package:flutter/material.dart';
import 'vaccination_model.dart';

class PetFormModel {
  final formKey = GlobalKey<FormState>();

  final petNameCtrl = TextEditingController();
  final breedCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final monthCtrl = TextEditingController();
  final kgCtrl = TextEditingController();
  final gmCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  String species = 'Dog';
  String gender = 'Male';

  final rabies = VaccinationModel();
  final dhppi = VaccinationModel();
  final kennel = VaccinationModel();

  final List<File> petImages = [];

  void dispose() {
    petNameCtrl.dispose();
    breedCtrl.dispose();
    yearCtrl.dispose();
    monthCtrl.dispose();
    kgCtrl.dispose();
    gmCtrl.dispose();
    notesCtrl.dispose();
  }
}
