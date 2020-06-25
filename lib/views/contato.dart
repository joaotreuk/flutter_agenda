import 'dart:io';
import 'package:agenda/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPage extends StatefulWidget {
  final Contato contato;

  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final _conNome = TextEditingController();
  final _conEmail = TextEditingController();
  final _conTelefone = TextEditingController();
  final _focoNome = FocusNode();

  bool _usuarioEditou = false;
  Contato _contatoEditado;

  @override
  void initState() {
    super.initState();

    if (widget.contato == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato.toMap()); // Duplicando o contato

      _conNome.text = _contatoEditado.nome;
      _conEmail.text = _contatoEditado.email;
      _conTelefone.text = _contatoEditado.telefone;
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_contatoEditado.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if (_contatoEditado.nome != null && _contatoEditado.nome.isNotEmpty) {
              Navigator.pop(contexto, _contatoEditado);
            } else {
              FocusScope.of(contexto).requestFocus(_focoNome);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _contatoEditado.imagem != null 
                        ? FileImage(File(_contatoEditado.imagem))
                        : AssetImage("assets/images/user.png"),
                      fit: BoxFit.cover
                    )
                  )
                ),
                onTap: () {
                  ImagePicker().getImage(source: ImageSource.camera).then((arquivo) {
                    if (arquivo == null) return;

                    setState(() {
                      _contatoEditado.imagem = arquivo.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _conNome,
                focusNode: _focoNome,
                decoration: InputDecoration(
                  labelText: "Nome"
                ),
                onChanged: (texto) {
                  _usuarioEditou = true;
                  _contatoEditado.nome = texto;
                  setState(() {});
                },
              ),
              TextField(
                controller: _conEmail,
                decoration: InputDecoration(
                  labelText: "E-mail"
                ),
                onChanged: (texto) {
                  _usuarioEditou = true;
                  _contatoEditado.email = texto;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _conTelefone,
                decoration: InputDecoration(
                  labelText: "Telefone"
                ),
                onChanged: (texto) {
                  _usuarioEditou = true;
                  _contatoEditado.telefone = texto;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ), 
      onWillPop: _voltarPagina
    );
  }

  Future<bool> _voltarPagina() {
    if (_usuarioEditou) {
      showDialog(
        context: context,
        builder: (contexto) {
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(contexto);
                }, 
                child: Text("Cancelar")
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(contexto);
                  Navigator.pop(contexto);
                }, 
                child: Text("Sim")
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}