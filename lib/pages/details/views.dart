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

  TextEditingController _quantity = new TextEditingController();
  static String BASE_URL = '' + Global.url + '/transaction/';
  void addToBook() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
      "tattoo_name": args[2],
      "status": "Pending",
      "user_id": _id,
      "design_id": args[1],
      "artist_id": args[4],
      "image": args[0],
      "transaction_date": _selectedDate
    };
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    final data = json.decode(response.body);
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
                Positioned(
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // addLike();
                      Get.toNamed('/home');
                    },
                  ),
                  top: 10,
                  right: 10,
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Container(
                height: 420,
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
                        selectableDayPredicate: (date) {
                          // Disable weekend days to select from the calendar
                          if (date.weekday == 6 || date.weekday == 7) {
                            return false;
                          }

                          return true;
                        },
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
                                addToBook();
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
                      )
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
