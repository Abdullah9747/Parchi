import 'package:flutter/material.dart';
import 'package:parchi/features/auth/cnicinputformatter.dart';

class Textformfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final bool iscnic;
  final bool isphone;
  final bool ispass;
  const Textformfield(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.validator,
      this.iscnic = false,
      this.isphone = false,
      this.ispass = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: ispass,
      inputFormatters: iscnic ? [CnicInputFormatter()] : null,
      keyboardType:
          isphone || iscnic ? TextInputType.phone : TextInputType.text,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        errorMaxLines: 2,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 118, 118, 118), width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
