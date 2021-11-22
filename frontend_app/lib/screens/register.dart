import 'package:flutter/material.dart';
import 'package:frontend_app/models/api_response.dart';
import 'package:frontend_app/models/user.dart';
import 'package:frontend_app/screens/components/components.dart';
import 'package:frontend_app/screens/home.dart';
import 'package:frontend_app/screens/login.dart';
import 'package:frontend_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //-------- Variáveis --------
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();
  bool loading = false;

  //-------- Métodos --------
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastre-se'),
          centerTitle: true,
        ),
        body: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            children: [
              TextFormField(
                controller: nameController,
                validator: (val) =>
                    val!.isEmpty ? 'O Nome é um campo obrigatório' : null,
                decoration: kInputDecoration('Nome'),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (val) =>
                    val!.isEmpty ? 'O E-mail é um campo obrigatório' : null,
                decoration: kInputDecoration('E-mail'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) => val!.length < 6
                    ? 'A senha teve ter no mínimo 6 caracteres'
                    : null,
                decoration: kInputDecoration('Senha'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordConfirmController,
                obscureText: true,
                validator: (val) => val != passwordController.text
                    ? 'As senhas não são iguais'
                    : null,
                decoration: kInputDecoration('Confirme a Senha'),
              ),
              SizedBox(height: 20),
              loading
                  ? Center(child: CircularProgressIndicator())
                  : kTextButton('Cadastrar', () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    }),
              SizedBox(height: 20),
              kLoginRegisteHint('Já tem uma conta? ', 'Entre', () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              }),
            ],
          ),
        ));
  }
}
