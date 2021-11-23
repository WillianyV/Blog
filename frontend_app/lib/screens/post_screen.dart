import 'package:flutter/material.dart';
import 'package:frontend_app/constant.dart';
import 'package:frontend_app/models/api_response.dart';
import 'package:frontend_app/models/post.dart';
import 'package:frontend_app/screens/login.dart';
import 'package:frontend_app/services/post_service.dart';
import 'package:frontend_app/services/user_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  //variaveis
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;
  //metodos
  //pegar todos os posts
  Future<void> retrievePosts() async {
    userId = await getUseId();
    ApiResponse response = await getPosts();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _postList.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = _postList[index];
              return Text('${post.body}');
            });
  }
}
