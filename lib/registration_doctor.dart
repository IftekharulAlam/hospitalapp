import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class RegistrationDoctor extends StatefulWidget {
  const RegistrationDoctor({super.key});

  @override
  State<RegistrationDoctor> createState() => _RegistrationDoctorState();
}

class _RegistrationDoctorState extends State<RegistrationDoctor> {
  String dropdownvalue = 'Doctor';
  var items = ['Doctor', 'Nurse','Wardboy','Manager','Staff'];
  static const String _title = 'My Hospital';
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final _picker = ImagePicker();

  File? _image;
  String filepath = "";

  Future<void> _openImagePicker() async {
    try {
      var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
          filepath = pickedImage.path;
        });
        // uploadImage(pickedImage.path);
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> register(filePath) async {
    // your token if needed
    try {
      // your endpoint and request method
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://192.168.0.100:8000/registrationUser"));

      request.fields.addAll({
        'name': name.text,
        'password': password.text,
        'address': address.text,
        'phone': phone.text
      });
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Registration Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        name.text = "";
        address.text = "";
        phone.text = "";
        password.text = "";
        filepath = "";

        Future.delayed(
          const Duration(seconds: 2),
          () {
            Fluttertoast.showToast(
                msg: "Redirecting to Login Page",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        );
        Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.pop(context);
          },
        );
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'My Hospital',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Registration',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Upload Profile Picture'),
                onPressed: () {
                  _openImagePicker();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Department Name',
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  underline: Container(),
                  style: const TextStyle(
                      //te
                      color: Colors.black, //Font color
                      fontSize: 18 //font size on dropdown button
                      ),
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Register'),
                onPressed: () {
                  if (filepath != "" &&
                      name.text != "" &&
                      address.text != "" &&
                      phone.text != "" &&
                      password.text != "") {
                    register(filepath);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Already have account?'),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //login screen
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
