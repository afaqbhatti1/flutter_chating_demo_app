import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.validator,
    required this.controller,
    required this.hintText,
    this.textInputType,
    this.isPassword,
  });

  TextEditingController controller;
  String hintText;
  bool? isPassword;
  String? Function(String?)? validator;
  TextInputType? textInputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      cursorColor: Colors.black,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: widget.textInputType ?? TextInputType.text,
      obscureText: widget.isPassword ?? false,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
        filled: false,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        suffixIcon: widget.isPassword == null
            ? const Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              )
            : widget.isPassword == true
                ? GestureDetector(
                    onTap: () {
                      widget.isPassword = !widget.isPassword!;
                      setState(() {});
                    },
                    child: const Icon(
                      CupertinoIcons.eye_slash,
                      color: Colors.grey,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      widget.isPassword = !widget.isPassword!;
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  ),
        hintText: widget.hintText,
      ),
    );
  }
}
