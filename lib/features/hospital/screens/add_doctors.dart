import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchi/core/common/errortext.dart';
import 'package:parchi/core/common/loader.dart';
import 'package:parchi/features/auth/screens/textformfield.dart';
import 'package:parchi/features/hospital/controller/hospital_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:routemaster/routemaster.dart';

class AddDoctorsScreen extends ConsumerStatefulWidget {
  final String id;
  const AddDoctorsScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDoctorsScreenState();
}

class _AddDoctorsScreenState extends ConsumerState<AddDoctorsScreen> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  File? _selectedImage;

  void navigateToHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  Future<void> _pickImage() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null && result.files.single.path != null) {
          setState(() {
            _selectedImage = File(result.files.single.path!);
          });
        }
      } catch (e) {
        ErrorText(error: e.toString());
      }
    } else {
      const AlertDialog(
        title: Text("Some internal error occured try without picking image"),
      );
    }
  }

  void addDoctor() {
    final hospitalController = ref.watch(hospitalControllerProvider.notifier);
    hospitalController.addDoctor(
        _doctorNameController.text,
        _startTimeController.text,
        _endTimeController.text,
        _specialityController.text,
        _feeController.text,
        _selectedImage,
        context,
        widget.id);
    _doctorNameController.text = '';
    _startTimeController.text = '';
    _endTimeController.text = '';
    _specialityController.text = '';
    _feeController.text = '';
    _selectedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _addDoctorFormKey = GlobalKey<FormState>();
    final isLoading = ref.watch(hospitalControllerProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        title: const Text(
          'Add Doctors',
          style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(233, 241, 241, 241)),
        ),
        leading: IconButton(
            onPressed: () {
              navigateToHome(context);
            },
            icon: const Icon(Icons.home)),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _addDoctorFormKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Textformfield(
                        hintText: 'Name',
                        controller: _doctorNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name of Doctor';
                          }
                          final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
                          if (!nameRegExp.hasMatch(value)) {
                            return 'Name can only contain alphabets and spaces';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Textformfield(
                        hintText: 'Speciality',
                        controller: _specialityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Speciality of Doctor';
                          }
                          final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
                          if (!nameRegExp.hasMatch(value)) {
                            return 'Speciality can only contain alphabets and spaces';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Textformfield(
                        hintText: 'Fee',
                        controller: _feeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Fee of Doctor';
                          }
                          final RegExp nameRegExp = RegExp(r'^[0-9]+$');
                          if (!nameRegExp.hasMatch(value)) {
                            return 'Fee can only contain numbers';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Textformfield(
                        hintText: 'Start Time',
                        controller: _startTimeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Start Time';
                          }
                          final numValue = int.tryParse(value);
                          if (numValue == null ||
                              numValue < 0 ||
                              numValue > 24) {
                            return 'Please enter a valid time between 0 and 24';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Textformfield(
                        hintText: 'End Time',
                        controller: _endTimeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter End Time';
                          }
                          final numValue = int.tryParse(value);
                          if (numValue == null ||
                              numValue < 0 ||
                              numValue > 24) {
                            return 'Please enter a valid time between 0 and 24';
                          }
                          int? startTime =
                              int.tryParse(_startTimeController.text);
                          if (startTime == null) {
                            return 'Invalid start time';
                          }

                          if (numValue <= startTime) {
                            return 'End time should be greater than start time';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => _pickImage(),
                        child: DottedBorder(
                          strokeCap: StrokeCap.round,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          dashPattern: const [4, 10],
                          strokeWidth: 2,
                          color: Colors.grey,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            height: 100,
                            width: double.infinity,
                            child: Center(
                              child: _selectedImage != null
                                  ? Image.file(_selectedImage!)
                                  : const Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_addDoctorFormKey.currentState!.validate()) {
                            addDoctor();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                        ),
                        child: const Text(
                          "Create Doctor",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
