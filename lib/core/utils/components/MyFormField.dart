import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final double radius;
  String? title;
  final String hint;
   int? maxLines;
  TextStyle? hintStyle;
  final TextInputType type;
  final VoidCallback? suffixIconPressed;
  final IconData? suffixIcon;
  final Widget? widget;
  final TextCapitalization ? textCapitalization;
  TextEditingController? controller;
  bool readonly = false;
  final dynamic validation;
  bool isPassword;

  MyFormField(
      {Key? key,
      this.isPassword = false,
      this.radius = 15,
        this.textCapitalization,
      required this.type,
      required this.hint,
      required this.maxLines,
      this.suffixIcon,
      this.suffixIconPressed,
      this.widget,
      this.controller,
      required this.readonly,
      this.hintStyle,
      this.title,
      this.validation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[100],
          ),
          child: TextFormField(
            obscureText: isPassword,
            readOnly: readonly,
            controller: controller,
            keyboardType: type,
            maxLines: maxLines,
            // Allow for dynamic expansion
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: hintStyle,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(

                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      onPressed: () {
                        suffixIconPressed!();
                      },
                      icon: Icon(
                        suffixIcon,
                        color: Colors.blue,
                      ),
                    )
                  : null,
            ),
            validator: validation,
            textCapitalization: textCapitalization!,
          ),
        ),
      ],
    );
  }
}
