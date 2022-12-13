import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/auth/signin.dart';
import 'package:myapp/model/game.dart';
import 'package:myapp/library/grid_cell.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/util/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridHome extends StatefulWidget {
  const GridHome({super.key});
  @override
  State<GridHome> createState() => _GridHomeState();
}

class _GridHomeState extends State<GridHome> {
  final List<Game> games = [];
  late Future<bool> fetchedData;

  Future<bool> fetchData() async {
    //url
    final shared = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names
    final String? Id = shared.getString('Id');
    Uri url = Uri.parse("$BASE_URL/library/$Id");
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    await http.get(url, headers: headers).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        for (var item in data) {
          games.add(Game(item['_id'], item['image'], item['title'],
              item['description'], item['price'],
              quantity: item['quantity']));
        }
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

    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchedData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: fetchedData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      return GridCell(games[index]);
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
