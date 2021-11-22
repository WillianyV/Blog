import 'package:flutter/material.dart';
import 'package:frontend_app/models/api_response.dart';
import 'package:frontend_app/models/user.dart';
import 'package:frontend_app/screens/components/components.dart';
import 'package:frontend_app/screens/home.dart';
import 'package:frontend_app/screens/register.dart';
import 'package:frontend_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //-------- Variáveis --------
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  bool loading = false;

  //-------- Métodos --------
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  void _loginUser() async {
    ApiResponse response =
        await login(emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (val) =>
                  val!.isEmpty ? 'O e-mail é um campo obrigatório' : null,
              decoration: kInputDecoration('E-mail'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (val) => val!.length < 6
                  ? 'A senha precisa ter no mínimo 6 caracteres'
                  : null,
              decoration: kInputDecoration('Senha'),
            ),
            SizedBox(height: 10),
            loading
                ? Center(child: CircularProgressIndicator())
                : kTextButton('Entrar', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  }),
            SizedBox(height: 10),
            kLoginRegisteHint('Não tem uma conta?', 'Cadastre-se', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Register()),
                  (route) => false);
            }),
          ],
        ),
      ),
    );
  }
}
