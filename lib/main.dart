import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'model/lista.dart';
import 'model/usuarios.dart';

void main() async {
  //Registrar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "listaFacil",
    theme: ThemeData(
      primaryColor: Colors.green,
    ),
    initialRoute: "/login",
    routes: {
      "/principal": (context) => Principal(),
      "/informacoes": (context) => Informacoes(),
      "/lista": (context) => Lista(),
      "/login": (context) => Login(),
    },
  ));

/*   var db = FirebaseFirestore.instance;
  db.collection("usuarios").add({"login": "thiago", "senha": "thiago"}); */

/* db.collection("usuarios").doc("login00001").set(
    {
      "login": "thiago",
      "senha": "thiago" 

    }

 ); */
}

///// LOGIN

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
  static fromMap(Map<String, dynamic> data, String id) {}
}

class _LoginState extends State<Login> {
  var db = FirebaseFirestore.instance;
  List<Usuarios> lista = List();
  StreamSubscription<QuerySnapshot> ouvinte;

  @override
  void initState() {
    super.initState();
    ouvinte?.cancel();
    ouvinte = db.collection("usuarios").snapshots().listen((res) {
      setState(() {
        lista = res.docs.map((e) => Usuarios.fromMap(e.data(), e.id)).toList();
      });
    });
  }

  var formkey = GlobalKey<FormState>();

  TextEditingController varLogin = TextEditingController();
  TextEditingController varSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista Fácil"),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Form(
                  key: formkey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: campoUsuario("Usuário", varLogin),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: campoSenha("Senha", varSenha),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: btnLogin("Entrar     "),
                    ),
                  ]))),
        ));
  }

  Widget campoUsuario(rotulo, variavelControle) {
    return Container(
      child: TextFormField(
        controller: variavelControle,
        cursorColor: Colors.white,
        style: TextStyle(fontSize: 20, color: Colors.black),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black),
          fillColor: Colors.white,
          filled: true,
          labelText: rotulo,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value.contains(" ")) {
            return "Usuário inválido!!";
          }
          return null;
        },
      ),
    );
  }

  Widget campoSenha(rotulo, variavelControle) {
    return Container(
      child: TextFormField(
          controller: variavelControle,
          obscureText: true,
          cursorColor: Colors.white,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.black),
            labelText: rotulo,
            fillColor: Colors.white,
            filled: true,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.length <= 5) {
              return "Senha inválida!";
            }
            return null;
          }),
    );
  }

  Widget btnLogin(rotulo) {
    return Container(
      margin: EdgeInsets.only(left: 150, right: 150),
      alignment: Alignment.center,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: SizedBox.expand(
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rotulo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35,
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                child: SizedBox(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            String loginbanco = varLogin.text;
            String senhabanco = varSenha.text;
            bool validabanco = false;
            if (formkey.currentState.validate()) {
              setState(() {
                lista.forEach((element) {
                  if (loginbanco == element.login &&
                      senhabanco == element.senha) {
                    validabanco = true;
                  }
                });

                if (!validabanco) {
                  varLogin.clear();
                  varSenha.clear();
                }

                if (validabanco) {
                  Navigator.pushNamed(context, "/principal");
                  varLogin.clear();
                  varSenha.clear();
                }
              });
            }
          },
        ),
      ),
    );
  }
}

///// PRINCIPAL

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Fácil"),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: ListView(
          children: [
            Text(
              "Opções",
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              hoverColor: Colors.grey[400],
              leading:
                  Icon(Icons.announcement, size: 35, color: Colors.green[300]),
              title: Text("Informações", style: TextStyle(fontSize: 36)),
              onTap: () {
                Navigator.pushNamed(context, "/informacoes");
              },
            ),
            ListTile(
              hoverColor: Colors.grey[400],
              leading: Icon(Icons.pending_actions,
                  size: 35, color: Colors.green[300]),
              title: Text("Lista de Tarefas", style: TextStyle(fontSize: 36)),
              onTap: () {
                Navigator.pushNamed(context, "/lista");
              },
            ),
          ],
        ),
      ),
    );
  }
}

///// INFORMAÇÕES
class Informacoes extends StatefulWidget {
  @override
  _InformacoesState createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Fácil"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Image.asset(
                'imagens/thiago.jpg',
                scale: 2.5,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Aluno: Thiago Martins Menegusso",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Projeto criado para a disciplicina de Programação para Dispositivos Móveis. Para tal, foi desenvolvido um aplicativo de simples acesso para criação de lista de itens ou tarefas, com a possibilidade de compartilhamento por email ou mensagem.",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

///// LISTA
class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var txtTarefa = TextEditingController();
  var items = List<String>();
  List<bool> listacheckboxValue = new List<bool>();

  var db = FirebaseFirestore.instance;
  List<Listab> lista = List();
  StreamSubscription<QuerySnapshot> ouvinte;

  @override
  void initState() {
    items.sort();
    super.initState();
    ouvinte?.cancel();
    ouvinte = db.collection("lista").snapshots().listen((res) {
      setState(() {
        lista = res.docs.map((e) => Listab.fromMap(e.data(), e.id)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Lista Fácil"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: txtTarefa,
                    onSubmitted: (value) {
                      setState(() {
                        listacheckboxValue.add(false);
                        items.add(txtTarefa.text);
                        txtTarefa.text = '';
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Tarefa adicionada com sucesso.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Incluir item",
                    ),
                  ),
                ),
                SizedBox(width: 30),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    String itembanco = txtTarefa.text;
                    setState(() {
                      listacheckboxValue.add(false);
                      items.add(txtTarefa.text);
                      txtTarefa.text = '';
                      scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Tarefa adicionada com sucesso.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      db.collection("lista").add({"item": itembanco});
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            setState(() {
                              listacheckboxValue[index] =
                                  !listacheckboxValue[index];
                            });
                          },
                          child: listacheckboxValue[index]
                              ? Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.grey,
                                ),
                        ),
                        title:
                            Text(items[index], style: TextStyle(fontSize: 24)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                              listacheckboxValue.removeAt(index);
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Tarefa removida com sucesso.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(thickness: 1, color: Colors.grey);
                  },
                  itemCount: items.length),
            ),
          ],
        ),
      ),
    );
  }
}
