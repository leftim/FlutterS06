import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/util/constantes.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  //var
  static const String routeName = "/Signup";
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //var
  GlobalKey<FormState> formKey = GlobalKey();

  late String username;

  late String email;

  late String pwd;

  late String birth;

  late String address;

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("Assets/minecraft.jpg",
                    width: 460, height: 215)),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                onSaved: (newValue) {
                  username = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "username cannot be empty";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Username"),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                onSaved: (newValue) {
                  email = newValue!;
                },
                validator: (value) {
                  RegExp regex = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (value!.isEmpty) {
                    return "email cannot be empty";
                  } else if (!regex.hasMatch(value)) {
                    return "Email invalid";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                onSaved: (newValue) {
                  pwd = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "password cannot be empty";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Mot de passe"),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                onSaved: (newValue) {
                  birth = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "naissance cannot be empty";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Année de naissance"),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: TextFormField(
                onSaved: (newValue) {
                  address = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "address cannot be empty";
                  }
                },
                maxLines: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Adresse de facturation"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("S'inscrire"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Uri url = Uri.parse("$BASE_URL/user/signup");
                      Map<String, String> headers = {
                        "Content-Type": "application/json",
                      };
                      Map<String, dynamic> userObject = {
                        "username": username,
                        "email": email,
                        "password": pwd,
                        "birth": birth,
                        "address": address
                      };

                      http
                          .post(url,
                              headers: headers, body: json.encode(userObject))
                          .then((response) {
                        if (response.statusCode == 201) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Information"),
                                content: Text(
                                    " Username = $username \n Email = $email \n Password = $pwd \n Naissance = $birth \n Address = $address"),
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
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: const Text("Annuler"),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
