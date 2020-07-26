class User {
  final uid;
  final String nome;
  final String tel;
  final String email;
  
  User({this.nome, this.tel, this.email, this.uid});

  Map<String, dynamic> toMap(){
    return {
      'userId': uid,
      'nome': nome,
      'telefone': tel,
      'email': email,
    };
  }

  User.fromFirestore(Map<String, dynamic> firestore)
    : uid = firestore['userId'],
      nome = firestore['nome'],
      tel = firestore['telefone'],
      email = firestore['email'];
}