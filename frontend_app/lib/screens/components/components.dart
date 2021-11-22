import 'package:flutter/material.dart';

//-------- Input's do projeto --------
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

//-------- Botões (azul) do projeto --------
TextButton kTextButton(String text, Function onPressed) {
  return TextButton(
      child: Text(text, style: TextStyle(color: Colors.white)),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.blue),
          padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.symmetric(vertical: 10))),
      onPressed: () => onPressed());
}

//-------- Text de cadastro e entrar, nas telas de login e cadastro --------
Row kLoginRegisteHint(String text, String textGesture, Function onTap) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(text),
    GestureDetector(
        child: Text(textGesture, style: TextStyle(color: Colors.blue)),
        onTap: () => onTap)
  ]);
}
