// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class showProfilePage extends StatefulWidget {
  String name;
  String address;
  String phone;
  String workingHour;
  Uint8List bytes;
  showProfilePage(
      {Key? key,
      required this.name,
      required this.address,
      required this.phone,
      required this.workingHour,
      required this.bytes})
      : super(key: key);

  @override
  State<showProfilePage> createState() => _showProfilePageState();
}

class _showProfilePageState extends State<showProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: const Color.fromARGB(255, 89, 0, 255),
            child: const Text("Profile")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.memory(width: 300, height: 300, widget.bytes),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Name: ${widget.name}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Adress: ${widget.address}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Phone: ${widget.phone}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Working Hour: ${widget.workingHour}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
