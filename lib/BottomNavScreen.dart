import 'package:flutter/material.dart';
import 'package:recipes/HomePage.dart';
import 'package:recipes/WishList.dart';
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentpage = 0;
  List <Widget> page = [HomePage(),Wishlist()];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async => false,
        child: IndexedStack(
          index: currentpage,
          children: page,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.blueAccent,
          // backgroundColor: Color.fromRGBO(253, 113, 52, 0.7450980392156863),
          onTap: (value){
            setState(() {
              currentpage = value;
            });
          },
          currentIndex: currentpage,
          items:const  [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: 'Liked',
            ),
          ]
      ),
    );;
  }
}
