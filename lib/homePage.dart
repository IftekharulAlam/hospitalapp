// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:myhospitalapp/showProfilePage.dart';

class HomePage extends StatefulWidget {
  String name;
  String type;
  HomePage({Key? key, required this.name, required this.type})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getall(String userType) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.100:8000/getall"),
        body: {"userType": userType});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);

      // return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future getProfileInfo(String nameOf, String typeOf) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.100:8000/getProfileInfo"),
        body: {"name": nameOf, "type": typeOf});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.account_circle_outlined)),
        automaticallyImplyLeading: false,
        title: Title(
            color: const Color.fromARGB(255, 89, 0, 255),
            child: Center(child: const Text("HomePage"))),
        actions: const [
          // Navigate to the Search Screen
          // IconButton(
          //   onPressed: () => Navigator.of(context)
          //       .push(MaterialPageRoute(builder: (_) => SearchPage())),
          //   icon: const Icon(Icons.search),
          // )
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: getProfileInfo(widget.name, widget.type),
          builder: (BuildContext context, AsyncSnapshot sn) {
            if (sn.hasData) {
              List unis = sn.data;
              Uint8List bytes = base64.decode(unis[0]["profilePic"]);
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: unis.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    DrawerHeader(
                        child: Image.memory(
                            base64.decode(unis[index]["profilePic"]))),
                    ListTile(
                      title:
                          Center(child: Text("Name : ${unis[index]["name"]}")),
                    ),
                    ListTile(
                      title: Center(
                          child: Text(" Address : ${unis[index]["address"]}")),
                    ),
                    ListTile(
                      title: Center(
                          child: Text(" Phone : ${unis[index]["phone"]}")),
                    ),
                    widget.type == "User"
                        ? Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: ElevatedButton(
                              child: const Text('Update Profile'),
                              onPressed: () {
                                // _openImagePicker();

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => UpdateProfilePage(
                                //       address: unis[index]["address"],
                                //       phone: unis[index]["phone"],
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                          )
                        : Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: ElevatedButton(
                              child: const Text('Update Profile'),
                              onPressed: () {
                                // _openImagePicker();

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => UpdateProfileWorker(
                                //       address: unis[index]["address"],
                                //       phone: unis[index]["phone"],
                                //       workingHour: unis[index]["workingHour"],
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                          ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          // _openImagePicker();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            if (sn.hasError) {
              return Center(child: Text("Error Loading Data"));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: getall(widget.type),
        builder: (BuildContext context, AsyncSnapshot sn) {
          if (sn.hasData) {
            List unis = sn.data;
            return ListView.builder(
              itemCount: unis.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => showProfilePage(
                        name: "${unis[index]["name"]}",
                        address: "${unis[index]["address"]}",
                        phone: "${unis[index]["phone"]}",
                        workingHour: "${unis[index]["workingHour"]}",
                        bytes: base64.decode(unis[index]["profilePic"]),
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading:
                        Image.memory(base64.decode(unis[index]["profilePic"])),
                    title: Text("${unis[index]["name"]}"),
                    subtitle: Text("${unis[index]["phone"]}"),
                  ),
                ),
              ),
            );
          }
          if (sn.hasError) {
            return Center(child: Text("Error Loading Data"));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
