class User {
  //Atributos
  int? id; //dizer que pode ser null ?
  String? name;
  String? image;
  String? email;
  String? token;

  //Construtor
  User({this.id, this.name, this.image, this.email, this.token});

  //Função para converter JSON em dados do usuario modal
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}
