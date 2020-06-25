import 'dart:io';
import 'package:agenda/controllers/contato_controller.dart';
import 'package:agenda/models/contato.dart';
import 'package:agenda/views/contato.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ContatoController controlador = ContatoController();
  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();
    _obterTodosContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (contexto) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _ordenarLista,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarPaginaContato,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contatos.length,
        itemBuilder: (contexto, indice) {
          return _cardContato(contexto, indice);
        },
      )
    );
  }

  Widget _cardContato(BuildContext contexto, int indice) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contatos[indice].imagem != null 
                      ? FileImage(File(contatos[indice].imagem))
                      : AssetImage("assets/images/user.png"),
                    fit: BoxFit.cover
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contatos[indice].nome ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      contatos[indice].email ?? "",
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    Text(
                      contatos[indice].telefone ?? "",
                      style: TextStyle(
                        fontSize: 18
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
      onTap: () {
        _mostrarOpcoes(contexto, indice);
      },
    );
  }

  void _mostrarOpcoes(BuildContext contexto, int indice) {
    showModalBottomSheet(
      context: contexto, 
      builder: (contexto) {
        return BottomSheet(
          onClosing: (){}, 
          builder: (contexto) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(contexto);
                        launch("tel:${contatos[indice].telefone}");
                      }, 
                      child: Text(
                        "Ligar",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(contexto);
                        _mostrarPaginaContato(contato: contatos[indice]);
                      }, 
                      child: Text(
                        "Editar",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        controlador.deletarContato(contatos[indice].id);
                        
                        setState(() {
                          contatos.removeAt(indice);
                        });

                        Navigator.pop(contexto);
                      }, 
                      child: Text(
                        "Excluir",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                        ),
                      )
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  void _mostrarPaginaContato({Contato contato}) async {
    final recContato = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ContatoPage(
          contato: contato
        )
      )
    );

    if (recContato != null) {
      if (contato != null) {
        await controlador.atualizarContato(recContato);
      } else {
        await controlador.salvarContato(recContato);
      }

      _obterTodosContatos();
    }
  }

  void _obterTodosContatos() {
    controlador.obterTodosContatos().then((lista) {
      contatos = lista;
      setState(() {});
    });
  }

  void _ordenarLista(OrderOptions resultado) {
    switch (resultado) {
      case OrderOptions.orderaz:
        contatos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      default:
        contatos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
    }

    setState(() {});
  }
}