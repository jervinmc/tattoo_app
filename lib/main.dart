
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tattoo_ap/pages/add_design/views.dart';
import 'package:tattoo_ap/pages/artist_tattoo/views.dart';
import 'package:tattoo_ap/pages/artists/views.dart';
import 'package:tattoo_ap/pages/augmented/views.dart';
import 'package:tattoo_ap/pages/designs/views.dart';
import 'package:tattoo_ap/pages/details/views.dart';
import 'package:tattoo_ap/pages/home/views.dart';
import 'package:tattoo_ap/pages/register/views.dart';
import 'package:tattoo_ap/pages/transactions/views.dart';

import 'pages/login/views.dart';
void main() async{
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter',
      theme: ThemeData(
      ),
      getPages: [
        GetPage(name: "/starting", page:()=>Login()),
        GetPage(name: "/register", page:()=>SignUp()),
        GetPage(name: "/home", page:()=>Home()),
        GetPage(name: "/details", page:()=>Details()),
         GetPage(name: "/carts", page:()=>Carts()),
         GetPage(name: "/augmented", page:()=>AugmentedR()),
         GetPage(name: "/artist", page:()=>Artists()),
         GetPage(name: "/artist_tattoo", page:()=>ArtistTattoo()),
         GetPage(name: "/designs", page:()=>Designs()),
         GetPage(name: "/add_design", page:()=>AddDesign()),
        // GetPage(name: "/signup", page:()=>SignUp()),
        // GetPage(name: "/profile", page:()=>Profile()),
        // GetPage(name: "/resetPassword", page:()=>ResetPassword()),
        // GetPage(name: "/receiptList", page:()=>receiptList()),
        // GetPage(name: "/receipt", page:()=>receipt()),
        // GetPage(name: "/products", page:()=>Products()),
        // GetPage(name: "/cart", page:()=>Cart()),
        // GetPage(name: "/favorites", page:()=>Favorites()),
        // GetPage(name: "/product_details", page:()=>ProductDetails()),
      ],
      initialRoute: "/starting"  ,
    );
  }
}
