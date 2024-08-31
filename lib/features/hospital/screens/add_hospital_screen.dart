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

class AddHospitalScreen extends ConsumerStatefulWidget {
  const AddHospitalScreen({super.key});

  @override
  ConsumerState<AddHospitalScreen> createState() => _AddHospitalScreenState();
}

class _AddHospitalScreenState extends ConsumerState<AddHospitalScreen> {
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController hospitalLocationController =
      TextEditingController();
  File? _selectedImage;

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

  void addHospital() {
    final hospitalController = ref.watch(hospitalControllerProvider.notifier);
    hospitalController.addHospital(hospitalNameController.text,
        hospitalLocationController.text, _selectedImage, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(hospitalControllerProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        title: const Text(
          'Parchi',
          style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(233, 241, 241, 241)),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Loader()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const Text(
                      'Add Hospital',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          fontFamily: 'RobotoSlab'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Textformfield(
                      hintText: 'Name',
                      controller: hospitalNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name of Hospital';
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
                      hintText: 'Location',
                      controller: hospitalLocationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Location';
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
                        addHospital();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                      ),
                      child: const Text(
                        "Create Hospital",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
      )),
    );
  }
}
