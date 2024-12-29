import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ShowRecipes.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  // List<Map<String,dynamic>> savedRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    user = auth.currentUser;
  }

  Stream<List<Map<String, dynamic>>> featchSavedData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection("UsersDB")
        .doc(user?.uid)
        .collection("SavedRecipes")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Recipes",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: featchSavedData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading data"),
              );
            }
            final savedRecipe = snapshot.data ?? [];
            if (savedRecipe.isEmpty) {
              return Center(
                child: Text("No item saved"),
              );
            }
            return ListView.builder(
                itemCount: savedRecipe.length,
                itemBuilder: (context, index) {
                  final recipe = savedRecipe[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          Showrecipes(recipe: savedRecipe[index])));
                    },
                    child: ListTile(
                      leading: recipe['imageUrl'] != null
                          ? Image.network(
                        recipe['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ) : Icon(Icons.fastfood),
                      title: Text(recipe['title'] ?? "Unknown recipe"),
                      subtitle: Text(recipe['category'] ?? "Unknown recipe"),
                    ),
                  );
                });
          }),
    );
  }
}
