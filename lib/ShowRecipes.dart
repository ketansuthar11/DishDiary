import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Showrecipes extends StatefulWidget {
  final Map<String, dynamic> recipe;
  const Showrecipes({super.key, required this.recipe});

  @override
  State<Showrecipes> createState() => _ShowrecipesState();
}

class _ShowrecipesState extends State<Showrecipes> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;


  bool isFullContentVisible = false;
  bool liked = false;

  Future<void> savedRecipes(Map<String, dynamic> data,String userId)async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try{
        String docId = data['idMeal'];
        Map<String, dynamic> documentData = {
        'title': data['strMeal'],
        'category': data['strCategory'],
        'imageUrl': data['strMealThumb'], // Store the image URL
        'isLiked': true,
      };
      await firestore.collection("UsersDB").doc(userId).collection("SavedRecipes").doc(docId).set(documentData);
      print("Data with image URL saved successfully!");
    }
    catch(e){
      print("Error in storing data: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser(){
    user = auth.currentUser;
  }
  
  @override
  Widget build(BuildContext context) {
    String instruction = widget.recipe['strInstructions'] ??  "Not found";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['strMeal'],style: Theme.of(context).textTheme.titleLarge,),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                const SizedBox(height: 20,),
              // ListTile(
              //   leading: IconButton(onPressed: (){
              //   }, icon: const Icon(CupertinoIcons.back,size: 30,)),
              //   trailing: IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.heart_circle,size: 30,)),
              // ),

              if (widget.recipe['strMealThumb'] != null)
          Padding(
          padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.brown, // Shadow color
                blurRadius: 10,        // Blur radius
                offset: Offset(0, 4),
              )
            ]
          ),
          child: clipRect('strMealThumb',BoxFit.cover, double.infinity,250,)
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 25,),
                IconButton(
                      onPressed: () {
                        savedRecipes(widget.recipe,user!.uid);
                      setState(() {
                        liked = !liked;
                      });
                    },
                    icon: liked?Icon(CupertinoIcons.heart_fill,size: 30,color:Colors.red):Icon(CupertinoIcons.heart,size: 30,color:Colors.grey)
                ),
                Text(liked?
                  "Liked":"Like",
                  style: GoogleFonts.nunito(fontSize: 20,),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            sectionTile("Ingredients"),
            const SizedBox(height: 10,),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  String ingredient =
                      widget.recipe['strIngredient${index + 1}'] ?? '';
                  String measure =
                      widget.recipe['strMeasure${index + 1}'] ?? '';
                  final String imageUrl = "https://www.themealdb.com/images/ingredients/${ingredient.trim()}.png";
                  if (ingredient.trim().isNotEmpty && measure.trim().isNotEmpty) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Image.network(imageUrl,width: 50, // Set width for the image
                            height: 50, // Set height for the image
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),),
                          title: Text(ingredient,style: GoogleFonts.nunito(
                            fontSize: 17,fontWeight: FontWeight.bold
                          ),),
                          trailing: Text(measure,style: GoogleFonts.nunito(
                            fontSize: 15,
                          ),),
                        ),
                        const Divider(),
                      ],
                    );
                  }
                }),
            const SizedBox(height: 30,),
            sectionTile("Recipe process"),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFullContentVisible
                        ? instruction
                        : instruction.length > 206
                        ? instruction.substring(0, 206)
                        : instruction,
                    style: GoogleFonts.nunito(fontSize: 18,color:Colors.black,),
                    textAlign: TextAlign.justify,
                  ),
                  if(instruction.length>206)
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isFullContentVisible = !isFullContentVisible;
                        });
                      },
                      child: Text(isFullContentVisible ? 'show less' : 'Read more...', style: Theme.of(context).textTheme.bodySmall),
                      ),
                ],
              ),
            ),
          ],
        ),
      )
      ],
    ),
    ),
    ),
    );
  }

  Widget sectionTile(String s) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight:Radius.circular(30) ,topLeft:Radius.circular(30),),
          color: Theme.of(context).primaryColor
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30,top: 5),
        child: Text(
          s,
          style: GoogleFonts.nunito(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
    );
  }
  Widget clipRect(item,fit,width,height){
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          widget.recipe[item] ?? null,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
        )
    );
  }
}
