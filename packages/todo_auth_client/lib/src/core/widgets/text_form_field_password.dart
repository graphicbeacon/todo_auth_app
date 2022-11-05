import 'package:flutter/material.dart';

class TextFormFieldPassword extends StatefulWidget {
  const TextFormFieldPassword({
    this.labelText,
    this.controller,
    this.validator,
    super.key,
  });

  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<TextFormFieldPassword> createState() => _TextFormFieldPasswordState();
}

class _TextFormFieldPasswordState extends State<TextFormFieldPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        counterText: '',
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
        ),
      ),
      validator: widget.validator,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
