import 'package:flutter/material.dart';

import '../functions/variabels.dart';

class textfield extends StatefulWidget {
  const textfield({
    Key? key,
    this.hei,
    this.icon,
    this.hint,
    this.wid,
    this.controller,
    this.focus,
  }) : super(key: key);
  final hei;
  final wid;
  final icon;
  final hint;
  final controller;
  final focus;

  @override
  State<textfield> createState() => _textfieldState();
}

class _textfieldState extends State<textfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.hei,
      width: widget.wid,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
        ),
        boxShadow: const [
          BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Color.fromARGB(255, 231, 231, 231))
        ],
      ),
      child: TextFormField(
          focusNode: widget.focus,
          controller: widget.controller,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintText: widget.hint,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            prefixIcon: Icon(widget.icon, color: primary),
          )),
    );
  }
}
