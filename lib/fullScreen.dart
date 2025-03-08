import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class Fullscreen extends StatefulWidget {
  final String imageUrl;
  const Fullscreen({super.key, required this.imageUrl});

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {

  Future<void> setWallpaper() async{
    try{
      int location = WallpaperManager.BOTH_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

      bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);
    }on PlatformException {}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: Image.network(widget.imageUrl),
                )
            ),
            InkWell(
              onTap: setWallpaper,
              child: Container(child: Center(
                child: Text("Set Wallpaper",
                  style: TextStyle(
                      fontSize: 20,color: Colors.white
                  ),),
              )),
            )
          ],
        ),
      ),
    );
  }
}
