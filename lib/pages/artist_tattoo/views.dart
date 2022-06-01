import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tattoo_ap/pages/config/global.dart';

class ArtistTattoo extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  State<ArtistTattoo> createState() => _ArtistTattooState(this.args);
}

class _ArtistTattooState extends State<ArtistTattoo> {
  final args;
   _ArtistTattooState(this.args);
   static String BASE_URL_CATEGORY = '' + Global.url + '/tattoo_market-artist';
 bool _load =false;
    List data = [];
    String _email = '';
     Future<String> getCategory() async {
    _load = true;
    final prefs = await SharedPreferences.getInstance();
      _email = prefs.getString("_email").toString();
    setState(() {
      
    });
    var _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL_CATEGORY + '/' + "${args[0]}/"),
        headers: {"Content-Type": "application/json"});
        String jsonsDataString = response.body.toString();
      final _data = jsonDecode(jsonsDataString);
      data = data;
      print(_data);
        setState(() {
            try {
               data = _data;
              print(data.length);
              print(response);
          
            } finally {
              _load = false;
            }
          });
    return "";
  }
      void initState() {
 
    // TODO: implement initState
    super.initState();
    // getData();
    getCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('${args[1]}'),
        backgroundColor: Color(0xff222f3e),
      ),
    body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            child: Text(
              "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          _load
                ? Container(
                    color: Colors.white10,
                    width: 70.0,
                    height: 70.0,
                    child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Center(
                            child: const CircularProgressIndicator())),
                  )
                : Text(''),
          Container(
            height: 650,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context,index)
            {
              return Column(children: [
                Text(data[index]['category_name'],style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold),),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                  itemCount:data[index]['tattoo_list'].length,
                  itemBuilder: (BuildContext context, idx){
                  return Column(
                  children: [
                    InkWell(
                      child: Card(
                        elevation: 4,
                        // color: Color(0xffc6782b),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.all(20.0),
                        child: Container(
                          // width: 150,
                          // height: 185,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(data[index]['tattoo_list'][idx]['image'].toString(),fit: BoxFit.cover,height:100,width: 100,),
                              
                              Padding(padding: EdgeInsets.only(bottom: 15))
                            ],
                          ),
                        )),
                        onTap:() => Get.toNamed('/details',arguments:["${data[index]['tattoo_list'][idx]['image']}","${data[index]['tattoo_list'][idx]['id']}","${data[index]['tattoo_list'][idx]['tattoo_name']}","${data[index]['tattoo_list'][idx]['price']}","${data[index]['tattoo_list'][idx]['user_id']}","${data[index]['tattoo_list'][idx]['tattoo_name']}","${data[index]['tattoo_list'][idx]['time_estimation']}"]),
                    ),
                    Column(
                      children: [
                        Text(data[index]['tattoo_list'][idx]['tattoo_name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),
                              Text("",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                      ],
                    ),
                        
                    
                  ],
                );
                }),
                )
              ]);
            }))
          ,
        ],
      ),
    );
  }
}