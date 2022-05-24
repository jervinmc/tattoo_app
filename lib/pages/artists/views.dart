import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tattoo_ap/pages/config/global.dart';


class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);
  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  

 static String BASE_URL = '' + Global.url + '/artist/';
  List data = [];
  bool _load = false;
  Future<String> getData() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    final response = await http.get(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"});

    this.setState(() {
      try {
        _load = false;
        data = json.decode(response.body);
      } finally {
        _load = false;
        
      }
    });
    return "";
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artists'),
        backgroundColor: Color(0xff222f3e),
      ),
      body:  _load
                ? Container(
                    color: Colors.white10,
                    width: 70.0,
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Center(
                            child: const CircularProgressIndicator()))
                      ],
                    ),
                  )
                : Container(
        child: new ListView.separated(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: new ListTile(
                  onTap: (){
                          Get.toNamed('/artist_tattoo',arguments:['${data[index]['id']}','${data[index]['firstname']} ${data[index]['lastname']}']);
                        },
                  title: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                    Text("${data[index]['firstname']} ${data[index]['lastname']}")
                  ],),
                  trailing: Column(
                    children: [
                      // Text("${data[index]['transaction_date']}"),
                      // Text("Php ${data[index]['price']}"),
                  
                    ],
                  ),
                ),
                );
              },separatorBuilder: (context, index) {
                  return Text('');
                },
            ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.toNamed('/addmenu');
      //     // Add your onPressed code here!
      //   },
      //   backgroundColor: Color(0xffc6782b),
      //   child: const Icon(Icons.add),
      // ),
    );
  } 

}









