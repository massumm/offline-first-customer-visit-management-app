import 'package:flutter/material.dart';

OutlineInputBorder get customInputDecoration {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1,
    ),
  );
}
