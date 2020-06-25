final String idColuna = "idColuna";
final String nomeColuna = "nomeColuna";
final String emailColuna = "emailColuna";
final String telefoneColuna = "telefoneColuna";
final String imagemColuna = "imagemColuna";

class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  String imagem;

  Contato();

  Contato.fromMap(Map mapa) {
    id = mapa[idColuna];
    nome = mapa[nomeColuna];
    email = mapa[emailColuna];
    telefone = mapa[telefoneColuna];
    imagem = mapa[imagemColuna];
  }

  Map toMap() {
    Map<String, dynamic> mapa = {
      nomeColuna: nome,
      emailColuna: email,
      telefoneColuna: telefone,
      imagemColuna: imagem
    };

    if (id != null) mapa[idColuna] = id;
    return mapa;
  }

  @override
  String toString() {
    return "Contato(id: $id, nome: $nome, email: $email, telefone: $telefone, imagem: $imagem)";
  }
}