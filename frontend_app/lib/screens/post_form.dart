import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_app/screens/components/components.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  //-------- Variáveis --------
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _bodyController = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  //-------- Métodos --------
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicione um novo Post'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: _imageFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(_imageFile ?? File('')),
                            fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _bodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (val) => val!.isEmpty
                          ? 'O campo post não pode ser vazio'
                          : null,
                      decoration: InputDecoration(
                          hintText: "Digite aqui...",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38))),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: kTextButton('Postar', () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        _loading = !_loading;
                      });
                    }
                  }),
                )
              ],
            ),
    );
  }
}
