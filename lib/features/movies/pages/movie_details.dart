import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/features/movies/pages/favourite_list.dart';
import 'package:movie_app/features/movies/services/omdb_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetails extends StatefulWidget {
  final String IMDBid;
  final bool isHome;
  MovieDetails({super.key, required this.IMDBid, required this.isHome});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool isfav = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              if (widget.isHome) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouriteList(),
                  ),
                );
              }
            },
          ),
          title: const Text("Movie Details"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: MovieServiceOmdbapi().getMoviesByIMDBid(widget.IMDBid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                isfav = snapshot.data[1];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.white,
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 20,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              width: double.maxFinite,
                              fit: BoxFit.fitWidth,
                              imageUrl: snapshot.data[0]["Poster"],
                              placeholder: (context, url) {
                                return const SpinKitCircle(color: Colors.white);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data[0]["Title"],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "⭐ " +
                                      snapshot.data[0]["Ratings"][0]["Value"],
                                  style: const TextStyle(fontSize: 15),
                                ),
                                IconButton(
                                  onPressed: () {
                                    toggleFavourite(widget.IMDBid);
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: isfav ? Colors.red : Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              snapshot.data[0]["Plot"],
                              style: const TextStyle(
                                  fontFamily: 'Avenir_light', fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      customWidget("Director  ", snapshot.data[0]["Director"]),
                      const SizedBox(height: 3),
                      customWidget("Actors    ", snapshot.data[0]["Actors"]),
                      const SizedBox(height: 3),
                      customWidget("Awards   ", snapshot.data[0]["Awards"]),
                      const SizedBox(height: 3),
                      customWidget("Language", snapshot.data[0]["Language"]),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              } else {
                return const Center(
                    child: SpinKitCircle(
                  color: Colors.white,
                ));
              }
            },
          ),
        ));
  }

  void toggleFavourite(String? imdbID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> fav = prefs.getStringList("favourites") ?? [];

    if (fav.contains(imdbID)) {
      fav.remove(imdbID);
      setState(() {
        isfav = false;
      });
    } else {
      fav.add(imdbID!);
      setState(() {
        isfav = true;
      });
    }

    prefs.setStringList("favourites", fav);
  }

  Future<void> isFavourite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favourites') ?? [];
    isfav = favoriteList.contains(id);
  }
}

Widget customWidget(String text1, String text2) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$text1 :  ",
          style: const TextStyle(color: Colors.grey),
        ),
        Expanded(
          child:
              Text(text2, style: const TextStyle(fontFamily: "Avenir_light")),
        ),
      ],
    ),
  );
}
