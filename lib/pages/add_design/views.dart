import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;

import 'package:tattoo_ap/pages/config/global.dart';
class AddDesign extends StatefulWidget {


  @override
  _AddDesignState createState() => _AddDesignState();
}

class _AddDesignState extends State<AddDesign> {
  bool isReveal =true;
  // uploadImage(id) async {
  // print("okayy");
  
  //   // final resJson = jsonDecode(res.body);
  //   // var message = resJson['message'];
  //   // setState(() {
  //   //   selectedImage = null!;
  //   // });
  //    AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.SUCCES,
  //     animType: AnimType.BOTTOMSLIDE,
  //     title: "Successfull Created !",
  //     desc: "",
  //     btnOkOnPress: () {
  //       Get.toNamed('/home');
  //     },
  //   )..show();
  // }
  late  io.File selectedImage;
  String url = '';
   void runFilePiker() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
        print("not okay");

    if (pickedFile != null) {
       selectedImage = io.File(pickedFile.path);
      url = pickedFile.path;
      print("okay");
      setState(() {
          print(url);
      });
    }
  }
  static String BASE_URL = ''+Global.url+'/design/';
  bool _load = false;
  void notify(DialogType type , title, desc){
      AwesomeDialog(
                context: context,
                dialogType:type,
                animType: AnimType.BOTTOMSLIDE,
                title: title,
                desc: desc,
                btnOkOnPress: () {
                  if(DialogType.ERROR==type){
                    
                  }
                  else{
                    Get.toNamed('/designs');
                  }
                },
                )..show();
    }
  void SignUp() async {
     

    setState(() {
        _load=true;
      });
      var params = {
        "firstname":_firstname.text,
        "lastname":_lastname.text,
        "email":_email.text,
        "password":_password.text,
        "barangay":_barangay.text,
        "city":_city.text,
        "province":_province.text,
        "number":_number.text,
        "age":_age.text,
        "status":"Deactivated",
        "password":_password.text,
        "account_type":'Client',

      };
       final prefs = await SharedPreferences.getInstance();
     print(prefs.getBool("isLoggedIn"));
       final request = http.MultipartRequest(
        "POST", Uri.parse(BASE_URL));
    final headers = {"Content-type": "multipart/form-data"};
    request.fields['user_id'] =prefs.getInt('_id').toString();
    request.fields['lastname'] = _lastname.text;
    request.fields['email'] = _email.text;
    request.fields['password'] = _password.text;
    request.fields['barangay'] = _barangay.text;
    request.fields['city'] =_city.text;
    request.fields['province'] = _province.text;
    request.fields['number'] =_number.text;
     request.fields['status'] ="Deactivated";
     request.fields['account_type'] ="Client";
          request.fields['age'] =_age.text;


    request.files.add(http.MultipartFile('image',
        selectedImage.readAsBytes().asStream(), selectedImage.lengthSync(),
        filename: selectedImage.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
      setState(() {
        _load=true;
      });
      // final response = await http.post(Uri.parse(BASE_URL),headers: {"Content-Type": "application/json"},body:json.encode(params));
       notify(DialogType.SUCCES, 'Successfully Added', 'You may now check the designs.');
      
  }
  TextEditingController _email = new TextEditingController();
   TextEditingController _firstname = new TextEditingController();
    TextEditingController _lastname = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  TextEditingController _barangay = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _province = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _repassword = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
           appBar: AppBar(
        title: Text('Designs'),
        backgroundColor: Color(0xff222f3e),
      ),
      body: ListView(
        children: [
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      children: <Widget>[
                        Image.asset("assets/logo.jpg",height: 200,),
                        Image.file(io.File(url)),
                        new SizedBox(
                          width: 350.0,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              runFilePiker();
                              //  uploadImage();
                            },
                            child: Text('Upload Image'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff222f3e),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                          )),
                        
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          width: 250,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Add'),
                            onPressed: () {
                            SignUp();
                            },
                          ),
                        ),
                    
                           _load ? Container(
                            color: Colors.white10,
                            width: 70.0,
                            height: 70.0,
                            child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
                          ) : Text('')
                      ],
                  ),
                ),
              ),
              
            ],
          )
        ],
      )
    ),
    );
}
}