import 'package:flutter/material.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicione um novo Post'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.black38,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
