import 'package:flutter/material.dart';

Widget textFormField(controller, label, keyboardType) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
      child: Center(
        child: TextFormField(
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harus diisi';
            }
            return null;
          },
          controller: controller,
          onFieldSubmitted: (value) => controller.text = value,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red, //this has no effect
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
