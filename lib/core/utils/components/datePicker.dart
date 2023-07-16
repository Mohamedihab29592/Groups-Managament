import 'package:flutter/material.dart';

import 'constats.dart';


class MyDatePicker extends StatefulWidget {
  final String? hint;
  final String title;
  TextEditingController? controller;
  TextStyle? hintStyle;


  MyDatePicker(
      {Key? key, this.hint, required this.title,  this.controller,this.hintStyle})
      : super(key: key);

  @override
  State<MyDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey[100]),
          height: 60,
          width: double.infinity,
          child: TextFormField(
            keyboardType: TextInputType.datetime,
            readOnly: true,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: widget.hintStyle,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  onPressed: () {
                    showDate();
                  }),
            ),
            onTap: () {
              showDate();

              },
            validator: (value) {
              if (value!.isEmpty) {
                return " Date can not be empty";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void showDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            hintColor: Colors.red,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(background: Colors.red.shade100),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (date != null) {
      widget.controller!.text = Constants.inputFormat.format(date);
    }
  }

}
