import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:tattoo_ap/pages/config/global.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> imgList = [
  'https://anongulam.s3.amazonaws.com/pic1.jpeg',
  'https://anongulam.s3.amazonaws.com/pic10.jpeg',
  'https://anongulam.s3.amazonaws.com/pic11.png',
];
String _email ='';
  bool _load =false;
  List data = [];
    List data_breakfast = [];
    List data_lunch = [];
   String category_data = "";
    List data_dinner = [];
    List data_recommend = [];
   static String BASE_URL = '' + Global.url + '/tattoo/';
     static String BASE_URL_CATEGORY = '' + Global.url + '/tattoo_market/';
   List feature = [];
  Future<String> getData() async {
    _load = true;
    final prefs = await SharedPreferences.getInstance();
      _email = prefs.getString("_email").toString();
    setState(() {
      
    });
    var _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL),
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
  Future<String> getCategory() async {
    _load = true;
    final prefs = await SharedPreferences.getInstance();
      _email = prefs.getString("_email").toString();
    setState(() {
      
    });
    var _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL_CATEGORY),
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
  @override
  void initState() {
 
    // TODO: implement initState
    super.initState();
    // getData();
    getCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('${_email}',style:TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color:  Color(0xff222f3e),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Get.toNamed('/profile');
              },
            ),
            ListTile(
              title: Text('Your Designs'),
              onTap: () {
                Get.toNamed('/user_meals');
              },
            ),
            ListTile(
              title: Text('Appointment'),
              onTap: () {
                Get.toNamed('/carts');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                
                 AwesomeDialog(
                context: context,
                dialogType: DialogType.QUESTION,
                animType: AnimType.BOTTOMSLIDE,
                title: "Are you sure you want to logout?",
                desc: "",
                btnOkOnPress: () async{
                   final prefs = await SharedPreferences.getInstance();
                   prefs.setBool('isLoggedIn', false);
                  Get.toNamed('/starting');
                },
                btnCancelOnPress: (){

                }
              )..show();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff222f3e),
      ),
      body: ListView(
        children: [
          // Container(
          //   padding: EdgeInsets.all(15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       feature.length==0 ? Text('Loading...') :
          //       InkWell(
          //         child:Container(
          //         child:Image.network("${feature[2]}"),
          //       )
          //       ,
          //       onTap:() => {
          //           Get.toNamed('/details',arguments:['${feature[2]}','${feature[0]}','${feature[1]}'])
          //       }
          //       ),
          //        feature.length!=0 ? Column(children:[Text(feature[1],style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold))],crossAxisAlignment:CrossAxisAlignment.center) : Text('')
              
          //     ],
          //   ),
          // ),
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
            height: 500,
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
                        onTap:() => Get.toNamed('/details',arguments:["${data[index]['tattoo_list'][idx]['image']}","${data[index]['tattoo_list'][idx]['id']}","${data[index]['tattoo_list'][idx]['tattoo_name']}","${data[index]['tattoo_list'][idx]['price']}","${data[index]['tattoo_list'][idx]['user_id']}","${data[index]['tattoo_list'][idx]['tattoo_name']}"]),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addmenu');
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xffc6782b),
        child: const Icon(Icons.add),
      ),
    );
  }
}
