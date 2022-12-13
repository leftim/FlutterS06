import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/util/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);
  static const String routeName = "/Update";
  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late String? _currentPassword;
  late String? _newPassword;
  late String? _address;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres du profil"),
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/minecraft.jpg",
                    width: 460, height: 215)),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Mot de passe actuel"),
                onSaved: (String? value) {
                  _currentPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  } else if (value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nouveau mot de passe"),
                onSaved: (String? value) {
                  _newPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  } else if (value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Adresse de facturation"),
                onSaved: (String? value) {
                  _address = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  } else if (value.length < 20) {
                    return "Le mot de passe doit avoir au moins 20 caractères";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: ElevatedButton(
                child: const Text("Enregistrer"),
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();
                    final prefs = await SharedPreferences.getInstance();
                    final String? userId = prefs.getString('userId');
                    Uri addUri = Uri.parse("$BASE_URL/user/$userId");

                    //data to send
                    Map<String, dynamic> userObject = {
                      "address": _address,
                      "password": _newPassword
                    };

                    //data to send
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                    };

                    http
                        .patch(addUri,
                            headers: headers, body: json.encode(userObject))
                        .then((response) async {
                      if (response.statusCode == 200) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Information"),
                              content: const Text("Changements enregistrés"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Dismiss"))
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Erreur"),
                              content: const Text("Erreur serveur"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Dismiss"))
                              ],
                            );
                          },
                        );
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
