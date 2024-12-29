import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes/Authentication/Wrapper.dart';
import 'package:recipes/WishList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: GoogleFonts.nunito(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
          bodySmall: GoogleFonts.nunito(fontSize: 17,color: Colors.purple),
        ),
        primaryColor: Color.fromRGBO(253, 113, 52, 0.7450980392156863),
        appBarTheme: const AppBarTheme(backgroundColor: Color.fromRGBO(253, 113, 52, 0.7450980392156863)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Wrapper(),
    );
  }
}