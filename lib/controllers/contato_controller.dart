import 'package:agenda/models/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContatoController {
  final String contatosTabela = "contatosTabela";
  static final ContatoController _instancia = ContatoController.internal();
  factory ContatoController() => _instancia;
  Database _banco;

  ContatoController.internal();

  Future<Database> get banco async {
    if (_banco != null) return _banco;

    _banco = await initBanco();
    return _banco;
  }

  Future<Database> initBanco() async {
    final bancosCaminho = await getDatabasesPath();
    final caminho = join(bancosCaminho, "contatos.db");

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: (Database banco, int newerVersion) async {
        await banco.execute(
          "CREATE TABLE $contatosTabela($idColuna INTEGER PRIMARY KEY, $nomeColuna TEXT, $emailColuna TEXT,"
          "$telefoneColuna TEXT, $imagemColuna TEXT)"
        );
      }
    );
  }

  Future<Contato> salvarContato(Contato contato) async {
    Database bancoContato = await banco;

    contato.id = await bancoContato.insert(
      contatosTabela, 
      contato.toMap()
    );

    return contato;
  }

  Future<Contato> obterContato(int id) async {
    Database bancoContato = await banco;

    List<Map> mapas = await bancoContato.query(
      contatosTabela,
      columns: [idColuna, nomeColuna, emailColuna, telefoneColuna, imagemColuna],
      where: "$idColuna = ?",
      whereArgs: [id]
    );

    if (mapas.length > 0) return Contato.fromMap(mapas.first);
    return null;
  }

  Future<int> deletarContato(int id) async {
    Database bancoContato = await banco;

    return await bancoContato.delete(
      contatosTabela,
      where: "$idColuna = ?",
      whereArgs: [id]
    );
  }

  Future<int> atualizarContato(Contato contato) async {
    Database bancoContato = await banco;

    return await bancoContato.update(
      contatosTabela, 
      contato.toMap(),
      where: "$idColuna = ?",
      whereArgs: [contato.id]
    );
  }

  Future<List> obterTodosContatos() async {
    Database bancoContato = await banco;

    List listaMapas = await bancoContato.rawQuery("SELECT * FROM $contatosTabela");
    List<Contato> listaContatos = List();

    for(Map mapa in listaMapas) {
      listaContatos.add(Contato.fromMap(mapa));
    }

    return listaContatos;
  }

  Future<int> obterQuantidade() async {
    Database bancoContato = await banco;
    return Sqflite.firstIntValue(await bancoContato.rawQuery("SELECT COUNT(1) FROM $contatosTabela"));
  }

  Future fechar() async {
    Database bancoContato = await banco;
    bancoContato.close();
  }
}