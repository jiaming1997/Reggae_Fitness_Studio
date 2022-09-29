import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:reggae_fitness_studio/home/main_home_page.dart';
import 'package:reggae_fitness_studio/profile/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../assets/constants.dart' as constants;

// This class handles the Page to edit the Email Section of the User Profile.
class EditUsernameFormPage extends StatefulWidget {
  const EditUsernameFormPage({Key? key}) : super(key: key);

  @override
  _EditUsernameFormPageState createState() => _EditUsernameFormPageState();
}

class _EditUsernameFormPageState extends State<EditUsernameFormPage> {
  //final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String user_info = '';
  String id = '';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_info = preferences.getString('u_info')!;
      Map<String, dynamic> map = jsonDecode(user_info);
      id = map['u_id'];
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future updateUsername(BuildContext cont) async {
    if (nameController.text == "") {
      Fluttertoast.showToast(
        msg: "Cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    } else {
      var url =
          "http://" + constants.IP_ADDRESS + "/reggaefitness/update_username.php";
      var response = await http.post(Uri.parse(url), body: {
        "u_id": id,
        "name": nameController.text,
      });
      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainHomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ReggaeFitnessTheme.nearlyDarkBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Edit"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 24),
                SizedBox(
                    width: 320,
                    child: const Text(
                      "Enter Your Name",
                      style:
                          TextStyle(fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color:  ReggaeFitnessTheme.nearlyBlack),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name.';
                            }
                            if (value.trim().length < 4) {
                              return 'Name must be at least 4 characters in length';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Please enter your name'),
                          controller: nameController,
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateUsername(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ReggaeFitnessTheme.nearlyDarkBlue,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0),
                              ),
                            ),
                            child: const Text(
                              'UPDATE',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
