import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:zypher_assignment/models/Client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamController<List<Client>> clientStreamController;

  Future<List<Client>> fetchClientList() async {
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/d53400a3-6126-495e-9d16-0b4414b537b3"));

    if (response.statusCode == 200) {
      return Client.fromJsonArray(json.decode(response.body + "}"));
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadClientList() async {
    fetchClientList().then((res) async {
      clientStreamController.add(res);
      return res;
    });
  }

  @override
  void initState() {
    clientStreamController = new StreamController();
    loadClientList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    clientStreamController.done;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zypher"),
      ),
      body: StreamBuilder<List<Client>>(
        stream: clientStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: SvgPicture.asset(
                'assets/images/empty.svg',
                height: 100,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListView.builder(
              // itemCount: 12,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // var client = snapshot.data![index % 3];
                var client = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/images/avatar.svg',
                          height: 50,
                        ),
                        title: Text(client.name),
                        subtitle: Text(client.company),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}