import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tattoo_ap/pages/config/global.dart';


class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);
  @override
  _CartsState createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  

 static String BASE_URL = '' + Global.url + '/transaction_clientid';
 static String BASE_URL_CANCEL = '' + Global.url + '/transaction';
  List data = [];
  bool _load = false;
  Future<String> getData() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    final response = await http.get(Uri.parse(BASE_URL + '/' + _id.toString()),
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
        title: Text('Transactions'),
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
                          Get.toNamed('/details',arguments:['${data[index][2]}','${data[index][0]}','${data[index][1]}']);
                        },
                  title: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                    Image.network(data[index]['image'],height:50.0),
                    Text("${data[index]['status']}")
                  ],),
                  trailing: Column(
                    children: [
                      Text("${data[index]['transaction_date']}"),
                      Text("Php ${data[index]['price']}"),
                    data[index]['status']=='Pending' ? Container(
                      width:100,
                      child:  InkWell(
                        onTap: (){
                           AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            animType: AnimType.BOTTOMSLIDE,
                            title: "Are you sure you want to cancel your appointment?",
                            desc: "",
                            btnOkOnPress: () async{
                                  var params = {
                                    "status": "Cancelled",
                                   
                                  };
                                  final response = await http.patch(Uri.parse(BASE_URL_CANCEL +'/'+"${data[index]['id']}/"),
                                      headers: {"Content-Type": "application/json"},
                                      body: json.encode(params));
                             
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.SUCCES,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: "Successfull Cancelled !",
                                    desc: "",
                                    btnOkOnPress: () {
                                      Get.toNamed('/home');
                                    },
                                  )..show();
                            },
                            btnCancelOnPress: (){

                            }
                          )..show();
                        },
                        child: Row(
                       children: [
                          Icon(Icons.close,color:Colors.red),
                          Text('- Cancel')
                       ],
                     ),
                      )
                    ) : Text('')
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









