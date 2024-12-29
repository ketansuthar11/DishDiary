import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:recipes/ShowRecipes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  // List<String> history = [];
  List<dynamic> recipes = [];
  bool _showSearchBar = false;
  final user = FirebaseAuth.instance.currentUser;
  String userName = 'User';
  String email = 'Email';
  final TextEditingController _serachController = TextEditingController();

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
    });
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('UsersDB')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'] ?? 'User';
            email = userDoc['email'] ?? 'Email';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> featchData(String query) async {
    final String apiurl =
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$query";
    try {
      final response = await http.get(Uri.parse(apiurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        recipes = data['meals'] ?? [];
        setState(() {
          // if (history.length>9 && !history.contains(query)){
          //   history.removeAt(0);
          // }
          // else{
          //   history.remove(query);
          // }
          // history.add(query);
          isLoading = false;
        });
        print("Api data featched");
        // print(history);
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error while featching data: $e");
    }
  }

  void search() {
    if (_serachController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      featchData(_serachController.text);
    }
  }

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 229,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                    child: Image.asset(
                      "assets/foodbanner.jpg",
                      fit: BoxFit.cover,
                      height: 229,
                      width: double.infinity,
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    height: 229,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 25),
                      ListTile(
                        title: Text(
                          userName.toUpperCase(),
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(255, 126, 79, 1.0),
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: const Color.fromRGBO(255, 126, 79, 1.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                          radius: 23,
                          backgroundColor: Color.fromRGBO(255, 204, 183, 1.0),
                        ),
                        trailing: IconButton(
                          onPressed: toggleSearchBar,
                          icon: const Icon(
                            Icons.search,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      if (_showSearchBar)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: TextField(
                            controller: _serachController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              search();
                            },
                            decoration: InputDecoration(
                              hintText: "Search for recipes",
                              hintStyle: GoogleFonts.nunito(fontSize: 17),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("I would like to cook",
                      style: GoogleFonts.nunito(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(253, 113, 52, 0.7450980392156863)),

                    //Premium block
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("          Unlock\nUnlimited Recipes",
                            style: GoogleFonts.nunito(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        TextButton(
                            onPressed: () {},
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.black)),
                            child: Text(
                              "Go Premium",
                              style: GoogleFonts.nunito(color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Latest Recipes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : recipes.isEmpty
                          ? const Center(child: Text("No recipes found"))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Showrecipes(recipe: recipes[index]),
                                      ),
                                    );
                                    print("$index tapped");
                                  },
                                  child: ListTile(
                                      title: Text(
                                          recipe['strMeal'] ?? "Not found"),
                                      subtitle: Text(recipe['strCategory'] ??
                                          'No Category'),
                                      leading: recipe['strMealThumb'] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                recipe['strMealThumb'],
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null),
                                );
                              })
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: const Icon(Icons.login_rounded),
      ),
    );
  }
}
