import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/fullScreen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});
  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchApi();
  }
  List images  = [];
  int page = 1;

  String query = "nature";
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;

  fetchApi() async{
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80&page=$page"),
        headers: {
          'Authorization' : 'MzE1kZGTc57BROJPdNFqVfYLpt7ubyYHieCsapxy9IFJMk78o3J8LfBU'
        }).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
    });
  }

  loadMore() async{
    setState(() {
      page = page + 1;
    });
    String url = isSearch
        ? "https://api.pexels.com/v1/search?query=$query&per_page=80&page=$page"
        : "https://api.pexels.com/v1/curated?per_page=80&page=$page";

    await http.get(Uri.parse(url),
        headers: {
          'Authorization' : 'MzE1kZGTc57BROJPdNFqVfYLpt7ubyYHieCsapxy9IFJMk78o3J8LfBU'
        }).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  void searchImages() async{
    setState(() {
      query = _searchController.text;
      print(query);
      page = 1;
      isSearch = query.isNotEmpty;
    });

    String url = "https://api.pexels.com/v1/search?query=$query&per_page=80&page=$page";
    await http.get(Uri.parse(url),
        headers: {
          'Authorization' : 'MzE1kZGTc57BROJPdNFqVfYLpt7ubyYHieCsapxy9IFJMk78o3J8LfBU'
        }).then((value){
      Map result2 = jsonDecode(value.body);
      setState(() {
        images = result2['photos'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search Wallpapers",
            border: InputBorder.none,
          ),
          onSubmitted: (value) => searchImages(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: searchImages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    childAspectRatio: 2/3,
                    mainAxisSpacing: 2
                ),
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fullscreen(
                                  imageUrl: images[index]['src']['large2x'])));
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image.network(images[index]['src']['tiny'],
                        fit: BoxFit.cover,),
                    ),
                  );
                }
            ),
          )),
          InkWell(
            onTap: loadMore,
            child: Container(child: Center(
              child: Text("Load More",
                style: TextStyle(
                    fontSize: 20,color: Colors.white
                ),),
            )),
          ),

        ],
      ),
    );
  }
}
