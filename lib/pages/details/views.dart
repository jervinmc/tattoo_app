import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tattoo_ap/pages/config/global.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
class Details extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  _DetailsState createState() => _DetailsState(this.args);
}

class _DetailsState extends State<Details> {
  String _range = '';
  String _rangeCount = '';
  String _selectedDate = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        var _range =
            '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        print(_selectedDate);
      } else if (args.value is List<DateTime>) {
        // _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
    void paypalCheckout()async{
     final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
  // addToBook(false);
String username = "AfhkPCUFnmyofuwN3OSicO7Z83gKoXlDUmba7meh3GewvB6eC1nQ74JrMCSANpYyUudyjEvZBoda-5q-";
String password = "EFmDE0yWqqoyTN6LuLgF7Wn0j2iZGq8gSkSOGzaNlfHKZy2upl2FkbriFlgk55_SGmFSvIVgmVf9cXdk";
var bytes = utf8.encode("$username:$password");
var credentials = base64.encode(bytes);
Map token = {
'grant_type': 'client_credentials'
};

 
 var headers = {
 "Accept": "application/json",
 'Accept-Language': 'en_US',
 "Authorization": "Basic $credentials"
  };

 var url = "https://api.sandbox.paypal.com/v1/oauth2/token";
 var requestBody = token;
 http.Response response = await http.post(Uri.parse(url), body: requestBody, headers: headers);
 var responseJson = json.decode(response.body);
 print(responseJson['access_token']);
    var params1 = {
  "intent": "sale",
  "payer": {
    "payment_method": "paypal"
  },
  "transactions": [{
    "amount": {
      "total": "25.00",
      "currency": "USD",
      "details": {
        "subtotal": "25.00"
      }
    },
    "description": "This is the payment transaction description.",
    "custom": "EBAY_EMS_90048630024435",
    "invoice_number": "48787582672",
    "payment_options": {
      "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
    },
    "soft_descriptor": "ECHI5786786",
    "item_list": {
      "items": [{
        "name": "handbag",
        "description": "Black color hand bag",
        "quantity": "1",
        "price": "25",
        "sku": "product34",
        "currency": "USD"
      }],
      "shipping_address": {
        "recipient_name": "Hello World",
        "line1": "4thFloor",
        "line2": "unit#34",
        "city": "SAn Jose",
        "country_code": "US",
        "postal_code": "95131",
        "phone": "011862212345678",
        "state": "CA"
      }
    }
  }],
  "note_to_payer": "Contact us for any questions on your order.",
  "redirect_urls": {
    "return_url": "http://10.0.2.2:8000/api/v1",
    "cancel_url": "https://example.com"
  }
};
url = "https://api-m.sandbox.paypal.com/v1/payments/payment";
 var headers_payment = {
 "Accept": "application/json",
 'Accept-Language': 'en_US',
 "Authorization": "Bearer ${responseJson['access_token']}",
 "Content-Type": "application/json"
  };
  http.Response response_payment = await http.post(Uri.parse(url), body: json.encode(params1), headers: headers_payment);
 var responseJson_payment = json.decode(response_payment.body);
 print(responseJson_payment['links'][1]['href']);
    // if (await canLaunch(responseJson_payment['links'][1]['href']))
    //   await launch(responseJson_payment['links'][1]['href']);
    // else 
    //   // can't launch url, there is some error
    //   throw "Could not launch $responseJson_payment['links'][1]['href']";
  

  // launchURL(responseJson_payment['links'][1]['href']);
    if (await canLaunch(responseJson_payment['links'][1]['href'])) {
      await launch(responseJson_payment['links'][1]['href']);
    } else {
      throw 'Could not launch $url';
    }
// http.Response response_checkout = await http.post(Uri.parse(url), body: requestBody, headers: headers_payment);
//  var responseJson_checkout = json.decode(response_checkout.body);

 return responseJson;




  }

  TextEditingController _quantity = new TextEditingController();
  static String BASE_URL = '' + Global.url + '/transaction/';
  void addToBook(val) async {
    setState(() {
      _load = true;
    });
    print(_selectedDate);
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
      "tattoo_name": args[2],
      "status": "Pending",
      "user_id": _id,
      "design_id": args[1],
      "artist_id": args[4],
      "image": args[0],
      "price": args[3],
      "transaction_date": _selectedDate
    };
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    final data = json.decode(response.body);
   if(val){
      AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: "Successfull Requested !",
      desc: "",
      btnOkOnPress: () {
        Get.toNamed('/home');
      },
    )..show();
   }
  }

  bool isLiked = false;
//  void initState() {
//    viewStatusLike();
//     // print('NDFAJEHWFIHJEDIFJAIJWEFOJAWEJFIJAODJFAWE');
//     getData();

//     // TODO: implement initState
//     super.initState();
//   }
  final args;
  _DetailsState(this.args);
  bool _load = false;
  List data = [];

  Future<String> getData() async {
    print('okay');
    setState(() {
      _load = true;
    });
    // final response = await http.get(
    //     Uri.parse(BASE_URL + '/' + '${args[1]}'),
    //     headers: {"Content-Type": "application/json"});
    setState(() {
      try {
        _load = false;
        // data = json.decode(response.body);
        print(data);
      } finally {
        _load = false;
      }
    });
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${args[2]}"),
        backgroundColor: Color(0xff222f3e),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                    height: 200,
                    width: 400,
                    child: Image.network(args[0], fit: BoxFit.cover)),
                // Positioned(
                //   child: IconButton(
                //     icon: Icon(
                //       Icons.favorite,
                //       size: 30,
                //       color: isLiked ? Colors.red : Colors.grey,
                //     ),
                //     onPressed: () {
                //       // addLike();
                //       Get.toNamed('/home');
                //     },
                //   ),
                //   top: 10,
                //   right: 10,
                // )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Container(
                height: 500,
                child: ListView(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Php ${args[3]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Estimated time: ${args[6]} Minutes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text("Description:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Column(children: [
                              Text(args[5], style: TextStyle(fontSize: 15.0))
                            ]),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          )),
                      //       SfDateRangePicker(
                      //   onSelectionChanged: _onSelectionChanged,
                      //   selectionMode: DateRangePickerSelectionMode.single,
                      //   initialSelectedRange: PickerDateRange(
                      //       DateTime.now().subtract(const Duration(days: 4)),
                      //       DateTime.now().add(const Duration(days: 3))),
                      // ),
                      // TextButton(
                      //     onPressed: () {
                      //       DatePicker.showDatePicker(context,
                      //           showTitleActions: true,
                      //           minTime: DateTime(2018, 3, 5),
                      //           maxTime: DateTime(2019, 6, 7),
                      //           onChanged: (date) {
                      //         print('change $date');
                      //       }, onConfirm: (date) {
                      //         print('confirm $date');
                      //       },
                      //           currentTime: DateTime.now(),
                      //           locale: LocaleType.en);
                      //     },
                      //     child: Text(
                      //       'show date time picker',
                      //       style: TextStyle(color: Colors.blue),
                      //     )),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        // selectableDayPredicate: (date) {
                        //   // Disable weekend days to select from the calendar
                        //   // if (date.weekday == 6 || date.weekday == 7) {
                        //   //   return false;
                        //   // }

                        //   // return true;
                        // },
                        onChanged: (val) => _selectedDate=val,
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff222f3e)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Text('Appoint Selected Date'),
                              onPressed: () {
                                addToBook(true);
                              },
                            ),
                          ),
                           
                          //  Container(
                          //   padding: EdgeInsets.all(15),
                          //   width: 150,
                          //   child: ElevatedButton(
                          //     style: ButtonStyle(
                          //         backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //             RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(18.0),
                          //                 ))),
                          //     child: Text('Buy Now'),
                          //     onPressed: () {

                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff222f3e)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Text('Paypal'),
                              onPressed: () {
                                  paypalCheckout();
                              },
                            ),
                          ),
                      Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff222f3e)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Text('Try this'),
                              onPressed: () {
                                  Get.toNamed("/augmented",arguments:[args[0]]);
                              },
                            ),
                          ),
                    ],
                  )
                ])),
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
          ],
        ),
      ),
    );
  }
}
